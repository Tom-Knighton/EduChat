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
            self.ColourIndicator = UIColor.flatWhite().hexValue()
            self.ColorOneHex = "#43C6AC"; self.ColorTwoHex = "#F8FFAE"
            break;
        case 2: //English
            self.ColourIndicator = UIColor.flatOrange().hexValue()
            self.ColorOneHex = "#FFB75E"; self.ColorTwoHex = "#D38312"
            break;
        case 3: //English A level
            self.ColourIndicator = UIColor.flatOrangeDark().hexValue()
            self.ColorOneHex = "#F0C27B"; self.ColorTwoHex = "#4B1248";
            break;
        case 4: //Maths
            self.ColourIndicator = UIColor.flatRed().hexValue()
            self.ColorOneHex = "#8A2387"; self.ColorTwoHex = "#F27121"
            break;
        case 5: //Maths A level
            self.ColourIndicator = UIColor.flatRedDark().hexValue()
            self.ColorOneHex = "#12c2e9"; self.ColorTwoHex = "#F27121"
            break;
        case 6: //Further Maths A level
            self.ColourIndicator = UIColor.red.hexValue()
            self.ColorOneHex = "#c31432"; self.ColorTwoHex = "#240b36";
            break;
        case 7: //History
            self.ColourIndicator = UIColor.flatSand().hexValue()
            self.ColorOneHex = "#EDE574"; self.ColorTwoHex = "#E1F5C4"
            break;
        case 8: //Politics
            self.ColourIndicator = UIColor.flatPowderBlue().hexValue()
            self.ColorOneHex = "#ad5389"; self.ColorTwoHex = "#3c1053"
            break;
        case 9: //History A-Level
            self.ColourIndicator = UIColor.flatSandDark().hexValue()
            self.ColorOneHex = "#fceabb"; self.ColorTwoHex = "#f8b500"
            break;
        case 10: //Politics A level
            self.ColourIndicator = UIColor.flatPowderBlueDark().hexValue()
            self.ColorOneHex = "#c94b4b"; self.ColorTwoHex = "#4b134f"
            break;
        case 11: //Computer Science
            self.ColourIndicator = UIColor.flatPlum().hexValue()
            self.ColorOneHex = "#5A3F37"; self.ColorTwoHex = "#2C7744"
            break;
        case 12: //Computer Science A level
            self.ColourIndicator = UIColor.flatPlumDark().hexValue()
            self.ColorOneHex = "#283c86"; self.ColorTwoHex = "#45a247"
            break;
        default:
            self.ColourIndicator = UIColor.init(randomFlatColorExcludingColorsIn: [UIColor.gray, UIColor.darkGray, UIColor.flatGray(), UIColor.flatGrayDark()]).hexValue()
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
    var ColorOneHex : String?; var ColorTwoHex : String?
    
    public init?(map: Map) {}
    
    
}
