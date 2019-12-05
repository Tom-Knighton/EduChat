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
    override func viewWillAppear(_ animated: Bool) {
        self.navBarTitle.title = EduChat.currentUser?.UserName ?? "My Profile"
        if #available(iOS 11.0, *) {
            self.navBar.prefersLargeTitles = true
        }
    }

    @IBAction func settingsButtonPressed(_ sender: Any) {
        
        
        
        let v = (storyboard?.instantiateViewController(withIdentifier: "profileSettingsPage"))!
        UIApplication.topViewController()?.present(v, animated: false, completion: nil)
        
    }
    
    @IBAction func subjectsButtonPressed(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "profileSubjectManagement")
        self.present(view!, animated: true, completion: nil)
    }
    
}
