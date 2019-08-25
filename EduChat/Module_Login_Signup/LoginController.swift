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
        UIApplication.topViewController()?.lockAndDisplayActivityIndicator(enable: true)
        let AUsr = AuthenticatingUser(authenticator: authenticator ?? "", passhash: passHash ?? "") //Creates an AuthenticatingUser object
        UserMethods.AuthenticateUser(usr: AUsr!) { (usr, err) in //Calls the method in UserMethds
            if err != nil { //If there is an error returned
                UIApplication.topViewController()?.lockAndDisplayActivityIndicator(enable: false)
                let alert = UIAlertController(title: "Error", message: "The username/email or password were not recognised.", preferredStyle: .alert) //Creates an alert view
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil)) //Adds a button
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)//Displays the error message

                
            }
            else { //If there were no errors
                UIApplication.topViewController()?.lockAndDisplayActivityIndicator(enable: false)
                EduChat.currentUser = usr!
                EduChat.isAuthenticated = true
                UserDefaults.standard.set(usr?.UserId, forKey: "CacheUserId")
                UserDefaults.standard.set(usr?.UserEmail, forKey: "CacheUserEmail")
                UserDefaults.standard.set(usr?.UserPassHash, forKey: "CacheUserPass")
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.performSegue(withIdentifier: "loginToMain", sender: self)
                }
                // ^ stores user details in cache data for quick login
            }
        }
    }
    
}
