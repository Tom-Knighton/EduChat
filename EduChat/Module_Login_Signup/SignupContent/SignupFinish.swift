//
//  SignupFinish.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import TOCropViewController

class SignupFinish: UIViewController, TOCropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var hasChosenImage = false
    var chosenImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = 90
        self.selectButton.layer.cornerRadius = 90
        self.profileImage.layer.masksToBounds = true
        self.selectButton.layer.masksToBounds = true
        
        self.profileImage.layer.borderColor = UIColor.flatGray.cgColor
        self.profileImage.layer.borderWidth = 0.5
    }

    @IBAction func selectImagePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if image == nil { displayBasicError(title: "Error", message: "Error selecting image"); picker.dismiss(animated: true, completion: nil); return; }
        picker.dismiss(animated: true, completion: nil)
        let crop = TOCropViewController(croppingStyle: .circular, image: image!)
        crop.delegate = self
        self.present(crop, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        self.profileImage.image = image
        self.selectButton.setImage(nil, for: .normal)
        cropViewController.dismiss(animated: true, completion: nil)
        hasChosenImage = true
        chosenImage = image
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        if (!hasChosenImage) { displayBasicError(title: "Error", message: "Please select an image"); return; }
        
        self.lockAndDisplayActivityIndicator(enable: true)
        let newUsr = User(UserId: 0, UserEmail: SignUp_Host.signupVars.email, UserName: SignUp_Host.signupVars.username, UserFullName: SignUp_Host.signupVars.name, UserProfilePictureURL: "null", UserSchool: SignUp_Host.signupVars.school, UserGender: SignUp_Host.signupVars.gender, UserDOB: SignUp_Host.signupVars.DOB, IsModerator: false, IsAdmin: false, IsDeleted: false, UserPassHash: SignUp_Host.signupVars.passHash)
        UserMethods.CreateNewUser(usr: newUsr!) { (User, Error) in
            if Error != nil { self.displayBasicError(title: "Error", message: "An error occurred creating this user, please try again"); return; }
            
            UserMethods.UploadUserProfilePicture(userid: User?.UserId ?? 0, img: self.chosenImage, completion: { (User) in
                self.lockAndDisplayActivityIndicator(enable: false)
                self.displayBasicError(title: "Success", message: "User Created")
            })
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}