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
        self.fship = friendship
        self.userImage?.sd_setImage(with: URL(string: friendship?.User2?.UserProfilePictureURL ?? ""), completed: nil)
        self.userName?.text = friendship?.User2?.UserName
        
        self.userImage?.layer.cornerRadius = 30
        self.userName?.layer.masksToBounds = true
        self.userImage?.layer.borderColor = UIColor.flatGray.cgColor
        self.userImage?.layer.borderWidth = 0.5
        
        if friendship?.IsBlocked ?? false {
            self.backgroundColor = UIColor.flatRedDark
        } else { self.backgroundColor = .white}
        
    }
    
    @IBAction func blockUserPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Warning", message: self.fship?.IsBlocked ?? false ? "Are you sure you want to unblock \(String(describing: self.fship?.User2?.UserName ?? ""))?" : "Are you sure you want to block \(String(describing: self.fship?.User2?.UserName ?? ""))?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.fship?.IsBlocked ?? false ? "Unblock User" : "Block User", style: .destructive, handler: { (_) in
            FriendshipMethods.SetBlock(userid1: EduChat.currentUser?.UserId ?? 0, userid2: self.fship?.User2?.UserId ?? 0, block: !(self.fship?.IsBlocked ?? false)) { (modFship) in
                EduChat.currentUser?.Friendships?.first(where: {$0.SecondUserId == self.fship?.User2?.UserId ?? 0})?.IsBlocked = modFship?.IsBlocked
                NotificationCenter.default.post(Notification(name: .updateFriendshipList))
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
