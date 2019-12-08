//
//  FriendshipMethods.swift
//  EduChat
//
//  Created by Tom Knighton on 07/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class FriendshipMethods {
    
    static let URLBASE : String = "https://educhat.tomk.online/api/Friendship/"
    enum Errors : Error { case NotFound }
    
    static func DoesFriendshipExist(userid1: Int, userid2: Int, completion: ((Bool?) -> ())?)  {
        Alamofire.request(URLBASE+"DoesFriendshipExist/\(userid1)/\(userid2)", method: .get).responseString { (response) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value?.toBool ?? false)
            }
            completion?(false)
        }
    }
    static func IsBlocked(userid1: Int, userid2: Int, completion: ((Bool?) -> ())?)  {
        Alamofire.request(URLBASE+"IsBlocked/\(userid1)/\(userid2)", method: .get).responseString { (response) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value?.toBool ?? false)
            }
            completion?(false)
        }
    }
    
    static func SetBlock(userid1: Int, userid2: Int, block: Bool, completion: ((Friendship?) -> ())?) {
        
        Alamofire.request(URLBASE+"SetBlock/\(userid1)/\(userid2)?block=\(block)", method: .put).responseObject { (response: DataResponse<Friendship>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            }
            else { completion?(nil) }
        }
    }
    
    static func GetAllFriendsForUser(userid: Int, completion: (([Friendship]?) -> ())?) {
        Alamofire.request(URLBASE+"GetAllFriendsForUser/\(userid)", method: .get).responseArray { (response: DataResponse<[Friendship]>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value ?? [])
            }
            completion?(nil)
        }
    }
    
    static func CreateFriendship(friendship: Friendship, completion: ((Friendship?) -> ())?) {
        let payload : Data = try! JSONEncoder().encode(friendship)
        let dataString = String(data: payload, encoding: String.Encoding.utf8)
        let params = convertToDictionary(text: dataString)
        
        Alamofire.request(URLBASE+"CreateFriendship", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<Friendship>) in
            if response.response?.statusCode == 200 {
                completion?(response.result.value)
            }
            completion?(nil)
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
