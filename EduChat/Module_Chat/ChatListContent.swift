
//
//  ChatListContent.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import SDWebImage

protocol ChatListDelegate {
    func updateOrRefreshList()
    func updateChat(chatId: Int, chat: Chat)
}


class ChatListContent: UIViewController {

    @IBOutlet weak var chatTable: UITableView!
    
    var chatListContent : [Chat] = []
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        loadData()
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
    
    @IBAction func createChatPressed(_ sender: Any) {
        let v = (storyboard?.instantiateViewController(withIdentifier: "createChatTable"))
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
        guard let cell = self.chatTable.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as? ChatListCell else { return UITableViewCell() } //gets cell as ChatListCell, on fail just return
        let chat = self.chatListContent.sorted(by: {$0.lastModified?.toDate().compare($1.lastModified?.toDate() ?? Date()) == .orderedDescending})[indexPath.row] //Get the chat from our list, sorted by most recently modified
        cell.configureWithItem(chat: chat) //Calls the cell configure method
        cell.chatListDelegate = self
        return cell //return the modified cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatView") as! Chat_View //gets the view controller
        vc.currentChat = self.chatListContent.sorted(by: {$0.lastModified?.toDate().compare($1.lastModified?.toDate() ?? Date()) == .orderedDescending})[indexPath.row] //Gets the chat from our list, sorted by most recently modified
        self.navigationController?.pushViewController(vc, animated: true) //adds the view to the screen
    }
    
    
}

extension ChatListContent : ChatListDelegate {
    func updateOrRefreshList() {
        self.loadData()
    }
    
    func updateChat(chatId: Int, chat: Chat) {
        let index = self.chatListContent.firstIndex(where: {$0.chatId == chatId} )
        self.chatListContent[index ?? 0] = chat
        let indexPath = IndexPath(row: index ?? 0, section: 0)
        self.chatTable.reloadRows(at: [indexPath], with: .fade)
    }
}

