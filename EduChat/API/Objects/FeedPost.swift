//
//  FeedPost.swift
//  EduChat
//
//  Created by Tom Knighton on 31/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper
import MessageKit

public class FeedLike: Mappable, Codable {
    var UserId: Int?
    var PostId: Int?
    var IsLiked: Bool?
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.UserId <- map["userId"]; self.PostId <- map["postId"]; self.IsLiked <- map["isLiked"]
    }
    
    public init?(UserId: Int?, PostId: Int?, IsLiked: Bool?) {
        self.UserId = UserId; self.PostId = PostId; self.IsLiked = IsLiked;
    }
    
}

public class FeedTextPost : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.PostId <- map["postId"]; self.PosterId <- map["posterId"];
        self.SubjectId <- map["subjectId"]; self.PostType <- map["postType"];
        self.DatePosted <- map["datePosted"]; self.IsAnnouncement <- map["isAnnouncement"];
        self.IsDeleted <- map["isDeleted"]
        self.PostText <- map["postText"]
        self.Poster <- map["poster"]
        self.Likes <- map["likes"]
    }
    
    var PostId : Int?
    var PosterId : Int?
    var SubjectId : Int?
    var PostType : String?
    var DatePosted : Date?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var PostText : String?
    
    var Likes : [FeedLike]?
    var Poster : User?; var Subject : Subject?
    
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: Date, IsAnnouncement: Bool, IsDeleted: Bool, PostText : String) {
        self.PostId = PostId; self.PosterId = PosterId; self.SubjectId = SubjectId; self.PostType = PostType
        self.DatePosted = DatePosted; self.IsAnnouncement = IsAnnouncement; self.IsDeleted = IsDeleted; self.PostText = PostText
    }
    
    public func isLiked() -> Bool {
        return self.Likes?.contains(where: {$0.UserId == EduChat.currentUser?.UserId ?? 0}) ?? false
        //Returns true if the [Likes] array contains an object with the current user's id.
    }
    
    public func modifyLike(like: Bool, postid: Int) {
        if like && (self.Likes?.contains(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0}) == false) {
            self.Likes?.append(FeedLike(UserId: EduChat.currentUser?.UserId ?? 0, PostId: postid, IsLiked: like)!)
        }
        else {
            if (self.Likes?.contains(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0 })) == true {
                self.Likes?.removeAll(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0})
            }
        }
    }
}

public class FeedMediaPost : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.PostId <- map["postId"]; self.PosterId <- map["posterId"];
        self.SubjectId <- map["subjectId"]; self.PostType <- map["postType"];
        self.DatePosted <- map["datePosted"]; self.IsAnnouncement <- map["isAnnouncement"];
        self.IsDeleted <- map["isDeleted"]
        self.UrlToPost <- map["urlToPost"]
        self.PostDescription <- map["postDescription"]
        self.IsVideo <- map["isVideo"]
        self.Poster <- map["poster"]
        self.Likes <- map["likes"]
    }
    
    var PostId : Int?
    var PosterId : Int?
    var SubjectId : Int?
    var PostType : String?
    var DatePosted : Date?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var UrlToPost : String?
    var PostDescription : String?
    var IsVideo : Bool?
    
    var Likes : [FeedLike]?
    var Poster : User?; var Subject : Subject?
    
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: Date, IsAnnouncement: Bool, IsDeleted: Bool, UrlToPost : String, PostDescription: String, IsVideo: Bool) {
        self.PostId = PostId; self.PosterId = PosterId; self.SubjectId = SubjectId; self.PostType = PostType
        self.DatePosted = DatePosted; self.IsAnnouncement = IsAnnouncement; self.IsDeleted = IsDeleted; self.UrlToPost = UrlToPost; self.PostDescription = PostDescription;
        self.IsVideo = IsVideo
    }
    
    public func isLiked() -> Bool {
        return self.Likes?.contains(where: {$0.UserId == EduChat.currentUser?.UserId ?? 0}) ?? false
        //Returns true if the [Likes] array contains an object with the current user's id.
    }
    
    public func modifyLike(like: Bool, postid: Int) {
        if like && (self.Likes?.contains(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0}) == false) {
            self.Likes?.append(FeedLike(UserId: EduChat.currentUser?.UserId ?? 0, PostId: postid, IsLiked: like)!)
        }
        else {
            if (self.Likes?.contains(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0 })) == true {
                self.Likes?.removeAll(where: { $0.UserId == EduChat.currentUser?.UserId ?? 0})
            }
        }
    }
}

public class FeedComment : Mappable, Codable {
    var CommentId: Int?
    var UserId: Int?
    var PostId: Int?
    var Comment: String?
    var IsAdmin: Bool?
    var IsDeleted: Bool?
    var DatePosted : String?
    var commenter: User?
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.CommentId <- map["commentId"]; self.UserId <- map["userId"]
        self.PostId <- map["postId"]; self.Comment <- map["comment"]
        self.IsAdmin <- map["isAdmin"]; self.IsDeleted <- map["isDeleted"]
        self.commenter <- map["user"]
        self.DatePosted <- map["datePosted"]
    }
    
    public init?(UserId: Int, PostId: Int, Comment: String, IsAdmin: Bool, IsDeleted: Bool) {
        self.CommentId = 0; self.UserId = UserId; self.PostId = PostId;
        self.Comment = Comment; self.IsAdmin = IsAdmin; self.IsDeleted = IsDeleted;
        DatePosted = Date().toString()
    }
}

