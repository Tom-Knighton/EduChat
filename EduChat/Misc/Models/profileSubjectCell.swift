//
//  profileSubjectCell.swift
//  EduChat
//
//  Created by Tom Knighton on 03/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class profileSubjectCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    
    func populate(with subject: Subject?) {
        self.subjectLabel.text = subject?.ShortSubjectName ?? subject?.SubjectName ?? ""
        self.backView?.backgroundColor = UIColor(hex: subject?.ColourIndicator ?? "#ffffff")
        self.subjectLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: self.backView.backgroundColor!, isFlat: true)
        // Above sets each subject cell to the correct class, and sets a random background colour and the subject name as a title
    }
}
