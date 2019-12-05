//
//  ChatMember.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ChatMember : Codable, Mappable {
    var ChatId : Int?
    var UserId : Int?
    var isInChat : Bool?
    
    var User : User?
    
    public init?(chatId: Int, userid: Int, isInChat: Bool) {
        self.ChatId = chatId; self.UserId = userid; self.isInChat = isInChat; self.User = nil
    }
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        self.ChatId <- map["chatId"]; self.UserId <- map["userId"]; self.isInChat <- map["isInChat"]
        self.User <- map["user"]
    }
}
