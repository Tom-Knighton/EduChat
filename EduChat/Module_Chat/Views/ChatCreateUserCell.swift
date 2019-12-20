//
//  ChatCreateUserCell.swift
//  EduChat
//
//  Created by Tom Knighton on 11/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class ChatCreateUserCell: UITableViewCell {
    
    var ChatCreateDelegate: ChatCreateUpdater?
    var User: User?
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userToggledSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWithItem(user: User?) { //Will be called from table view
        self.User = user //Sets global user to this one
        self.userNameLabel.text = user?.UserName ?? "" //Sets label to user's name
        self.userProfileImage.sd_setImage(with: URL(string: user?.UserProfilePictureURL ?? ""), completed: nil) //Sets image to user's image
        self.userProfileImage.layer.borderColor = UIColor.flatGray.cgColor
        self.userProfileImage.layer.borderWidth = 0.5
        self.userProfileImage.layer.cornerRadius = 30; self.userProfileImage.layer.masksToBounds = true
        let isSelected = self.ChatCreateDelegate?.getSelectedUsers().contains(user?.UserId ?? 0) //Gets from our delegate whether the user is in the array or not
        self.userToggledSwitch.setOn(isSelected ?? false, animated: false) //If the are, toggle the switch, else toggle it off
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn { self.ChatCreateDelegate?.addToList(userid: self.User?.UserId ?? 0)} //If user sets switch to on, add to list
        else { self.ChatCreateDelegate?.removeFromList(userid: self.User?.UserId ?? 0)}
        //Else, remove from list
    }
    
}
