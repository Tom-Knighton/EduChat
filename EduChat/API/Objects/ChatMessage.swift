//
//  ChatMessage.swift
//  EduChat
//
//  Created by Tom Knighton on 13/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit
import MessageKit

class ChatMessage : Mappable, Codable {
    var MessageId : Int?
    var ChatId : Int?
    var UserId : Int?
    var MessageType : Int?
    var MessageText : String?
    var HasBeenEdited : Bool?
    var DateCreated : String?
    var IsDeleted : Bool?
    var User : User?
    
    
    public init? (chatid: Int, userid: Int, messageType: Int, messageText: String, dateCreated: String) {
        self.MessageId = 0; self.HasBeenEdited = false; self.IsDeleted = false;
        self.ChatId = chatid; self.UserId = userid; self.MessageType = messageType; self.MessageText = messageText; self.DateCreated = dateCreated;
    }
    
    required public init? (map: Map) { }
    
    public func mapping(map: Map) {
        self.MessageId <- map["messageId"]; self.ChatId <- map["chatId"]; self.UserId <- map["userId"]; self.MessageType <- map["messageType"]
        self.MessageText <- map["messageText"]; self.HasBeenEdited <- map["hasBeenEdited"]; self.DateCreated <- map["dateCreated"]; self.IsDeleted <- map["isDeleted"]
        self.User <- map["user"]
    }
}

extension ChatMessage : MessageType {
    var sender: SenderType {
        return self.User! // returns user from json
    }
    
    var messageId: String {
        return String(describing: self.MessageId) //returns messageid
    }
    
    var sentDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: self.DateCreated ?? "")!
        return date
    }
    
    var kind: MessageKind {
        // Type 1 = Text, Type 2 = Image, Type 3 = Video (Maybe type 4 can be post etc.)
        switch (self.MessageType ?? 1) { //Based on what 'type' the message is
        case 1: //If type is 1
            if self.MessageText?.containsOnlyEmoji ?? false && self.MessageText?.count ?? 0 < 6 { return MessageKind.emoji(self.MessageText ?? "") }
            return MessageKind.text(self.MessageText ?? "")
            // ^ If message is emoji ONLY and is less than 6 characters, return type emoji, else return normal text
        case 2:
            return MessageKind.photo(ImageMediaItem(imageURL: self.MessageText ?? "")) // If message is an image, send the URL
            
        default:
            return MessageKind.text(self.MessageText ?? "")
            // If for some reason the MessageType is not valid, return text
        }
        
    }
    

    
}
