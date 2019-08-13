//
//  User.swift
//  EduChat
//
//  Created by Tom Knighton on 10/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public struct User: Mappable, Codable {
    
    
    var UserId : Int?
    var UserEmail : String?
    var UserName : String?
    var UserFullName: String?
    var UserProfilePictureURL : String?
    var UserSchool : String?
    var UserGender : String?
    var UserDOB : Date?
    var IsModerator : Bool?
    var IsAdmin : Bool?
    var IsDeleted : Bool?
    var UserPassHash : String?
    
    
    public init?(UserId: Int, UserEmail: String, UserName: String, UserFullName: String, UserProfilePictureURL: String, UserSchool: String, UserGender: String, UserDOB: Date,
                 IsModerator: Bool, IsAdmin: Bool, IsDeleted: Bool, UserPassHash: String) {
        
        self.UserId = UserId; self.UserEmail = UserEmail; self.UserName = UserName; self.UserFullName = UserFullName; self.UserProfilePictureURL = UserProfilePictureURL
        self.UserSchool = UserSchool; self.UserGender = UserGender; self.UserDOB = UserDOB; self.IsModerator = IsModerator; self.IsAdmin = IsAdmin;
        self.UserPassHash = UserPassHash
        // ; separates multiple statementes per line
        //Init method means we can create a user object and specify the data it will be created with, i.e.
        // let usr : User = new User("test", "test" .....) etc.
    }
    
    public init? (map: Map) {}
    
    public mutating func mapping(map: Map) {
        self.UserId <- map["userId"]; self.UserEmail <- map["userEmail"]; self.UserName <- map["userName"]; self.UserFullName <- map["userFullName"]
        self.UserProfilePictureURL <- map["userProfilePictureURL"]; self.UserSchool <- map["userSchool"]; self.UserGender <- map["userGender"]; self.UserDOB <- map["userDOB"]
        self.IsModerator <- map["isModerator"]; self.IsAdmin <- map["isAdmin"]; self.IsDeleted <- map["isDeleted"]; self.UserPassHash <- map["userPassHash"]
        //Mapping function, as json will return result in camelCase rather than CamelCase
    }
    
}
