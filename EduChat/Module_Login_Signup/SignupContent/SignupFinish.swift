//
//  SignupFinish.swift
//  EduChat
//
//  Created by Tom Knighton on 13/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import TOCropViewController
import ChameleonFramework

class SignupFinish: UIViewController, TOCropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var hasChosenImage = false
    var chosenImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = 90
        self.selectButton.layer.cornerRadius = 90
        self.profileImage.layer.masksToBounds = true
        self.selectButton.layer.masksToBounds = true
        
        self.profileImage.layer.borderColor = UIColor.flatGray().cgColor
        self.profileImage.layer.borderWidth = 0.5
        self.continueButton.layer.cornerRadius = 20
        self.continueButton.layer.masksToBounds = true
        
        self.view.backgroundColor = GradientColor(gradientStyle: .diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }

    @IBAction func selectImagePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
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
        // ^ if user has not chosen image display an error saying
        self.lockAndDisplayActivityIndicator(enable: true) //disable user interaction
        
        let newUsr = User(UserId: 0, UserEmail: SignUp_Host.signupVars.email, UserName: SignUp_Host.signupVars.username, UserFullName: SignUp_Host.signupVars.name, UserProfilePictureURL: "null", UserSchool: SignUp_Host.signupVars.school, UserGender: SignUp_Host.signupVars.gender, UserDOB: SignUp_Host.signupVars.DOB, IsModerator: false, IsAdmin: false, IsDeleted: false, UserPassHash: SignUp_Host.signupVars.passHash)
        // ^ Creates a new User object with values from signupVars
        UserMethods.CreateNewUser(usr: newUsr!) { (User, Error) in //Creates the user
            if Error != nil { self.displayBasicError(title: "Error", message: "An error occurred creating this user, please try again"); return; }
            // ^ if an error occurred inform the user
            UserMethods.UploadUserProfilePicture(userid: User?.UserId ?? 0, img: self.chosenImage, completion: { (User) in // If there was no error, upload the profile pic
                self.lockAndDisplayActivityIndicator(enable: false) // enable interaction again
                
                UserDefaults.standard.set(User?.UserId, forKey: "CacheUserId")
                UserDefaults.standard.set(User?.UserEmail, forKey: "CacheUserEmail")
                UserDefaults.standard.set(User?.UserPassHash, forKey: "CacheUserPass")
                DispatchQueue.main.async {
                    EduChat.currentUser = User
                    EduChat.isAuthenticated = true
                    self.performSegue(withIdentifier: "signupToMain", sender: self)
                }
                // ^ stores user details in cache data for quick login
             })
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
