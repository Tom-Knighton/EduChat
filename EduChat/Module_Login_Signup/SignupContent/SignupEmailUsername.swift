//
//  SignupContent.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ChameleonFramework


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
        
        self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])

    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.lockAndDisplayActivityIndicator(enable: true) //Stops the user from interacting while app is working
        if self.emailField.text?.isEmail ?? false { // If email is valid email (defaults to false unless is valid)
            UserMethods.IsEmailFree(email: self.emailField.text ?? "") { (isEFree) in // isEFree is result boolean
                if isEFree { //if email is free
                    UserMethods.IsUsernameFree(username: self.usernameField.text ?? "", completion: { (isUFree) in //isUFree is result boolean
                        if isUFree { // If username is free as well
                            SignUp_Host.signupVars.email = self.emailField.text!.trim()
                            SignUp_Host.signupVars.username = self.usernameField.text!.trim() //Sets the appropriate values in signupVars
                            self.lockAndDisplayActivityIndicator(enable: false) //enables user interaction again
                            self.performSegue(withIdentifier: "signupFirstToSecond", sender: self) //Transitions to the next view
                        }
                        else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "That username is already in use!")}
                        // ^ enables interactin and informs the user the username is not free
                    })
                }
                else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "That email address is already in use!" ) }
                // ^ enables interaction and informs the user the email is not free
            }
        }
        else { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "Please enter a valid email addrress")}
        // ^ enables interaction and informs the user that the email isn't valid
       
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard #available(iOS 13, *) else {
            return
        }
        if traitCollection.userInterfaceStyle == .dark { self.view.backgroundColor = .systemBackground }
        else {
             self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
        }
    }

}
