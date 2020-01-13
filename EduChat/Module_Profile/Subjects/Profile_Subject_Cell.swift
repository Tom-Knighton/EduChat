//
//  Profile_Subject_Cell.swift
//  EduChat
//
//  Created by Tom Knighton on 04/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class Profile_Subject_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var subjectLabel: UILabel!
    var subject : Subject?
    var subjectManagerDelegate : SubjectManagerDelegate?
    
    func configureCellWithItem(subject: Subject) {
        self.subject = subject
        if EduChat.currentUser?.Subjects?.contains(subject) ?? false {
            self.toggle.setOn(true, animated: false)
        }
        else { self.toggle.setOn(false, animated: false) }
        self.subjectLabel.text = subject.SubjectName ?? ""
        
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        self.subjectManagerDelegate?.subjectToggled(toggled: sender.isOn, sub: self.subject ?? nil)
    }
    
    
}
