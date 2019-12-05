//
//  ChatMethods.swift
//  EduChat
//
//  Created by Tom Knighton on 09/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class ChatMethods {
    static let URLBASE : String = "https://educhat.tomk.online/api/Chat/"
    enum Errors : Error { case NotFound; case Unexplained }
    
    
    static func GetChatById(id : Int, completion: ((Chat?, Error?) -> ())?) {
        Alamofire.request(URLBASE+"GetChatById/\(id)").responseObject { (response: DataResponse<Chat>) in
            if response.response?.statusCode == 200 {
                let chat = response.result.value
                if chat != nil { completion?(chat, nil) }
                else { completion?(nil, Errors.NotFound) }
            }
            else { completion?(nil, Errors.NotFound) }
        }
    }
    
    static func GetMessageById(messageId: Int, completion: ((ChatMessage?) -> ())?) {
        Alamofire.request(URLBASE+"GetChatMessageById/\(messageId)").responseObject { (response : DataResponse<ChatMessage>) in
            if response.response?.statusCode == 200 {
                completion?(response.value)
            }
            else {completion?(nil)}
        }
    }
    
    static func GetAllChatsForUser(userid: Int, completion: (([Chat]?, Error?) ->())?) {
        Alamofire.request(URLBASE+"GetChatsForUser/\(userid)").responseArray { (response: DataResponse<[Chat]>) in
            if response.response?.statusCode == 200 {
                completion?(response.value, nil)
            }
            else { completion?(nil, Errors.Unexplained) }
        }
    }
    
    static func GetAllMessagesForChat(chatId: Int, completion: (([ChatMessage]?, Error?) -> ())?) {
        Alamofire.request(URLBASE+"GetMessagesForChat/\(chatId)").responseArray { (response: DataResponse<[ChatMessage]>) in
            if response.response?.statusCode == 200 { completion?(response.value, nil) }
            else { completion?(nil, Errors.NotFound) }
        }
    }
    
    static func AddNewMessageToChat(chatid: Int, message: ChatMessage, completion: ((_ success: Bool?, ChatMessage?) ->())?) {
        let payload : Data = try! JSONEncoder().encode(message)
        let dataString = String(data: payload, encoding: String.Encoding.utf8)
        let params = convertToDictionary(text: dataString)
        Alamofire.request(URLBASE+"AddNewMessageToChat/\(chatid)", method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<ChatMessage>) in
            if response.response?.statusCode == 200 && response.value?.ChatId == chatid { completion?(true, response.value) }
            else { completion?(false, nil) }
        }
    }
    
    
    static func UploadChatAttachment(chatId: Int, img: UIImage?, completion: ((String?) -> ())?) {
        Alamofire.upload(multipartFormData: { (MultipartFormData) in //Creates mutipartFormData request
            let imgData = img?.jpegData(compressionQuality: 0.5) // Compresses image to 0.5x
            MultipartFormData.append(imgData!, withName: UUID().uuidString, fileName: UUID().uuidString.lowercased()+".jpg", mimeType: "image/jpeg")
            //^ Adds image to request with random name
        }, to: URLBASE+"UploadChatAttachment/\(chatId)") { (result) in
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
    static func UploadChatAttachment(chatId: Int, videoURL: URL?, completion: ((String?) -> ())?) {
        Alamofire.upload(multipartFormData: { (MultipartFormData) in //Creates mutipartFormData request
            MultipartFormData.append(videoURL!, withName: UUID().uuidString, fileName: UUID().uuidString.lowercased()+".mp4", mimeType: "video/mp4")
            //^ Adds video to request with random name
        }, to: URLBASE+"UploadChatAttachment/\(chatId)") { (result) in
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
    
    static func RemoveMessage(chat: Chat, messageId: Int) {
        Alamofire.request(URLBASE+"RemoveChatMessage/\(chat.chatId ?? 0)/\(messageId)", method: .put).response { (_) in
            MainHost.chatConnection.removeMessage(groupId: chat.getGroupNameForSignalR(), messageId: messageId)
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

