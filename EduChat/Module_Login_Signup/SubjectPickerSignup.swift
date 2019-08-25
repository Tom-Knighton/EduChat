//
//  SubjectPickerSignup.swift
//  EduChat
//
//  Created by Tom Knighton on 24/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import Magnetic

class SubjectPickerSignup: UIViewController, MagneticDelegate {
    
    @IBOutlet weak var picker: MagneticView!
    
    var magnetic : Magnetic?
    var subjects : [Subject]?
    
    var selectedSubjects : [Int] = [1]
    
    override func loadView() {
        super.loadView()
        magnetic = self.picker.magnetic
        self.magnetic?.magneticDelegate = self
    }
    
    override func viewDidLoad() {
        self.lockAndDisplayActivityIndicator(enable: true)
        SubjectMethods.GetAllSubjects { (subjects, error) in // calls the GetAllSubjects endpoint
            // ^ returns list of all subjects
            if error == nil { // if no errors
                self.subjects = subjects // sets global list to subjects returned
                for sub in self.subjects! { // loops through each subject
                    if(sub.IsEducational ?? true) {self.addNode(subject: sub)}
                    // if it was educational create a bubble for it
                }
                self.lockAndDisplayActivityIndicator(enable: false)
            }
        }
    }
    
    func addNode(subject : Subject) {
        let color = UIColor(randomFlatColorExcludingColorsIn: [UIColor.flatGray, UIColor.flatGrayDark])
        let node = Node(text: subject.SubjectName, image: nil, color: color, radius: 50)
        node.label.fontSize = 9
        node.tag = subject
        magnetic?.addChild(node)
        // creates a bubble and adds it to the magnetic view
    }

    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("adding")
        let id = (node.tag as! Subject).SubjectId!
        print(id)
        selectedSubjects.append(id)
        print(selectedSubjects)
        // adds selected subject id to selectedSubjects list
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        selectedSubjects.remove(at: (selectedSubjects.index(of: (node.tag as! Subject).SubjectId!))!)
        //removes id when deselected
    }
    @IBAction func skip(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subscribe(_ sender: Any) {
        //prerequisite that EduChat.currentUser is NOT NULL
        if selectedSubjects.count == 0 { self.dismiss(animated: true, completion: nil); print("empty"); return; } // If user selected nothing, just dismiss
        UserMethods.SubscribeUserToSubjects(userid: EduChat.currentUser?.UserId ?? 0, subjects: selectedSubjects) { (User, Error) in // Calls subscribe to subjects endpoint
            if Error == nil { //If no erros
                EduChat.currentUser = User // Sets the static User reference to our new user object with new subjects
                self.dismiss(animated: true, completion: nil) // dismisses view
            }
            else { self.displayBasicError(title: "Error", message: "An error occurred subscribing to these subjects"); } // else ,display error
        }
    }
    
}
