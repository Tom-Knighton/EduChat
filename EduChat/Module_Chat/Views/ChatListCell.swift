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
    
    var chatListDelegate : ChatListDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWithItem(chat: Chat) {
        self.chat = chat
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongTap(_:)))
        self.addGestureRecognizer(longTap)
        //PROFILE PICTURE:
        self.chatCover.layer.cornerRadius = self.chatCover.frame.width / 2
        self.chatCover.layer.masksToBounds = true
        self.chatCover.layer.borderColor = UIColor.flatGray().cgColor
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
    
    @objc func didLongTap(_ sender : UILongPressGestureRecognizer) {
        /*let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as? Profile_Content)!
        UserMethods.GetUserById(userid: 1) { (usr, err) in
            if usr != nil { vc.currentUser = usr;         UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true) }
        }*/
        
        if sender.state == .began { //Only recognise 1 tap
            let alert = UIAlertController(title: "Chat Options", message: "Select an option", preferredStyle: .actionSheet)
            if chat?.members?.count ?? 0 > 2 { // IF GROUP CHAT // ^ Creates action sheet
                alert.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (_) in //adds change name action
                        let alert = UIAlertController(title: "Change Chat Name", message: "Enter the new name for the chat:", preferredStyle: .alert) //Creates alert view
                        alert.addTextField(configurationHandler: { (text) in //adds text field to chat
                            text.autocorrectionType = .default; text.autocapitalizationType = .words
                        })
                        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in //adds confirm action
                            guard let textField = alert.textFields?[0] else { return } //Gets text field
                            let name = textField.text?.trim() //Trims text
                            if name == "" || name == " " { return } //if text is null, return
                            ChatMethods.ModifyChatName(chatid: self.chat?.chatId ?? 0, newName: name ?? "Group Chat", completion: { (chat) in //Calls ModifyChatName
                                if let chat = chat { //if chat is returned
                                    self.chat = chat //Set our chat object to the new one
                                    self.chatListDelegate?.updateChat(chatId: self.chat?.chatId ?? 0, chat: chat)
                                    //Update the chat list
                                }
                            })
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Cancel action
                }))
            }
            alert.addAction(UIAlertAction(title: "Leave Group", style: .destructive, handler: { (_) in //Action sheet leave
                ChatMethods.RemoveUserFromChat(userId: EduChat.currentUser?.UserId ?? 0, chatId: self.chat?.chatId ?? 0, success: { (success) in //Calls removeuser with our id
                    self.chatListDelegate?.updateOrRefreshList() //Updates chat list
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }
    }

}
