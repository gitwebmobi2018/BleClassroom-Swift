//
//  LectureViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-12.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit
import CoreBluetooth

class LectureViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Components
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    //MARK: Properties
    
    
    //MARK: override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: My Touch Event Functions
    @IBAction func loginTriggerAction(_ sender: Any) {
        let userName = userNameField.text
        let password = pwdTextField.text
        if userName == "user" && password == "123" {
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "User name or password is incorrect. Please check and try again.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
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
        //        moveView(false)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
