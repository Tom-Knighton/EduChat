//
//  User.swift
//  EduChat
//
//  Created by Tom Knighton on 10/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper
import MessageKit

public class User: Mappable, Codable {
    
    
    var UserId : Int?
    var UserEmail : String?
    var UserName : String?
    var UserFullName: String?
    var UserProfilePictureURL : String?
    var UserSchool : String?
    var UserGender : String?
    var UserDOB : String?
    var IsModerator : Bool?
    var IsAdmin : Bool?
    var IsDeleted : Bool?
    var UserPassHash : String?
    var Bio : String?
    
    var Subjects : [Subject]?
    var Chats : [Chat]?
    var Friendships : [Friendship]?
    
    
    public init?(UserId: Int, UserEmail: String, UserName: String, UserFullName: String, UserProfilePictureURL: String, UserSchool: String, UserGender: String, UserDOB: String,
                 IsModerator: Bool, IsAdmin: Bool, IsDeleted: Bool, UserPassHash: String) {
        
        self.UserId = UserId; self.UserEmail = UserEmail; self.UserName = UserName; self.UserFullName = UserFullName; self.UserProfilePictureURL = UserProfilePictureURL
        self.UserSchool = UserSchool; self.UserGender = UserGender; self.UserDOB = UserDOB; self.IsModerator = IsModerator; self.IsAdmin = IsAdmin;
        self.UserPassHash = UserPassHash
        // ; separates multiple statementes per line
        //Init method means we can create a user object and specify the data it will be created with, i.e.
        // let usr : User = new User("test", "test" .....) etc.
    }
    
    required public init? (map: Map) {}
    
    public func mapping(map: Map) {
        self.UserId <- map["userId"]; self.UserEmail <- map["userEmail"]; self.UserName <- map["userName"]; self.UserFullName <- map["userFullName"]
        self.UserProfilePictureURL <- map["userProfilePictureURL"]; self.UserSchool <- map["userSchool"]; self.UserGender <- map["userGender"]; self.UserDOB <- map["userDOB"]
        self.IsModerator <- map["isModerator"]; self.IsAdmin <- map["isAdmin"]; self.IsDeleted <- map["isDeleted"]; self.UserPassHash <- map["userPassHash"]; self.Subjects <- map["subjects"]
        self.Friendships <- map["friendships"]; self.Chats <- map["chats"]
        self.Bio <- map["userBio"]
        //Mapping function, as json will return result in camelCase rather than CamelCase
    }
    
    public func flatPack() -> User {
        let usr = self
        usr.Subjects = [];
        usr.Chats = [];
        usr.Friendships = [];
        return usr
    }
    
}

extension User : SenderType {
    public var senderId: String {
        return String(describing: self.UserId)
    }
    
    public var displayName: String {
        return self.UserName ?? ""
    }
}

public class UserBio : Codable, Mappable {
    var BioId : Int?
    var UserId : Int?
    var Bio : String?
    var IsCurrent : Bool?
    var DateCreated : String?
    
    public init?(UserId: Int, Bio: String) {
        self.BioId = 0; self.UserId = UserId; self.Bio = Bio; self.IsCurrent = true; self.DateCreated = Date().toString()
    }
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.BioId <- map["bioId"]; self.UserId <- map["userId"]; self.Bio <- map["bio"]
        self.IsCurrent <- map["isCurrent"]; self.DateCreated <- map["dateCreated"]
    }
}
