//
//  WelcomeStudentViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-13.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class WelcomeStudentViewController: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
//MARK: Properties
    var keyBoardHeight = CGFloat()
    
//MARK: override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        keyBoardHeight = self.view.frame.size.height - firstNameView.frame.origin.y
    }
    
//MARK: My Touch Event Functions
    @IBAction func searchBDevicesTouchAction(_ sender: Any) {
        if firstNameTextField.text?.count == 0 || surnameTextField.text?.count == 0 || studentIDTextField.text?.count == 0 || commentTextField.text?.count == 0 {
            let alertController = UIAlertController(title: "Error", message: "First name, Surname, Student ID Number and Comment are mandatory! Please input all of them.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            firstNameTextField.resignFirstResponder()
            surnameTextField.resignFirstResponder()
            studentIDTextField.resignFirstResponder()
            commentTextField.resignFirstResponder()
            moveView(false)
            let firstName = firstNameTextField.text!
            let surname = surnameTextField.text!
            STUDENT_NAME = "\(firstName) \(surname)"
            STUDENT_ID = studentIDTextField.text!
            STUDENT_COMMENT = commentTextField.text!
            performSegue(withIdentifier: "SearchLecturerSegue", sender: nil)
        }
    }
    
//MARK: My Functions
    func moveView(_ shouldMove:Bool) {
        let movement = CGFloat(shouldMove ? -200 : 0)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin = CGPoint(x: 0, y: movement)
        }
    }

}

//MARK: UITextFieldDelegate
extension WelcomeStudentViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.view.frame.origin.y != -250 {
            moveView(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveView(false)
        textField.resignFirstResponder()
        return true
    }
    
}
