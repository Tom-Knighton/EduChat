//
//  ProfileSettingsCell.swift
//  EduChat
//
//  Created by Tom Knighton on 06/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0
import TOCropViewController

class ProfileSettingsImageCell : UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    @IBOutlet weak var UserProfileImage : UIImageView?
    @IBOutlet weak var UserProfileChangeImageButton : UIButton?
    
    var hasModifiedImage = false
    var delegate : ProfileSettingsDelegate?
    var user : User?
    
    func populate(with user: User?, newImage: UIImage? = nil) {
        self.user = user
        guard let newImage = newImage else {
            self.UserProfileImage?.sd_setImage(with: URL(string: user?.UserProfilePictureURL ?? ""), completed: nil)
            return;
        }
        self.UserProfileImage?.image = newImage
    }
    
    @IBAction func UserChangeProfilePicturePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        delegate?.displayView(vc: imagePicker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            self.UserProfileImage?.image = image
            self.hasModifiedImage = true
            let crop = TOCropViewController(croppingStyle: .circular, image: image)
            crop.delegate = self
            crop.modalPresentationStyle = .popover
            UIApplication.topViewController()?.present(crop, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        self.UserProfileImage?.image = image
        self.hasModifiedImage = true
        cropViewController.dismiss(animated: false, completion: nil)
        self.delegate?.updateProfilePicture(image)
    }
    
}
class ProfileSettingsBasicCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var ProfileUsernameField : UITextField?
    @IBOutlet weak var ProfileFullNameField : UITextField?
    @IBOutlet weak var ProfileEmailField : UITextField?
    var delegate : ProfileSettingsDelegate?
    var user : User?
    func populate(with user : User?) {
        self.user = user
        self.ProfileUsernameField?.text = user?.UserName ?? ""
        self.ProfileFullNameField?.text = user?.UserFullName ?? ""
        self.ProfileEmailField?.text = user?.UserEmail ?? ""
        self.ProfileUsernameField?.delegate = self; self.ProfileFullNameField?.delegate = self; self.ProfileEmailField?.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.user?.UserName = ProfileUsernameField?.text ?? ""; self.user?.UserFullName = self.ProfileFullNameField?.text ?? ""
        self.user?.UserEmail = self.ProfileEmailField?.text ?? ""
        self.delegate?.updateEditedUser(self.user)
    }
}

class ProfileSettingsBioCell : UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var profileBioTextField : UITextView?
    var delegate : ProfileSettingsDelegate?
    var user : User?
    func populate(with user: User?) {
        self.user = user
        self.profileBioTextField?.layer.borderColor = UIColor.systemGray.cgColor
        self.profileBioTextField?.layer.borderWidth = 0.9
        self.profileBioTextField?.delegate = self
        self.profileBioTextField?.text = user?.Bio ?? ""
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = ((self.profileBioTextField?.text ?? "") as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 180
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.user?.Bio = self.profileBioTextField?.text ?? ""
        self.delegate?.updateEditedUser(self.user)
    }
}
class ProfileSettingsDetailsCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var ProfileSchoolField : UITextField?
    @IBOutlet weak var ProfileGenderField: UITextField?
    @IBOutlet weak var ProfileDOBField: UITextField?
    
    var user : User?
    var delegate : ProfileSettingsDelegate?

    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var datePicker = UIDatePicker()
    var genderPicker = UIPickerView()
    let genders = ["Male", "Female", "Other"]
    var selectedGender = ""
    
    func populate(with user : User?) {
        self.user = user
        self.selectedGender = user?.UserGender ?? ""
        self.ProfileSchoolField?.text = user?.UserSchool ?? ""
        self.ProfileGenderField?.text = user?.UserGender ?? ""
        
        self.ProfileDOBField?.text = dateFormatter.string(from: (
            user?.UserDOB ?? "").toSimpleDate())
       
        let thirteenYearsAgo = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = thirteenYearsAgo
        datePicker.datePickerMode = .date
        self.ProfileDOBField?.inputView = datePicker
        datePicker.date = (self.user?.UserDOB ?? "").toSimpleDate()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        self.ProfileGenderField?.inputView = genderPicker
        genderPicker.delegate = self; genderPicker.dataSource = self
    }
    
    @objc func datePickerValueChanged(_ sender : UIDatePicker) {
        self.ProfileDOBField?.text = dateFormatter.string(from: sender.date)
        self.user?.UserDOB = (sender.date).toString()
        self.delegate?.updateEditedUser(self.user)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.user?.UserSchool = self.ProfileSchoolField?.text;
        self.delegate?.updateEditedUser(self.user)
    }
    
}
extension ProfileSettingsDetailsCell : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genders[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ProfileGenderField?.text = self.genders[row]
        self.user?.UserGender = self.genders[row]
        self.delegate?.updateEditedUser(self.user)
    }
    
}

class ProfileSettingsSensitiveCell : UITableViewCell {
    @IBOutlet weak var ProfileDeleteAccountButton : UIButton?
    var delegate : ProfileSettingsDelegate?

    @IBAction func ProfileDeleteAccountPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "This option is not currently implemented", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

