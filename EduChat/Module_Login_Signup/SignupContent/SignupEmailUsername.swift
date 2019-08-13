//
//  SignupContent.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignupEmailUsername: UIViewController {

    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        self.continueButton.layer.cornerRadius = 20
        self.continueButton.layer.masksToBounds = true
        self.endEditingWhenViewTapped()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if self.emailField.text?.isEmail ?? false {
            UserMethods.IsEmailFree(email: self.emailField.text ?? "") { (isEFree) in
                if isEFree {
                    UserMethods.IsUsernameFree(username: self.usernameField.text ?? "", completion: { (isUFree) in
                        if isUFree {
                            self.performSegue(withIdentifier: "signupFirstToSecond", sender: self)
                        }
                        else { self.displayBasicError(title: "Error", message: "That username is already in use!")}
                    })
                }
                else { self.displayBasicError(title: "Error", message: "That email address is already in use!" )
                    
                }
            }
        }
        else { self.displayBasicError(title: "Error", message: "Please enter a valid email addrress")}
       
    }
    
    
    
    

}
