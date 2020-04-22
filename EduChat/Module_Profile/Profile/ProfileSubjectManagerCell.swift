//
//  ProfileSubjectManagerCell.swift
//  EduChat
//
//  Created by Tom Knighton on 04/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

protocol ProfileSubjectManagerDelegate {
    func selectSubject(SubjectId: Int)
    func unselectSubject(SubjectId: Int)
}

class ProfileSubjectManagerCell: UITableViewCell {

    @IBOutlet weak var SubjectNameLabel : UILabel?
    @IBOutlet weak var StudyTypeLabel : UILabel?
    @IBOutlet weak var StudySwitch : UISwitch?
    @IBOutlet weak var SubjectCardView : UIView?
    
    var subject : Subject?
    var profileSubjectManagerDelegate : ProfileSubjectManagerDelegate?
    
    func populate(with subject : Subject, selectedSubjectIds : [Int]?) {
        self.subject = subject; //Sets global subject variable to the one passed in
        self.SubjectNameLabel?.text = subject.SubjectName ?? "" //Sets subject name to subject
        self.StudyTypeLabel?.text = selectedSubjectIds?.contains(subject.SubjectId ?? 0) ?? false ? "Studying" : "Not Studying"
        self.StudySwitch?.isOn = selectedSubjectIds?.contains(subject.SubjectId ?? 0) ?? false ? true : false
        
        //Shadow:
        self.SubjectCardView?.layer.shadowOpacity = 0.5
        self.SubjectCardView?.layer.shadowOffset = .zero
        self.SubjectCardView?.layer.shadowRadius = 1
        self.SubjectCardView?.layer.shadowColor = UIColor.flatBlack().cgColor
        self.SubjectCardView?.layer.shadowPath = UIBezierPath(rect: self.SubjectCardView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)).cgPath
        
    }
    
    @IBAction func studyingSwitchToggled(_ sender: UISwitch) {
        //Call select or unselectSubject on delegate depending on new switch state
        if sender.isOn { self.profileSubjectManagerDelegate?.selectSubject(SubjectId: self.subject?.SubjectId ?? 0) }
        else { self.profileSubjectManagerDelegate?.unselectSubject(SubjectId: self.subject?.SubjectId ?? 0) }
    }
    
}
