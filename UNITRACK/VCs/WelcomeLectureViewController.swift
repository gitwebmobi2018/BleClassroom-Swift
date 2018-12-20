//
//  WelcomeLectureViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-17.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit

class WelcomeLectureViewController: UIViewController, UITextFieldDelegate {

    //MARK: Components
    @IBOutlet weak var lecturerNameTf: UITextField!
    
    //MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: My Touch Event Functions
    @IBAction func openBluetoothAction(_ sender: Any) {
        if lecturerNameTf.text?.count == 0 {
            let alertController = UIAlertController(title: "Warning!", message: "Please input lecturer name to be displayed to your students.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            LECTURER_NAME = lecturerNameTf.text!
            performSegue(withIdentifier: "OpenLectureBluetooth", sender: nil)
        }
    }
    
    //MARK: My Functions
    func moveView(_ shouldMove:Bool) {
        let movement = CGFloat(shouldMove ? -150 : 0)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin = CGPoint(x: 0, y: movement)
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.view.frame.origin.y != -150 {
            moveView(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
