//
//  AppSettingsCell.swift
//  EduChat
//
//  Created by Tom Knighton on 11/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class AppSettingsSecurityCell: UITableViewCell {
    
    @IBOutlet weak var resetPasswordButton: UIButton?
    @IBOutlet weak var logoutButton: UIButton?
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to log out? You will have to re-add your account later on", preferredStyle: .alert) //Creates alert object
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in //Adds 'log out' action
            UserDefaults.standard.set("", forKey: "CacheUserPass")
            UserDefaults.standard.set("", forKey: "CacheUserId")
            UserDefaults.standard.set("", forKey: "CacheUserEmail") //^ Removes cached user defaults so user must log in again
            DispatchQueue.main.async { //On main thread
                let vc = UIStoryboard(name: "Login_Signup", bundle: nil).instantiateInitialViewController() //Gets the root view of the Login_Signup storyboard
                UIApplication.shared.keyWindow?.rootViewController = vc //Sets that view as the main view
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds cancel button
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil) //Presents alert
    }
    @IBAction func resetPasswordPressed(_ sender: UIButton) {
        
    }
}
class AppSettingsAppCell: UITableViewCell {
    @IBOutlet weak var aboutAppButton: UIButton?
    @IBOutlet weak var privacyPolicyButton: UIButton?
    @IBOutlet weak var rateAppButton: UIButton?
    @IBOutlet weak var appVersionLabel: UILabel?
    @IBOutlet weak var notificationsToggle: UISwitch?
    
    func populate() {
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
       
    }
}
