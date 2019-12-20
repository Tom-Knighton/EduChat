//
//  ChatListCell.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var chatCover: UIImageView!
    
    @IBOutlet weak var chatLabel: UILabel!
    var chat : Chat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureWithItem(chat: Chat) {
        self.chat = chat
        //PROFILE PICTURE:
        self.chatCover.layer.cornerRadius = self.chatCover.frame.width / 2
        self.chatCover.layer.masksToBounds = true
        self.chatCover.layer.borderColor = UIColor.flatGray.cgColor
        self.chatCover.layer.borderWidth = 0.5
        
        if chat.members?.count == 1 { //Only 1 member
            self.chatCover.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? "")) //sets image to user's picture
        }
        else if chat.members?.count == 2 { //Private Chat
            self.chatCover.sd_setImage(with: URL(string: chat.members?.first(where: {$0.UserId != EduChat.currentUser?.UserId})?.User?.UserProfilePictureURL ?? ""))
            // ^ finds first member that is not current user and sets picture to theirs
        }
        else { // Group Chat
            self.chatCover.image = UIImage(named: "group")
        }
        
        // CHAT NAME:
        if chat.members?.count == 1 { // 1 member
            self.chatLabel.text = "Lonely Chat"
        }
        else if chat.members?.count == 2 { // private chat
            self.chatLabel.text = chat.members?.first(where: {$0.UserId != EduChat.currentUser?.UserId})?.User?.UserName
            
        }
        else { //Group Chat
            self.chatLabel.text = chat.chatName ?? "Group Chat"
            
        }
    }

}
