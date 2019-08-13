//
//  SignUp_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ChameleonFramework

class SignUp_Host: UINavigationController {

    public struct signupVars {
        var email : String
        var username : String
        var name : String
        var school : String
        var DOB : Date
        var passHash : String
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
}
