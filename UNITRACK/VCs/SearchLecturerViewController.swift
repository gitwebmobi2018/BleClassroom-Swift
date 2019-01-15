//
//  SearchLecturerViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-13.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit
import CoreBluetooth

class SearchLecturerViewController: UIViewController {
    
    //MARK: Components
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var selectClasslabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var bottomBtnLabel: UILabel!
    @IBOutlet weak var connectedImage: UIImageView!
    @IBOutlet weak var tableViewBackgroundImage: UIImageView!
    
    //MARK: Properties
    var centralManager : CBCentralManager!
    var selectedPeripheral : CBPeripheral!
    
    var peripherals = Array<CBPeripheral>()
    var deviceNames = [String]()
    
    //MARK: override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Stopping scan")
        centralManager?.stopScan()
    }
    
    //MARK: My Touch Event Functions
    @IBAction func connectBluetoothAction(_ sender: Any) {
        if bottomBtnLabel.text == "Connect" {
            if selectedPeripheral == nil {
                
            } else {
                centralManager.connect(selectedPeripheral, options: nil)
            }
        } else {
            for service in selectedPeripheral.services! {
                for characteristic in service.characteristics! {
                    let characteristic = characteristic as CBCharacteristic
                    if (characteristic.uuid.isEqual(transferCharacteristicUUID)) {
                        let uuidString = UIDevice.current.identifierForVendor?.uuidString
                        let messageText = "\(STUDENT_NAME)|\(STUDENT_ID)|\(STUDENT_COMMENT)|\(String(describing: uuidString!))|END"
                        let data = messageText.data(using: .utf8)
                        selectedPeripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                }
            }
            cleanup()
            self.navigationController?.popToViewController((self.navigationController?.children.first)!, animated: true)
        }
    }
    
    //MARK: My functions
    func changeUIWhenPeripheralConnected(_ isConnected: Bool) {
        if isConnected {
            myTable.isHidden = true
            studentLabel.isHidden = true
            selectClasslabel.backgroundColor = UIColor.green
            selectClasslabel.text = "Connected!"
            bottomBtnLabel.text = "Return to Login"
            connectedImage.isHidden = false
            tableViewBackgroundImage.isHidden = true
            self.navigationItem.setHidesBackButton(true, animated:true)
        } else {
            myTable.isHidden = false
            studentLabel.isHidden = false
            selectClasslabel.backgroundColor = UIColor.clear
            selectClasslabel.text = "SELECT CLASS:"
            bottomBtnLabel.text = "Connect"
            connectedImage.isHidden = true
            tableViewBackgroundImage.isHidden = false
            self.navigationItem.setHidesBackButton(false, animated:true)
        }
    }
    
    func presentAlertView(statusString: String) {
        let alertController = UIAlertController(title: "Warning", message: "CBCentralManager status is \(statusString). Please check your device and try again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func scan() {
        centralManager.scanForPeripherals(
            withServices: [transferServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
    }
    
    func cleanup() {
        guard selectedPeripheral.state == .connected else {
            return
        }
        guard let services = selectedPeripheral.services else {
            cancelPeripheralConnection()
            return
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                if characteristic.uuid.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
                    selectedPeripheral.setNotifyValue(false, for: characteristic)
                    return
                }
            }
        }
        selectedPeripheral = nil
        peripherals.removeAll()
        deviceNames.removeAll()
        scan()
    }
    
    func cancelPeripheralConnection() {
        centralManager.cancelPeripheralConnection(selectedPeripheral)
    }

}


extension SearchLecturerViewController: CBCentralManagerDelegate {
    //MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scan()
            break
        case .poweredOff:
            presentAlertView(statusString: "powered off")
            break
        case .resetting:
            presentAlertView(statusString: "resetting")
            break
        case .unauthorized:
            presentAlertView(statusString: "unautherized")
            break
        case .unknown:
            presentAlertView(statusString: "unknown")
            break
        case .unsupported:
            presentAlertView(statusString: "unsupported")
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let stringData = advertisementData[CBAdvertisementDataLocalNameKey] {
            let txt = stringData as! String
            if !deviceNames.contains(txt) {
                deviceNames.append(txt)
                peripherals.append(peripheral)
                myTable.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        changeUIWhenPeripheralConnected(true)
        peripheral.delegate = self
        peripheral.discoverServices([transferServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        changeUIWhenPeripheralConnected(false)
        deviceNames.removeAll()
        peripherals.removeAll()
        myTable.reloadData()
        scan()
    }
}

extension SearchLecturerViewController: CBPeripheralDelegate {
    
    //MARK: CBPeripheralDelegate
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(transferCharacteristicUUID)) {
                let uuidString = UIDevice.current.identifierForVendor?.uuidString
                let messageText = "\(STUDENT_NAME)|\(STUDENT_ID)|\(STUDENT_COMMENT)|\(String(describing: uuidString!))"
                let data = messageText.data(using: .utf8)
                peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
}

extension SearchLecturerViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPeripheral = peripherals[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let stringArray = deviceNames[indexPath.row].components(separatedBy: " : ")
        cell.textLabel?.text = stringArray[0]
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.textColor = UIColor.darkGray
        
        return cell
    }
}
