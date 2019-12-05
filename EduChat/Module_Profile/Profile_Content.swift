//
//  Profile_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 15/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ShadowView
import ChameleonFramework
import SwiftSignalRClient
import SDWebImage

class Profile_Content: UITableViewController{

    @IBOutlet weak var profileHeaderView: ShadowView!
    @IBOutlet weak var profileHeaderName: UILabel!
    @IBOutlet weak var profileHeaderImage: UIImageView!
    @IBOutlet var postsTable: UITableView!
    
    @IBOutlet weak var subjectsCollection: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        self.subjectsCollection.dataSource = self //Sets the subjects collection view to pull data from this class
        self.subjectsCollection.delegate = self
        
    }
    
    func reloadData() {
        self.title = EduChat.currentUser?.UserName
        self.profileHeaderName.text = EduChat.currentUser?.UserFullName ?? "My Account"//Sets full name label to value of EduChat.currentUser
        self.profileHeaderImage.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? "")) //Sets profile image view to image from profile URL
        self.subjectsCollection.reloadData()
        
    }
    
   
}


extension Profile_Content {
    @IBAction func changeProfilePic(_ sender: Any) {
        let v = (storyboard?.instantiateViewController(withIdentifier: "changePicPage"))!
        self.navigationController?.pushViewController(v, animated: true)
    }
}




extension Profile_Content {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        //^ creates View with width of whole view
        let shView = ShadowView.init(frame: view.frame)
        //^ creates shadow view same size as previous view
        shView.shadowRadius = 5
        shView.shadowOpacity = 0.3
        shView.shadowColor = UIColor.flatBlack
        shView.shadowOffset = CGSize.zero
        // ^ sets up shadow
        view.backgroundColor = UIColor.white
        let title = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 29))
        title.font = UIFont(name: "Montserrat-Bold", size: 17)
        //^ Creates a title and sets the font
        if section == 1 {
            title.text = "Subjects:"
            view.roundCorners(corners: [.topRight, .topLeft], radius: 20)
            //^ if first section, title is Subjects and view is rounded
        }
        if section == 2 { title.text = "Posts:" } //Else, title is Posts
        
        view.addSubview(title)
        view.bringSubviewToFront(title)
        //Adds title and shadow to main view
        return view
        //Sets the header section to the view we created
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 40
        //View MUST BE > 0 for header to show
    }

}

extension Profile_Content {
    @IBAction func settingsPressed(sender: Any) {
        let settings = (storyboard?.instantiateViewController(withIdentifier: "settingsVC"))!
        self.navigationController?.pushViewController(settings, animated: true)
    }
    @IBAction func subjectsPressed(sender: Any) {
        let subjects = (storyboard?.instantiateViewController(withIdentifier: "subjectsVC"))!
        self.navigationController?.pushViewController(subjects, animated: true)
    }
}

extension Profile_Content: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EduChat.currentUser?.Subjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : profileSubjectCell = self.subjectsCollection.dequeueReusableCell(withReuseIdentifier: "profileSubjectCell", for: indexPath) as! profileSubjectCell
        cell.subjectLabel.text = EduChat.currentUser?.Subjects![indexPath.row].ShortSubjectName ?? EduChat.currentUser?.Subjects![indexPath.row].SubjectName ?? ""
        cell.backView?.backgroundColor = UIColor.init(randomFlatColorExcludingColorsIn: [UIColor.gray, UIColor.darkGray, UIColor.flatGray, UIColor.flatGrayDark])
        cell.subjectLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backView.backgroundColor!, isFlat: true)
        // Above sets each subject cell to the correct class, and sets a random background colour and the subject name as a title
        return cell
    }
    
    
}

