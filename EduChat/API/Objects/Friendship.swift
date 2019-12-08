//
//  Friendship.swift
//  EduChat
//
//  Created by Tom Knighton on 07/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public class Friendship : Mappable, Codable {
    
    var FirstUserId : Int?
    var SecondUserId : Int?
    var IsBlocked : Bool?
    var IsBestFriend : Bool?
    
    var User1 : User?
    var User2 : User?
    
    public init?(FirstUserId: Int, SecondUserId: Int, IsBlocked: Bool, IsBestFriend : Bool) {
        self.FirstUserId = FirstUserId; self.SecondUserId = SecondUserId
        self.IsBlocked = IsBlocked; self.IsBestFriend = IsBestFriend
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        self.FirstUserId <- map["firstUserId"]; self.SecondUserId <- map["secondUserId"]
        self.IsBlocked <- map["isBlocked"]; self.IsBestFriend <- map["isBestFriend"]
        
        self.User1 <- map["user1"]; self.User2 <- map["user2"]
    }
    
}
