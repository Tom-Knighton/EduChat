//
//  Subject.swift
//  EduChat
//
//  Created by Tom Knighton on 24/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Subject : Mappable, Codable {
    
    public mutating func mapping(map: Map) {
        self.SubjectId <- map["subjectId"]; self.SubjectName <- map["subjectName"]; self.ShortSubjectName <- map["shortSubjectName"]
        self.IsEducational <- map["isEducational"]; self.IsAdvanced <- map["isAdvanced"]
        self.IsEnabled <- map["isEnabled"]
    }
    
    
    var SubjectId : Int?
    var SubjectName : String?
    var ShortSubjectName : String?
    var IsEducational : Bool?
    var IsAdvanced : Bool?
    var IsEnabled : Bool?
    
    
    public init?(map: Map) {}
    
    
}
