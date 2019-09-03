//
//  Profile_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 03/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class Profile_Host: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle.title = EduChat.currentUser?.UserName ?? "My Profile"
        //sets title to username
    }
    

    @IBAction func settingsButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            EduChat.currentUser = nil
            EduChat.isAuthenticated = false
            UserDefaults.standard.set(-1, forKey: "CacheUserId")
            UserDefaults.standard.set("", forKey: "CacheUserEmail")
            UserDefaults.standard.set("", forKey: "CacheUserPass")
            let view = UIStoryboard(name: "Login_Signup", bundle: nil).instantiateInitialViewController()
            UIApplication.topViewController()?.present(view!, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //For now, when settings is pressed simply ask user if they want to log out
    }
    
    @IBAction func subjectsButtonPressed(_ sender: Any) {
        
    }
    
}
