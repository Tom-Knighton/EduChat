//
//  Login_Signup_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 12/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ChameleonFramework

class Login_Host: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        self.endEditingWhenViewTapped()

        self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])

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
