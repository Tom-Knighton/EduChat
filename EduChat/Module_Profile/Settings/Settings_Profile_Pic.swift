//
//  Settings_Profile_Pic.swift
//  EduChat
//
//  Created by Tom Knighton on 04/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import TOCropViewController
import SDWebImage

class Settings_Profile_Pic: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imgHolder: UIImageView!
    var hasChangedImage = false
    var changedImg : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgHolder.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? ""))
        self.imgHolder.layer.borderColor = UIColor.gray.cgColor
        self.imgHolder.layer.borderWidth = 0.5
        saveBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePicPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController() //Creates image picker
        imagePicker.sourceType = .photoLibrary //sets source to library
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil) //presents it
    }
    
    @IBAction func savePressed(_ sender: Any) {
        UserMethods.UploadUserProfilePicture(userid: EduChat.currentUser?.UserId ?? 0, img: self.changedImg!) { (User) in
            // ^ calls UploadUserProfilePicture with new image
            EduChat.currentUser = User //Sets the User to the new User object (which is exactly the same)
            
            self.navigationController?.popViewController(animated: true)//dismisses view
        }
    }
}

extension Settings_Profile_Pic : UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage //gets picked image as Image
        if image == nil { displayBasicError(title: "Error", message: "Error selecting image"); picker.dismiss(animated: true, completion: nil); return; }
        picker.dismiss(animated: true, completion: nil) //dismisses picker
        let crop = TOCropViewController(croppingStyle: .circular, image: image!)
        crop.delegate = self
        self.present(crop, animated: true, completion: nil) //Creates and presents circle cropper with selected image
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        self.imgHolder.image = image //sets imageHolder to the cropped image
        cropViewController.dismiss(animated: true, completion: nil) //dismisses cropper
        hasChangedImage = true
        changedImg = image //Stores our changed image
        saveBtn.isHidden = false //Sets save button to visible
        
    }
}
