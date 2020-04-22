//
//  ChatFriendsCell.swift
//  EduChat
//
//  Created by Tom Knighton on 06/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class ChatFriendsCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var removeUser: UIButton?
    
    var fship : Friendship?
    func configureWithItem(friendship: Friendship?) {
        self.fship = friendship //Sets global variable to the one passed through configureItem
        self.userImage?.sd_setImage(with: URL(string: friendship?.User2?.UserProfilePictureURL ?? ""), completed: nil) //sets the image to the users
        self.userName?.text = friendship?.User2?.UserName //Sets text to the friend's name
        
        self.userImage?.layer.cornerRadius = 30
        self.userName?.layer.masksToBounds = true
        self.userImage?.layer.borderColor = UIColor.flatGray().cgColor
        self.userImage?.layer.borderWidth = 0.5 //UI For the profile pic, sets to circle and with border
        
        if friendship?.IsBlocked ?? false { //If the user is blocked
            self.backgroundColor = UIColor.flatRedDark() //Set background to a red colour
        } else { self.backgroundColor = .white} //Else set it to white
        
    }
    
    @IBAction func blockUserPressed(_ sender: Any) { //When the block button is pressed
        
        let alert = UIAlertController(title: "Warning", message: self.fship?.IsBlocked ?? false ? "Unblock or remove \(String(describing: self.fship?.User2?.UserName ?? ""))?" : "Block or remove \(String(describing: self.fship?.User2?.UserName ?? ""))?", preferredStyle: .alert) //Creates the alert asking if the user is sure they want to block/unblock the user
        alert.addAction(UIAlertAction(title: self.fship?.IsBlocked ?? false ? "Unblock User" : "Block User", style: .destructive, handler: { (_) in
            //^ Adds the block/unblock button
            FriendshipMethods.SetBlock(userid1: EduChat.currentUser?.UserId ?? 0, userid2: self.fship?.User2?.UserId ?? 0, block:  !(self.fship?.IsBlocked ?? false)) { (modFship) in //modFship is the returned friendship object
                //^ Calls the SetBlock method, with our user id and the userid of the other user, plus the opposite of whether it is currently set to block or not
                EduChat.currentUser?.Friendships?.first(where: {$0.SecondUserId == self.fship?.User2?.UserId ?? 0})?.IsBlocked = modFship?.IsBlocked
                //Finds the friendship in our user object and sets isblocked to whatever it was set to
                NotificationCenter.default.post(Notification(name: .updateFriendshipList)) //Calls updateFriendshipList
            }
        }))
        alert.addAction(UIAlertAction(title: "Remove Friend", style: .destructive, handler: { (_) in
            FriendshipMethods.RemoveFriendship(userid1: EduChat.currentUser?.UserId ?? 0, userid2: self.fship?.SecondUserId ?? 0, completion: { (remUsr) in
                let index = EduChat.currentUser?.Friendships?.firstIndex(where: { $0.SecondUserId == remUsr ?? 0 }) ?? 0
                EduChat.currentUser?.Friendships?.remove(at: index)
                NotificationCenter.default.post(Notification(name: .updateFriendshipList)) //Calls updateFriendshipList
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds the cancel button
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil) //Presents the alert
    }
    
}
