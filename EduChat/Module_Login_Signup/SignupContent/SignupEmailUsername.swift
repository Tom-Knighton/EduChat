//
//  SignupContent.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignupEmailUsername: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        self.continueButton.layer.cornerRadius = 20
        self.continueButton.layer.masksToBounds = true
        self.endEditingWhenViewTapped()
        
        self.usernameField.delegate = self
        self.emailField.delegate = self
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.lockAndDisplayActivityIndicator(enable: true)
        if self.emailField.text?.isEmail ?? false {
            UserMethods.IsEmailFree(email: self.emailField.text ?? "") { (isEFree) in
                if isEFree {
                    UserMethods.IsUsernameFree(username: self.usernameField.text ?? "", completion: { (isUFree) in
                        if isUFree {
                            SignUp_Host.signupVars.email = self.emailField.text!.trim()
                            SignUp_Host.signupVars.username = self.usernameField.text!.trim()
                            self.lockAndDisplayActivityIndicator(enable: false)
                            self.performSegue(withIdentifier: "signupFirstToSecond", sender: self)
                        }
                        else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "That username is already in use!")}
                    })
                }
                else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "That email address is already in use!" )
                    
                }
            }
        }
        else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "Please enter a valid email addrress")}
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameField {
            if textField.text?.count ?? 0 > 15 && string.count != 0 { return false }
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        if textField == emailField {
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_@-."
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        return true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
