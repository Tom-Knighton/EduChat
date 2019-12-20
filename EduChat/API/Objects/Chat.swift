//
//  Chat.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

public class Chat: Mappable, Codable {
    var chatId : Int?
    var chatName : String?
    var isProtected : Bool?
    var isPublic : Bool?
    var isDeleted : Bool?
    var dateCreated : String?
    var members : [ChatMember]?
    var memberIds : [Int]?
    var lastMessage : ChatMessage?
    var lastModified : String?
    
    public init?(chatId: Int, chatName: String, isProtected: Bool, isPublic: Bool, isDeleted: Bool, dateCreated: String) {
        self.chatId = chatId; self.chatName = chatName; self.isProtected = isProtected;
        self.isPublic = isPublic; self.isDeleted = isDeleted; self.dateCreated = dateCreated
    }
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.chatId <- map["chatId"]; self.chatName <- map["chatName"]
        self.isProtected <- map["isProtected"]; self.isPublic <- map["isPublic"]
        self.isDeleted <- map["isDeleted"]; self.members <- map["members"]
        self.memberIds <- map["memberIds"]; self.dateCreated <- map["dateCreated"]
        self.lastMessage <- map["lastMessage"]
        self.lastModified = self.lastMessage == nil ? self.dateCreated : self.lastMessage?.DateCreated
    }
}

extension Chat : ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self.chatId! as NSObjectProtocol //Sets the identifier as the chatId
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === (object as! Chat) //Checks if the current chat is equal to the one we are checking
    }
    
    public func getGroupNameForSignalR() -> String {
        return "EduChat-Chat-"+String(describing: self.chatId!)
    }
    
}
