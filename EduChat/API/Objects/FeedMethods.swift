//
//  FeedMethods.swift
//  EduChat
//
//  Created by Tom Knighton on 31/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class FeedMethods {
    
    static let URLBASE : String = "https://educhat.tomk.online/api/Feed/"
    
    static func GetPostById(postId : Int, completion: ((Any?) -> ())?) {
        Alamofire.request(URLBASE+"GetPostById/\(postId)").responseJSON { (response) in //Calls GetPostById API
            if let json = response.result.value as? [String:Any] { //if we can get the response as json
                if let type = json["postType"] as? String { //If the json is valid
                    switch(type) { //checks type of the 'postType' value
                    case "text": // If its text
                        let post = FeedTextPost(JSON: json)//Convert json response to textpost object
                        completion?(post) //Calls completion with the post objec
                        break;
                    case "media": //If its a media type
                        let post = FeedMediaPost(JSON: json)//Convert json response to media object
                        completion?(post) //Calls completion with the post object
                        break;
                    default: //If it is none for some reason
                        completion?(nil) //Calls completion with a null object
                        break;
                    }
                }
            }
            
        }
    }
    
    static func GetAllPostsForSubject(subjectId: Int, completion: (([Any]?) -> ())?) {
        Alamofire.request(URLBASE+"GetAllPostsForSubject/\(subjectId)").responseJSON { (response) in
            if let json = response.result.value as? [[String:Any]] {
                var posts : [Any] = []
                for child in json {
                    if let type = child["postType"] as? String {
                        switch(type){
                        case "text":
                            posts.append(FeedTextPost(JSON: child))
                            break;
                        case "media":
                            posts.append(FeedMediaPost(JSON: child))
                            break;
                        default:
                            break;
                        }
                    }
                }
                completion?(posts)
            }
        }
    }
    
    static func SetLikeForPost(postid: Int, userid: Int, like: Bool, completion: ((Any?) -> ())?) {
        Alamofire.request(URLBASE+"SetLikeForPost/\(postid)/\(userid)/\(like)", method: .put).responseJSON { (response) in
            // ^ Calls SetLikeForPost
            if let json = response.result.value as? [String:Any] { //If we get any json returned
                if let type = json["postType"] as? String { //Gets the value of the 'postType' attribute
                    switch(type){
                    case "text": //If it is text, convert to a FeedTextPost and return that
                        completion?(FeedTextPost(JSON: json))
                        break;
                    case "media": //Same for media
                        completion?(FeedMediaPost(JSON: json))
                        break;
                    default: break;
                    }
                }
            }
        }
    }
   
    static func GetAllCommentsForPost(postid: Int, completion: (([FeedComment]?) -> ())?) {
        Alamofire.request(URLBASE+"GetAllCommentsForPost/\(postid)").responseArray {
            (response: DataResponse<[FeedComment]>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            }
            else { completion?(nil) }
        }
    }
    
    static func CreateComment(for PostId: Int, Comment: FeedComment, completion: ((FeedComment?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(Comment) //Encodes the comment object
        let dataString = String(data: payload, encoding: .utf8) //Converts the DATA object to a string
        let params = convertToDictionary(text: dataString) //Converts that string to a swift dictionary []
        Alamofire.request(URLBASE+"CreateCommentForPost/\(PostId)/\(Comment.UserId ?? 0)", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedComment>) in //Calls our endpoint with our parameters
            if response.response?.statusCode == 200 { //If call was successful
                completion?(response.result.value) //Return the new comment
            }
            else { completion?(nil) } //Else, return nothing
        }
    }
    
    
    
    static func convertToDictionary(text: String?) -> [String: Any]? {
        if let data = text?.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
