//
//  UserMethods.swift
//  EduChat
//
//  Created by Tom Knighton on 10/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


public class UserMethods {
    
    static let URLBASE : String = "https://educhat.tomk.online/api/User/"
    //static let URLBASE : String = "http://localhost:5000/api/User"
    enum Errors : Error { case NotFound }
    
    static func GetUserById(userid: Int, completion: @escaping(User?, Error?) -> ()) { //Creates a method that can return a user or an error
        Alamofire.request(URLBASE+"GetUserById/\(userid)", method: .get).responseObject { (response: DataResponse<User>) in
            let usr = response.result.value ?? nil
            if usr == nil { completion(nil, Errors.NotFound)}
            else { completion(usr, nil) }
        }
    }
    
    static func AuthenticateUser(usr: AuthenticatingUser, completion: ((User?, Error?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(usr) //Encodes the AuthenticatingUser object to JSON
        let dataString = String(data: payload, encoding: String.Encoding.utf8) //Converts that Data object to a string
        let params = convertToDictionary(text: dataString!) //Converts string to swift dictionary
        Alamofire.request(URLBASE+"AuthenticateUser", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<User>) in
            //Makes the request with our paramaters, expects a user in response
            if response.response?.statusCode == 200 { //If successful
                let user = response.result.value ?? nil //Gets user returned
                if user == nil {  completion?(nil, Errors.NotFound) } //if nil return not found
                else { completion?(user, nil) } //else return the user
            }
            else { completion?(nil, Errors.NotFound) } //if not successful, return not founds
        }
    }
    
    static func IsEmailFree(email: String, completion : ((Bool) -> ())?) {
        Alamofire.request(URLBASE+"IsEmailFree/\(email)", method: .get).responseString { (result) in
            completion?(result.result.value?.toBool ?? false)
        }
    }
    static func IsUsernameFree(username: String, completion: ((Bool) -> ())?) {
        Alamofire.request(URLBASE+"IsUsernameFree/\(username)", method: .get).responseString { (result) in
            completion?(result.result.value?.toBool ?? false)
        }
    }
    
    static func CreateNewUser(usr: User, completion: ((User?, Error?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(usr)
        let dataString = String(data: payload, encoding: String.Encoding.utf8)
        let params = convertToDictionary(text: dataString)
        Alamofire.request(URLBASE+"CreateNewUser", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<User>) in
            if response.response?.statusCode == 200 {
                let user = response.result.value ?? nil
                if user == nil { completion?(nil, Errors.NotFound) }
                else { completion?(user, nil) }
            }
            else { completion?(nil, Errors.NotFound) }
            
        }
    }
    
    static func UploadUserProfilePicture(userid: Int, img: UIImage, completion: ((User?) -> ())?) {
        let imgData = img.jpegData(compressionQuality: 0.5)

        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData!, withName: "profilePic", fileName: "profile_pic.jpg", mimeType: "image/jpeg")
        }, to: URLBASE+"UploadUserProfilePic/\(userid)") { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response: DataResponse<User>) in
                    let usr = response.result.value ?? nil
                    if usr == nil { completion?(nil) }
                    else { completion?(usr) }
                })
                break
            case .failure(_):
                completion?(nil)
                break
            }
        }
    }
    
    static func SubscribeUserToSubjects(userid: Int, subjects: [Int], completion : ((User?, Error?) ->())?) {
        
        Alamofire.request(URLBASE+"SubscribeUserToSubjects/\(userid)", method: .post, parameters: subjects.asParameters(), encoding: ArrayEncoding()).responseObject { (response: DataResponse<User>) in
            
            if response.response?.statusCode == 200 {
                completion?(response.result.value, nil)
            }
            else { completion?(nil, Errors.NotFound) }
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
