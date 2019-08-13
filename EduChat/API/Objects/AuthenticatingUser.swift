//
//  AuthenticatingUser.swift
//  EduChat
//
//  Created by Tom Knighton on 11/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public struct AuthenticatingUser : Mappable, Codable {
    
    
    
    
    
    public var Authenticator : String?
    public var PassHash : String?
    
    public init?(authenticator: String, passhash: String) {
        Authenticator = authenticator; PassHash = passhash
    }
    public init?(map: Map) {}
    public mutating func mapping(map: Map) {
        Authenticator <- map["authenticator"]
        PassHash <- map["passHash"]
    }
    
}
