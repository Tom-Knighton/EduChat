//
//  SignupNameDOB.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class SignupNameDOB: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: SkyFloatingLabelTextField!
    @IBOutlet weak var dobField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endEditingWhenViewTapped()
        
        let datePicker = UIDatePicker()
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = -11
        datePicker.datePickerMode = .date
        datePicker.maximumDate = calendar.date(byAdding: components, to: Date())
        self.dobField.inputView = datePicker
        
        self.nameField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            if textField.text?.count ?? 0 > 15 { return false }
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }

    @IBAction func continuePressed(_ sender: Any) {
        
    }
    
}
