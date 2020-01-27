//
//  Subject.swift
//  EduChat
//
//  Created by Tom Knighton on 24/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Subject : Mappable, Codable, Equatable {
    
    public mutating func mapping(map: Map) {
        self.SubjectId <- map["subjectId"]; self.SubjectName <- map["subjectName"]; self.ShortSubjectName <- map["shortSubjectName"]
        self.IsEducational <- map["isEducational"]; self.IsAdvanced <- map["isAdvanced"]
        self.IsEnabled <- map["isEnabled"]
        
        switch (self.SubjectId) {
        case 1: //Social
            self.ColourIndicator = UIColor.flatWhite.hexValue()
            break;
        case 2: //English
            self.ColourIndicator = UIColor.flatOrange.hexValue()
            break;
        case 3: //English A level
            self.ColourIndicator = UIColor.flatOrangeDark.hexValue()
            break;
        case 4: //Maths
            self.ColourIndicator = UIColor.flatRed.hexValue()
            break;
        case 5: //Maths A level
            self.ColourIndicator = UIColor.flatRedDark.hexValue()
            break;
        case 6: //Further Maths A level
            self.ColourIndicator = UIColor.red.hexValue()
            break;
        case 7: //History
            self.ColourIndicator = UIColor.flatSand.hexValue()
            break;
        case 8: //Politics
            self.ColourIndicator = UIColor.flatPowderBlue.hexValue()
            break;
        case 9: //History A-Level
            self.ColourIndicator = UIColor.flatSandDark.hexValue()
            break;
        case 10: //Politics A level
            self.ColourIndicator = UIColor.flatPowderBlueDark.hexValue()
            break;
        case 11: //Computer Science
            self.ColourIndicator = UIColor.flatPlum.hexValue()
            break;
        case 12: //Computer Science A level
            self.ColourIndicator = UIColor.flatPlumDark.hexValue()
            break;
        default:
            self.ColourIndicator = UIColor.init(randomFlatColorExcludingColorsIn: [UIColor.gray, UIColor.darkGray, UIColor.flatGray, UIColor.flatGrayDark]).hexValue()
            break;
        }
    }

    var SubjectId : Int?
    var SubjectName : String?
    var ShortSubjectName : String?
    var IsEducational : Bool?
    var IsAdvanced : Bool?
    var IsEnabled : Bool?
    var ColourIndicator : String?
    
    public init?(map: Map) {}
    
    
}
