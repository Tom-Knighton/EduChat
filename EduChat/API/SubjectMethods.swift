//
//  SubjectMethods.swift
//  EduChat
//
//  Created by Tom Knighton on 24/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public class SubjectMethods {
    
    static let URLBASE : String = "https://educhat.tomk.online/api/Subject/"
    enum Errors : Error { case NotFound }
    
    
    static func GetAllSubjects(completion: (([Subject]?, Error?) -> ())?) {
        Alamofire.request(URLBASE+"GetAllSubjects", method: .get).responseArray { (response: DataResponse<[Subject]>) in
            if response.response?.statusCode == 200 {
                completion?(response.value, nil)
            }
            else { completion?(nil, Errors.NotFound) }
        }
        
    }
}
