//
//  SignupNameDOB.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0
import ChameleonFramework


class SignupNameDOB: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: SkyFloatingLabelTextField!
    @IBOutlet weak var dobField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.endEditingWhenViewTapped()
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = -11
        datePicker.datePickerMode = .date
        datePicker.maximumDate = calendar.date(byAdding: components, to: Date())
        self.dobField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControl.Event.valueChanged)
        
        self.genderField.delegate = self
        self.genderField.inputView = UIView()
        self.nameField.delegate = self
        self.continueButton.layer.cornerRadius = 20
        self.continueButton.layer.masksToBounds = true
        
        self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
    
    @IBAction func genderFieldTapped(_ sender: SkyFloatingLabelTextField) {
            ActionSheetStringPicker.show(withTitle: "Select Gender", rows: ["Male", "Female", "Other"], initialSelection: 1, doneBlock: {
            picker, value, index in
                self.genderField.text = index as? String ?? ""
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            if textField.text?.count ?? 0 > 25 && string.count != 0 { return false }
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }

    @IBAction func continuePressed(_ sender: Any) {
        self.lockAndDisplayActivityIndicator(enable: true) //Disables user interaction
        if self.nameField.text?.trim() ?? "" != "" && self.dobField.text?.trim() ?? "" != "" && self.genderField.text?.trim() ?? "" != "" {
            // ^ if all fields have text in them
            SignUp_Host.signupVars.name = self.nameField.text!.trim() //Sets user full name to input name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            SignUp_Host.signupVars.DOB = (dateFormatter.date(from: self.dobField.text!.trim())?.toString())!
            // ^ above lines format date entered into a valid C# date
            SignUp_Host.signupVars.gender = self.genderField.text!.trim() //sets gender
            self.lockAndDisplayActivityIndicator(enable: false) //enables interaction
            self.performSegue(withIdentifier: "signupSecondToThird", sender: self) //Transitions to next view
        }
        else { self.lockAndDisplayActivityIndicator(enable: false); displayBasicError(title: "Error", message: "Please fill out all fields.")}
        // ^ enables interaction and asks user to fill out all fields
    }
    
    
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.dobField.text = dateFormatter.string(for: sender.date)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
