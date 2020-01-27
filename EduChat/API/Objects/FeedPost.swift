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
    var DatePosted : String?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var PostText : String?
    
    var Likes : [FeedLike]?
    var Poster : User?; var Subject : Subject?
    
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: String, IsAnnouncement: Bool, IsDeleted: Bool, PostText : String) {
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
    var DatePosted : String?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var UrlToPost : String?
    var PostDescription : String?
    var IsVideo : Bool?
    
    var Likes : [FeedLike]?
    var Poster : User?; var Subject : Subject?
    
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: String, IsAnnouncement: Bool, IsDeleted: Bool, UrlToPost : String, PostDescription: String, IsVideo: Bool) {
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



public class FeedPoll : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.PostId <- map["postId"]; self.PosterId <- map["posterId"];
        self.SubjectId <- map["subjectId"]; self.PostType <- map["postType"];
        self.DatePosted <- map["datePosted"]; self.IsAnnouncement <- map["isAnnouncement"];
        self.IsDeleted <- map["isDeleted"]
        self.Answers <- map["answers"]
        self.Poster <- map["poster"]
        self.PollQuestion <- map["pollQuestion"]
        self.Likes <- map["likes"]
    }
    
    var PostId : Int?
    var PosterId : Int?
    var SubjectId : Int?
    var PostType : String?
    var DatePosted : String?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var PollQuestion : String?
    var Answers: [FeedPollAnswer]?
    var Poster : User?; var Subject : Subject?
    var Likes : [FeedLike]?
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: String, IsAnnouncement: Bool, IsDeleted: Bool, question: String) {
        self.PostId = PostId; self.PosterId = PosterId; self.SubjectId = SubjectId; self.PostType = PostType
        self.DatePosted = DatePosted; self.IsAnnouncement = IsAnnouncement; self.IsDeleted = IsDeleted;
        self.PollQuestion = question
    }
    
    public func hasVoted(userId: Int) -> Bool {
        return self.Answers?.contains(where: {$0.Votes?.contains(where: {$0.UserId == userId}) ?? false}) ?? false
        //^ if the answers array contains any value where the votes of that answer contain a vote made by the specified user
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

public class FeedPollAnswer : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.AnswerId <- map["answerId"]
        self.PostId <- map["postId"]
        self.Answer <- map["answer"]
        self.Votes <- map["votes"]
    }
    var AnswerId: Int?
    var PostId: Int?
    var Answer: String?
    var Votes: [FeedAnswerVote]?
    public init?(PostId: Int, Answer: String) {
        self.AnswerId = 0; self.PostId = PostId; self.Answer = Answer
    }
}
public class FeedAnswerVote : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.AnswerId <- map["answerId"]
        self.UserId <- map["userId"]
        self.IsDeleted <- map["isDeleted"]
    }
    var AnswerId: Int?
    var UserId: Int?
    var IsDeleted: Bool?
    
    public init?(UserId: Int, AnswerId: Int) {
        self.UserId = UserId; self.AnswerId = AnswerId; self.IsDeleted = false;
    }
}



//QUIZ:

public class FeedQuiz : Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.PostId <- map["postId"]; self.PosterId <- map["posterId"];
        self.SubjectId <- map["subjectId"]; self.PostType <- map["postType"];
        self.DatePosted <- map["datePosted"]; self.IsAnnouncement <- map["isAnnouncement"];
        self.IsDeleted <- map["isDeleted"]
        self.Poster <- map["poster"]
        self.Likes <- map["likes"]
        self.QuizTitle <- map["quizTitle"]
        self.DifficultyLevel <- map["difficultyLevel"]
        self.Questions <- map["questions"]
        self.Results <- map["results"]
    }
    
    var PostId : Int?
    var PosterId : Int?
    var SubjectId : Int?
    var PostType : String?
    var DatePosted : String?
    var IsAnnouncement : Bool?
    var IsDeleted : Bool?
    var Poster : User?; var Subject : Subject?
    var Likes : [FeedLike]?
    var QuizTitle : String?
    var DifficultyLevel : String?
    var Questions : [FeedQuizQuestion]?
    var Results : [FeedQuizResult]?
    
    public init?(PostId : Int, PosterId: Int, SubjectId: Int, PostType: String, DatePosted: String, IsAnnouncement: Bool, IsDeleted: Bool, quizTitle: String, difficulty: String) {
        self.PostId = PostId; self.PosterId = PosterId; self.SubjectId = SubjectId; self.PostType = PostType
        self.DatePosted = DatePosted; self.IsAnnouncement = IsAnnouncement; self.IsDeleted = IsDeleted;
        self.QuizTitle = quizTitle; self.DifficultyLevel = difficulty
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

public class FeedQuizQuestion : Mappable, Codable {
    public required init?(map: Map) {}
    public func mapping(map: Map) {
        self.QuestionId <- map["questionId"]
        self.PostId <- map["postId"]
        self.Answers <- map["answers"]
        self.CorrectAnswer <- map["correctAnswer"]
        self.Question <- map["question"]
        self.DifficultyLevel <- map["difficulty"]
        if DifficultyLevel == 1 { DifficultyString = "Easy" }
        else if DifficultyLevel == 2 { DifficultyString = "Medium" }
        else if DifficultyLevel == 3 { DifficultyString = "Hard" }
    }
   
    var QuestionId : Int?
    var PostId : Int?
    var Answers : [String]?
    var CorrectAnswer : String?
    var Question : String?
    var DifficultyLevel : Int?
    var DifficultyString : String?
    
    public init?(QuestionId: Int, PostId: Int, Answers: [String], CorrectAnswer: String, Question: String, Difficulty: Int) {
        self.QuestionId = QuestionId; self.PostId = PostId; self.Answers = Answers; self.CorrectAnswer = CorrectAnswer
        self.Question = Question; self.DifficultyLevel = Difficulty
        if DifficultyLevel == 1 { DifficultyString = "Easy" }
        else if DifficultyLevel == 2 { DifficultyString = "Medium" }
        else if DifficultyLevel == 3 { DifficultyString = "Hard" }
    }
}

public class FeedQuizResult : Mappable, Codable {
    public required init?(map: Map) {}
    public func mapping(map: Map) {
        self.PostId <- map["postId"]
        self.UserId <- map["userId"]
        self.OverallScore <- map["overallScore"]
        self.User <- map["user"]
        self.DatePosted <- map["datePosted"]
    }
    
    var PostId : Int?
    var UserId : Int?
    var OverallScore : Int?
    var DatePosted : String?
    var User : User?
    
    public init?(PostId: Int, UserId: Int, OverallScore: Int, DatePosted: String) {
        self.PostId = PostId; self.UserId = UserId; self.OverallScore = OverallScore; self.DatePosted = DatePosted
    }
}
