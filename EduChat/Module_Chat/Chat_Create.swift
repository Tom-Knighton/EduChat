//
//  Chat_Create.swift
//  EduChat
//
//  Created by Tom Knighton on 11/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
protocol ChatCreateUpdater {
    func addToList(userid: Int)
    func removeFromList(userid: Int)
    func getSelectedUsers() -> [Int]
}
class Chat_Create: UITableViewController, ChatCreateUpdater {
    
    var selectedUsers : [Int] = [EduChat.currentUser?.UserId ?? 0] //Array of selected users
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Chat"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(createChat))
    }
    
    @objc func createChat() {
        self.selectedUsers.sort() //Sorts array to match API
        if !self.selectedUsers.contains(where: {$0 == EduChat.currentUser?.UserId ?? 0}) { self.selectedUsers.append(EduChat.currentUser?.UserId ?? 0)}
        // ^ If our selected user array does not contain us (for some reason), add our id
        var canChatBeCreated = true //Set canbecreated to true
        for chat in EduChat.currentUser?.Chats ?? [] { //For each chat in our user's chats
            if chat.memberIds == self.selectedUsers { //If the chat's memberId array matches our selected user array
                canChatBeCreated = false; break; //Set canbecreated to false and break out of the for loop
            }
        }
        if !canChatBeCreated { //If chat already exists
            print("CHAT EXIST")
        }
        else {
            if self.selectedUsers.count > 2 { //Group Chat
                let alert = UIAlertController(title: "Create A Chat", message: "Please choose a name for this group chat", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { $0.placeholder = "My Group Chat" }) //Adds text field to alert
                alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in //Adds 'Create' button'
                    self.lockAndDisplayActivityIndicator(enable: true) //Locks display
                    let chat : Chat = Chat(chatId: 0, chatName: alert.textFields?[0].text ?? "", isProtected: false, isPublic: false, isDeleted: false, dateCreated: Date().toString())! //Creates the Chat object, with the group name and current date
                    chat.memberIds = self.selectedUsers //Attaches the memberids array to the chat object
                    ChatMethods.CreateNewChat(chat: chat, completion: { (resChat) in //Calls CreateNewChat() API method
                        if resChat != nil { //Success!
                            self.lockAndDisplayActivityIndicator(enable: false) //Unlocks display
                            EduChat.currentUser?.Chats?.append(resChat!) //Adds the returned chat to our user object
                            self.navigationController?.popViewController(animated: true) //Removes the view (for now)
                        }
                        else { //If fail
                            self.lockAndDisplayActivityIndicator(enable: false) //Unlocks display
                            self.displayBasicError(title: "Error", message: "An error occurred creating this chat") //Show error
                        }
                    })
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds cancel button
                self.present(alert, animated: true, completion: nil) //Presents alert on screen
            }
            else if self.selectedUsers.count == 2 { //Private Chat
                self.lockAndDisplayActivityIndicator(enable: true) //Locks display
                let chat : Chat = Chat(chatId: 0, chatName: "Private Chat", isProtected: false, isPublic: false, isDeleted: false, dateCreated: Date().toString())! //Creates chat object with the current date
                chat.memberIds = self.selectedUsers //Adds the member ids to the chat object
                ChatMethods.CreateNewChat(chat: chat, completion: { (resChat) in //Calls the CreateNewChat() API method
                    if resChat != nil { //Success!
                        self.lockAndDisplayActivityIndicator(enable: false) //Unlocks the display
                        EduChat.currentUser?.Chats?.append(resChat!) //Adds the returned chat to our user object
                        self.navigationController?.popViewController(animated: true) //Removes the view (for now)
                    }
                    else { // If fail
                        self.lockAndDisplayActivityIndicator(enable: false) //Unlocks display
                        self.displayBasicError(title: "Error", message: "An error occurred creating this chat") //Show error
                    }
                })
            }
            else if self.selectedUsers.count == 1 { //If no users selected
                self.displayBasicError(title: "???", message: "You cannot make an empty chat") //Show error
            }
        } 
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //1 section
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EduChat.currentUser?.Friendships?.filter{ $0.IsBlocked == false }.count ?? 0 //gets all our users that aren't blocked
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatCreateUserCell", for: indexPath) as? ChatCreateUserCell else { return UITableViewCell() } //Gets our cell
        cell.ChatCreateDelegate = self //Sets our custom delegate to ourselves
        cell.configureWithItem(user: EduChat.currentUser?.Friendships?.filter{ $0.IsBlocked == false }[indexPath.row].User2) //Configures with each user
        return cell //returns it
    }
    
    func addToList(userid: Int) {
        if(!selectedUsers.contains(userid)) { selectedUsers.append(userid) } //Adds to list as long as its not there already
        self.tableView.reloadData()
    }
    func removeFromList(userid: Int) {
        if(selectedUsers.contains(userid)) { selectedUsers.removeAll(where: {$0 == userid}) } //Removes from list if it is there
        self.tableView.reloadData()
    }
    func getSelectedUsers() -> [Int] {
        return self.selectedUsers
    }

}
