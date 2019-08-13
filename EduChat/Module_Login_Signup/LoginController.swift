//
//  LoginController.swift
//  EduChat
//
//  Created by Tom Knighton on 12/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

class LoginController {
    
    static func Login(authenticator: String?, passHash: String?) {
        let AUsr = AuthenticatingUser(authenticator: authenticator ?? "", passhash: passHash ?? "") //Creates an AuthenticatingUser object
        UserMethods.AuthenticateUser(usr: AUsr!) { (usr, err) in //Calls the method in UserMethds
            if err != nil { //If there is an error returned
                let alert = UIAlertController(title: "Error", message: "The username/email or password were not recognised.", preferredStyle: .alert) //Creates an alert view
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil)) //Adds a button
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)//Displays the error message
                
            }
            else { //If there were no errors
                let alert = UIAlertController(title: "Success", message: "Logged in successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ":)", style: .default, handler: nil))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil) //Same as above but success message
            }
        }
    }
    
}
