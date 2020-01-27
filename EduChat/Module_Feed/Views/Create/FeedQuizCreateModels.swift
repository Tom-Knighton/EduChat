//
//  FeedQuizCreateModels.swift
//  EduChat
//
//  Created by Tom Knighton on 21/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

enum CreateQuizSectionItemType {
    case Title
    case Questions
    case Difficulty
}

protocol CreateQuizSectionItem {
    var type: CreateQuizSectionItemType { get }
    var sectionTitle: String { get}
    var rowCount: Int { get }
    var isCollapsable : Bool { get }
    var isCollapsed : Bool { get set }
}

extension CreateQuizSectionItem {
    var rowCount: Int { return 1}
    var isCollapsable: Bool { return false }
}

class CreateQuizTitleItem : CreateQuizSectionItem {
    var type: CreateQuizSectionItemType { return .Title }
    var sectionTitle: String { return "Create Quiz: " }
    var isCollapsed = false
}
