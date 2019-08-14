//
//  SignupPasswordSchool.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ChameleonFramework


class SignupPasswordSchool: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passField: SkyFloatingLabelTextField!
    @IBOutlet weak var confPass: SkyFloatingLabelTextField!
    @IBOutlet weak var schoolField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.passField.delegate = self
        self.schoolField.delegate = self
        
        self.continueButton.layer.cornerRadius = 20
        self.continueButton.layer.masksToBounds = true
        self.endEditingWhenViewTapped()
        
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_!$*"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        if textField == passField { if textField.text?.count ?? 0 > 50 && string.count != 0 { return false } else { return string == filtered } }
        return string == filtered
    }

    @IBAction func continuePressed(_ sender: Any) {
        self.lockAndDisplayActivityIndicator(enable: true)
        let pass = self.passField.text?.trim() ?? ""
        let conf = self.confPass.text?.trim() ?? ""
        var school = self.schoolField.text?.trim() ?? ""
        
        if (pass != conf) { self.lockAndDisplayActivityIndicator(enable: false); displayBasicError(title: "Error", message: "Your passwords do not match!"); return; }
        if (!pass.isValidPassword) { self.lockAndDisplayActivityIndicator(enable: false); displayBasicError(title: "Error", message: "Your password must contain one lowercase character, one uppercase character, one special character and must be 8 characters or longer."); return; }
        if (pass == "" || conf == "") { self.lockAndDisplayActivityIndicator(enable: false); displayBasicError(title: "Error", message: "Please fill out the required fields"); return;}
        if (school == "") { school = "n/a"; }
        
        SignUp_Host.signupVars.passHash = pass.encrypt
        SignUp_Host.signupVars.school = school
        self.lockAndDisplayActivityIndicator(enable: false)
        self.performSegue(withIdentifier: "signupThirdToFourth", sender: self)
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
