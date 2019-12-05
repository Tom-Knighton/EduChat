//
//  Chat_Signal.swift
//  EduChat
//
//  Created by Tom Knighton on 06/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import SwiftSignalRClient

class Chat_Signal : HubConnectionDelegate {
    func connectionDidOpen(hubConnection: HubConnection) {
        print("Chat connection opened")
        subscribeToChats()
    }
    
    func connectionDidFailToOpen(error: Error) {
        print("Chat connection failed.... retrying"); connection.start()

    }
    
    func connectionDidClose(error: Error?) {
        print("Chat connection closed")
        connection = HubConnectionBuilder(url: URL(string: "https://educhat.tomk.online/ChatHub")!).withJSONHubProtocol().build()
        connection.start()
    }
    
   // public var connection : HubConnection = HubConnectionBuilder(url: URL(string: "https://localhost:5001/ChatHub")!).build()
    private var connectionDelegate : HubConnectionDelegate?
    public var connection : HubConnection = HubConnectionBuilder(url: URL(string: "https://educhat.tomk.online/ChatHub")!).withJSONHubProtocol().build()
    
    func setup_signal() {
        connectionDelegate = self
        connection.delegate = connectionDelegate
        
        connection.on(method: "MessageRecieved", callback: {(groupToSendTo: String, userid: Int, messageId: Int) in
            do {
                let dataDict : [String: Any] = ["groupToSendTo": groupToSendTo, "senderId" : userid, "messageId": messageId]
                NotificationCenter.default.post(Notification(name: .onChatMessage, object: self, userInfo: dataDict))
            }
        })
        connection.on(method: "RemoveMessage") { (group: String, messageId: Int) in
            do {
                let dataDict : [String: Any] = ["groupToSendTo": group, "messageId": messageId]
                NotificationCenter.default.post(Notification(name: .removeMessage, object: self, userInfo: dataDict))
            }
        }
        connection.on(method: "BROADCAST", callback: {(msg: String) in
            print("Broadcast")
            print(msg)
        })
        
        connection.start()
    }
    
    
    
    func subscribeToChats() {
        ChatMethods.GetAllChatsForUser(userid: EduChat.currentUser?.UserId ?? 0) { (chats, err) in //Calls endpoint
            if err == nil { //If no erros
                for chat in chats! { //Loop throug every chat in the list returned
                    self.connection.invoke(method: "SubscribeToGroup", chat.getGroupNameForSignalR()) { (error) in
                        //Subscribes user to group, i.e. EduChat-Chat-1. On success prints "sent message"
                    }
                }
            }
        }
    }
    
    func sendMessage(senderId: Int, groupToSendTo: String, messageId: Int) {
        self.connection.invoke(method: "SendMessage", senderId, groupToSendTo, messageId) { (err) in  }
    }
    func removeMessage(groupId: String, messageId: Int) {
        self.connection.invoke(method: "DeleteMessage", groupId, messageId) { (err) in }
    }
}
