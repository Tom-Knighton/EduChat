//
//  ViewController.swift
//  EduChat
//
//  Created by Tom Knighton on 10/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        UserMethods.UploadUserProfilePicture(userid: 10, img: #imageLiteral(resourceName: "pengu"), completion: nil)
        
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        
        authenticatorPassField.layer.borderWidth = 1
        loginPassField.layer.borderWidth = 1
        authenticatorPassField.layer.backgroundColor = UIColor.flatGray.cgColor
        loginPassField.layer.borderColor = UIColor.flatGray.cgColor
        authenticatorPassField.layer.cornerRadius = 10
        authenticatorPassField.layer.masksToBounds = true
        loginPassField.layer.cornerRadius = 10
        loginPassField.layer.masksToBounds = true
        
    }

    
    @IBOutlet weak var authenticatorPassField: UITextField!
    @IBOutlet weak var loginPassField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Log_Sign mem")
    }


}

