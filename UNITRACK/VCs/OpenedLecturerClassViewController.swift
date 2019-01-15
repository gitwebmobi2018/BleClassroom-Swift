//
//  OpenedLecturerClassViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-13.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit
import CoreBluetooth

class OpenedLecturerClassViewController: UIViewController {

    //MARK: Components
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var lectureTitleLabel: UILabel!
    @IBOutlet weak var closeBluetoothBtn: UIButton!
    
    //MARK: Properties
    var peripheralManager : CBPeripheralManager!
    
    var timer = Timer()
    var intervalSecond = 0
    
    var deviceNames = [String]()
    
    //MARK: override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initTimer()
        lectureTitleLabel.text = "\(LECTURER_NAME.uppercased())'s LECTURE IS OPEN"
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    //MARK: My Touch Event Functions
    @IBAction func closeSignInTouchAction(_ sender: Any) {
        createAndExportingCSVFile()
    }
    
    //MARK: Objc Functions
    @objc func calTimeSeconds() {
        intervalSecond += 1
        let min = Int(intervalSecond/60)
        let hour = Int(min/60)
        let sec = intervalSecond - min * 60
        let minString = "\(min)"
        let secString = "\(sec)"
        let hourString = "\(hour)"
        
        if hour > 0 {
            if hourString.count == 2 {
                if minString.count == 2 {
                    if secString.count == 2 {
                        timerLabel.text = "\(hourString) : \(minString) : \(secString)"
                    } else {
                        timerLabel.text = "\(hourString) : \(minString) : 0\(secString)"
                    }
                } else {
                    if secString.count == 2 {
                        timerLabel.text = "\(hourString) : 0\(minString) : \(secString)"
                    } else {
                        timerLabel.text = "\(hourString) : 0\(minString) : 0\(secString)"
                    }
                }
            } else {
                if minString.count == 2 {
                    if secString.count == 2 {
                        timerLabel.text = "0\(hourString) : \(minString) : \(secString)"
                    } else {
                        timerLabel.text = "0\(hourString) : \(minString) : 0\(secString)"
                    }
                } else {
                    if secString.count == 2 {
                        timerLabel.text = "0\(hourString) : 0\(minString) : \(secString)"
                    } else {
                        timerLabel.text = "0\(hourString) : 0\(minString) : 0\(secString)"
                    }
                }
            }
        } else {
            if minString.count == 2 {
                if secString.count == 2 {
                    timerLabel.text = "\(minString) : \(secString)"
                } else {
                    timerLabel.text = "\(minString) : 0\(secString)"
                }
            } else {
                if secString.count == 2 {
                    timerLabel.text = "0\(minString) : \(secString)"
                } else {
                    timerLabel.text = "0\(minString) : 0\(secString)"
                }
            }
        }
        
        
    }
    
    //MARK: My Functions
    
    func initTimer() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - hh:mm"
        let todayString = dateFormatter.string(from: today)
        dateLabel.text = todayString
        
        timerLabel.text = "00 : 00"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calTimeSeconds), userInfo: nil, repeats: true)
        
    }
    
    func createAndExportingCSVFile() {
        
        if deviceNames.count == 0 {
            let alertController = UIAlertController(title: "Warning", message: "Nothing student in your lecture. Are you going to cancel this class?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (yesAction) in
                self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
            })
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        peripheralManager.stopAdvertising()
        peripheralManager.removeAllServices()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        let convertedDate = dateFormatter.string(from: Date())
        let fileName = "\(LECTURER_NAME)-\(convertedDate).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Name,ID,Comment and Questions,device UUID\n"
        for task in deviceNames {
            let strArray = task.components(separatedBy: "|")
            let newLine = "\(strArray[0]),\(strArray[1]),\(strArray[2]),\(strArray[3])\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            exportingCSVFile(path: path!)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
    }
    
    func exportingCSVFile(path:URL) {
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = closeBluetoothBtn
        vc.popoverPresentationController?.sourceRect = closeBluetoothBtn.frame
        vc.completionWithItemsHandler = { activity, success, items, error in
            self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlertView(statusString: String) {
        let alertController = UIAlertController(title: "Warning", message: "CBCentralManager status is \(statusString). Please check your device and try again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func removeStudent(_ strArray: [String]) {
        var removeIndex = 9999
        for studentInfo in deviceNames {
            let studentInfoArray = studentInfo.components(separatedBy: "|")
            if studentInfoArray[3] == strArray[3] {
                removeIndex = deviceNames.index(of: studentInfo)!
            }
        }
        if removeIndex != 9999 {
            deviceNames.remove(at: removeIndex)
            myTable.reloadData()
        }
    }

}

extension OpenedLecturerClassViewController: CBPeripheralManagerDelegate {
    //MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            let serialService = CBMutableService(type: transferServiceUUID, primary: true)
            let writeCharacteristics = CBMutableCharacteristic(type: transferCharacteristicUUID, properties: .write, value: nil, permissions: .writeable)
            serialService.characteristics = [writeCharacteristics]
            peripheralManager.add(serialService)
            
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
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        let uuidString = UIDevice.current.identifierForVendor?.uuidString
        let messageText = "\(LECTURER_NAME) : (\(String(describing: uuidString!)))"
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[transferServiceUUID], CBAdvertisementDataLocalNameKey: messageText])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                
                //here is the message text that we receive, use it as you wish.
                let studentInfoString = String(data: value, encoding: String.Encoding.utf8)
                if !deviceNames.contains(studentInfoString!) {
                    let strArray = studentInfoString?.components(separatedBy: "|")
                    if strArray?.count == 5 {
                        removeStudent(strArray!)
                    } else {
                        deviceNames.append(studentInfoString!)
                        myTable.reloadData()
                    }
                }
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}

extension OpenedLecturerClassViewController: UITableViewDelegate {
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}


extension OpenedLecturerClassViewController: UITableViewDataSource {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectedDeviceNameCell", for: indexPath)
        let strArray = deviceNames[indexPath.row].components(separatedBy: "|")
        cell.textLabel?.text = strArray[0]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
}
