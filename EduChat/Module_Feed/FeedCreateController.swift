//
//  FeedCreateController.swift
//  EduChat
//
//  Created by Tom Knighton on 13/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class FeedCreateController: UITableViewController {

    @IBOutlet weak var currentUserImg: UIImageView!
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var commentView: PlaceholderTextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
   let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self //We control our image picker
        self.commentView.inputAccessoryView = self.inputAccessory() //Adds the image bar above keyboard
        self.currentUserImg.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? ""), completed: nil) //Sets the user's image in the image view
        self.currentUsername.text = EduChat.currentUser?.UserName ?? "" //Sets the label text to our username
        self.endEditingWhenViewTapped() //Close the keyboard when tapped
    }

    override func viewWillAppear(_ animated: Bool) {
        //Overriding willAppearMethod to not call super()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.commentView.becomeFirstResponder() //Bring up keyboard straight away
    }
    
}

extension FeedCreateController {
    func inputAccessory() -> UIView {
        let inputAccessory = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let navItem = UINavigationItem()
        let doneButton = UIBarButtonItem(image: UIImage(named: "image"), style: .plain, target: self, action: #selector(addImagePressed(_:)))
        navItem.rightBarButtonItem = doneButton
        
        inputAccessory.pushItem(navItem, animated: false)
        return inputAccessory
    }
    
    @objc func addImagePressed(_ selector: UIBarButtonItem) {
        self.present(picker, animated: true, completion: nil)
    }
}

extension FeedCreateController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let oImage = info[.originalImage] as? UIImage else {
            return
        }
        self.dismiss(animated: true, completion: nil)
        addImage(image: oImage)
        
    }
    
    func addImage(image: UIImage) {
        self.postImageView.image = image
        self.imageWidthConstraint.constant = 150
        self.commentView.placeholder = "Add a comment"
    }
    func removeImage() {
        self.postImageView.image = UIImage()
        self.imageWidthConstraint.constant = 0
        self.commentView.placeholder = "What do you want to say?"
    }
}
