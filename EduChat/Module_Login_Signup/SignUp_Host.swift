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
        static var email : String = ""
        static var username : String = ""
        static var name : String = ""
        static var gender : String = ""
        static var school : String = "n/a"
        static var DOB : String = ""
        static var passHash : String = ""
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
}
