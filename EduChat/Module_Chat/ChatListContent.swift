
//
//  ChatListContent.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SDWebImage

class ChatListContent: UIViewController {

    @IBOutlet weak var chatTable: UITableView!
    
    var chatListContent = [Any]()
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        loadData()
    }
    func loadData() {
        ChatMethods.GetAllChatsForUser(userid: EduChat.currentUser?.UserId ?? 0) { (chats, err) in
            if err == nil {
                self.chatListContent = chats!
                self.chatTable.reloadData()
            }
            else { print("err") }
        }
    }
    
    @IBAction func addUserPressed(_ sender: Any) {
        let v = (storyboard?.instantiateViewController(withIdentifier: "chatFriendsTable"))
        self.navigationController?.pushViewController(v ?? UIViewController(), animated: true)
    }
    
    
    
}

extension ChatListContent : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Messages"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatListContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTable.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! ChatListCell
        let chat = self.chatListContent[indexPath.row] as! Chat
        
        /* Setup: */
        
        //PROFILE PICTURE:
        if chat.members?.count == 1 { //Only 1 member
            cell.chatCover.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? "")) //sets image to user's picture
        }
        else if chat.members?.count == 2 { //Private Chat
            cell.chatCover.sd_setImage(with: URL(string: chat.members?.first(where: {$0.UserId != EduChat.currentUser?.UserId})?.User?.UserProfilePictureURL ?? ""))
            // ^ finds first member that is not current user and sets picture to theirs
        }
        else { // Group Chat
            cell.chatCover.image = UIImage(named: "pengu")
            // ^ will be replaced with group chat icon when made
        }
        
        // CHAT NAME:
        if chat.members?.count == 1 { // 1 member
            cell.chatLabel.text = "Lonely Chat"
        }
        else if chat.members?.count == 2 { // private chat
            cell.chatLabel.text = chat.members?.first(where: {$0.UserId != EduChat.currentUser?.UserId})?.User?.UserName

        }
        else { //Group Chat
            cell.chatLabel.text = chat.chatName ?? "Group Chat"
            
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatView") as! Chat_View
        vc.currentChat = self.chatListContent[indexPath.row] as? Chat
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
