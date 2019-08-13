//
//  Login_Signup_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 12/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import Pastel
import ChameleonFramework

class Login_Host: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        self.endEditingWhenViewTapped()
        /*authenticatorPassField.layer.borderWidth = 1
        loginPassField.layer.borderWidth = 1
        authenticatorPassField.layer.borderColor = UIColor.flatGray.cgColor
        loginPassField.layer.borderColor = UIColor.flatGray.cgColor
        authenticatorPassField.layer.cornerRadius = 10
        authenticatorPassField.layer.masksToBounds = true
        loginPassField.layer.cornerRadius = 10
        loginPassField.layer.masksToBounds = true
        
        authenticatorPassField.layer.backgroundColor = UIColor.flatWhite.cgColor
        loginPassField.layer.backgroundColor = UIColor.flatWhite.cgColor*/
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        LoginController.Login(authenticator: self.authenticatorPassField.text ?? "", passHash: self.loginPassField.text?.encrypt ?? "")
    }
    @IBAction func backPressed(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var authenticatorPassField: UITextField!
    @IBOutlet weak var loginPassField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

}
