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
                    case "poll":
                        let post = FeedPoll(JSON: json)
                        completion?(post)
                        break;
                    case "quiz":
                        let post = FeedQuiz(JSON: json)
                        completion?(post); break;
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
                        case "poll":
                            posts.append(FeedPoll(JSON: child))
                        case "quiz":
                            posts.append(FeedQuiz(JSON: child))
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
                    case "poll":
                        completion?(FeedPoll(JSON: json))
                        break;
                    case "quiz":
                        completion?(FeedQuiz(JSON: json))
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
    
    static func UploadTextPost(post: FeedTextPost, completion: ((FeedTextPost?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(post) //Encodes the post object
        let dataString = String(data: payload, encoding: .utf8) //Converts the DATA object to a string
        let params = convertToDictionary(text: dataString) //Converts that string to a swift dictionary []
        Alamofire.request(URLBASE+"UploadTextPost", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedTextPost>) in //Calls our endpoint with our parameters
            if response.response?.statusCode == 200 { //If call was successful
                completion?(response.result.value) //Return the new post
            } else { completion?(nil) } //else retur nothing
        }
    }
    static func UploadMediaPost(post: FeedMediaPost, completion: ((FeedMediaPost?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(post) //Encodes the post object
        let dataString = String(data: payload, encoding: .utf8) //Converts the DATA object to a string
        let params = convertToDictionary(text: dataString) //Converts that string to a swift dictionary []
        Alamofire.request(URLBASE+"UploadMediaPost", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedMediaPost>) in //Calls our endpoint with our parameters
            if response.response?.statusCode == 200 { //If call was successful
                completion?(response.result.value) //Return the new post
            } else { completion?(nil) } //else retur nothing
        }
    }
    static func UploadPoll(poll: FeedPoll, completion: ((FeedPoll?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(poll)
        let dataStrig = String(data: payload, encoding: .utf8)
        let params = convertToDictionary(text: dataStrig)
        Alamofire.request(URLBASE+"UploadPoll", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedPoll>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
        }
    }
    
    static func UploadFeedMediaAttachment(image: UIImage?, completion: ((String?) -> ())?) {
        Alamofire.upload(multipartFormData: { (MultipartFormData) in //Creates mutipartFormData request
            let imgData = image?.jpegData(compressionQuality: 0.5) // Compresses image to 0.5x
            MultipartFormData.append(imgData!, withName: UUID().uuidString, fileName: UUID().uuidString.lowercased()+".jpg", mimeType: "image/jpeg")
            //^ Adds image to request with random name
        }, to: URLBASE+"UploadFeedMediaAttachment") { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (response: DataResponse<String>) in //Gets response as a string
                    let url = response.result.value
                    completion?(url) //Returns url
                })
                break
            case .failure(_):
                completion?("") //If failure return empty
                break
            }
        }
    }
    
    static func VoteForPoll(on pollId: Int, for answerId: Int, userid: Int, completion: (([FeedPollAnswer]?) -> ())?) {
        Alamofire.request(URLBASE+"VoteForPoll/\(userid)/\(answerId)/\(pollId)", method: .put).responseArray { (response: DataResponse<[FeedPollAnswer]>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
        }
    }
    
    static func GetFullQuizPost(for quizId: Int, completion: ((FeedQuiz?) -> ())?) {
        Alamofire.request(URLBASE+"GetFullFeedQuiz/\(quizId)").responseObject { (response: DataResponse<FeedQuiz>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
        }
    }
    
    static func GetQuizResult(by resultId: Int, completion: ((FeedQuizResult?) -> ())?) {
        Alamofire.request(URLBASE+"GetQuizResultById/\(resultId)").responseObject { (response: DataResponse<FeedQuizResult>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
        }
    }
    
    static func CreateQuizResult(result: FeedQuizResult, completion: ((FeedQuizResult?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(result)
        let dataStrig = String(data: payload, encoding: .utf8)
        let params = convertToDictionary(text: dataStrig)
        Alamofire.request(URLBASE+"CreateQuizResult/\(result.PostId ?? 0)", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedQuizResult>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
        }
    }
    
    static func UploadQuiz(quiz : FeedQuiz, completion: ((FeedQuiz?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(quiz)
        let dataStrig = String(data: payload, encoding: .utf8)
        let params = convertToDictionary(text: dataStrig)
        Alamofire.request(URLBASE+"UploadQuiz", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<FeedQuiz>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            } else { completion?(nil) }
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
