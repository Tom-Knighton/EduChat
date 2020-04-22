//
//  ProfileHeaderCell.swift
//  EduChat
//
//  Created by Tom Knighton on 03/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit
import ChameleonFramework


class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var ProfileImage : UIImageView?
    @IBOutlet weak var ProfileName : UILabel?
    @IBOutlet weak var ProfileBio : UILabel?
    @IBOutlet weak var ProfilePostCount : UILabel?
    @IBOutlet weak var ProfileFriendCount : UILabel?
    @IBOutlet weak var ProfileSubjectCount : UILabel?
    
    var delegate : ProfileControllerDelegate?
    var currentUser : User?
    
    func populate(with user : User?) {
        self.currentUser = user //Sets current user to the one passed
        self.ProfileImage?.sd_setImage(with: URL(string: user?.UserProfilePictureURL ?? ""), completed: nil) //Fills in profile picture and other data
        self.ProfileName?.text = user?.UserFullName ?? ""
        
        self.ProfileBio?.text = user?.Bio ?? "No Bio"
        self.ProfilePostCount?.text = "0"
        self.ProfileFriendCount?.text = String(describing: user?.Friendships?.count ?? 0)
        self.ProfileSubjectCount?.text = String(describing: user?.Subjects?.count ?? 0)
    }
    @IBAction func ProfileEditButtonPressed(_ sender: Any) {
        delegate?.displayProfileSettings()
    }
}

class ProfileSubjectsCell : UITableViewCell {
    @IBOutlet weak var ProfileSubjectsCollectionView : UICollectionView?
    var subjects : [Subject]?
    var delegate : ProfileControllerDelegate?
    
    func populate(with subjects : [Subject]?) {
        self.subjects = subjects
        ProfileSubjectsCollectionView?.delegate = self
        ProfileSubjectsCollectionView?.dataSource = self
        self.ProfileSubjectsCollectionView?.reloadData()
    }
}

extension ProfileSubjectsCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (EduChat.currentUser?.Subjects?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let addSubjectCell = self.ProfileSubjectsCollectionView?.dequeueReusableCell(withReuseIdentifier: "ProfileSubjectAddCell", for: indexPath) else { return UICollectionViewCell() }
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.modifySubjectsButtonPressed(_:)))
            addSubjectCell.addGestureRecognizer(tap)
            return addSubjectCell
        }
        else {
            guard let subjectCell = self.ProfileSubjectsCollectionView?.dequeueReusableCell(withReuseIdentifier: "ProfileSubjectCell", for: indexPath) as? ProfileSubjectCollectionCell else { return UICollectionViewCell() }
            subjectCell.populate(with: EduChat.currentUser?.Subjects?[indexPath.row - 1])
            return subjectCell
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 { return CGSize(width: 50, height: 50) }
        else { return CGSize(width: 120, height: 50) }
    }
    

    @objc func modifySubjectsButtonPressed(_ sender : Any) {
        delegate?.displaySubjectManager()
    }
    
}

class ProfileSubjectCollectionCell : UICollectionViewCell {
    @IBOutlet weak var subjectCellBackground : UIView?
    @IBOutlet weak var subjectCellLabel : UILabel?
    var subject : Subject?
    
    func populate(with subject : Subject?) {
        self.subject = subject
        self.subjectCellBackground?.backgroundColor = UIColor.init(gradientStyle: .diagonal, withFrame: self.contentView.frame, andColors: [UIColor(hex: subject?.ColorOneHex ?? ""), UIColor(hex: subject?.ColorTwoHex ?? "")])
        self.subjectCellLabel?.text = subject?.ShortSubjectName ?? ""
        self.subjectCellLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: self.subjectCellBackground?.backgroundColor ?? UIColor.black, isFlat: true)
        
        let shadow = UIView(); shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 1; shadow.layer.shadowOffset = .zero
        shadow.layer.shadowRadius = 10; shadow.layer.shouldRasterize = true
        shadow.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}

class ProfilePostsCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var postsStackView : UIStackView?
    @IBOutlet weak var postsCollectionView : DynamicHeightCollectionView?
    
    var posts : [Any?]? = []
    func populate(with posts : [Any?]) {
        self.posts = posts
        self.postsStackView?.removeAllArrangedSubviews()
        if posts.count == 0 { //User has no posts
            let noPostsLabel : UILabel = {
                let l = UILabel()
                l.text = "You don't have any posts :(\nGo to the Feed page to make your first one!"
                l.font = UIFont(name: "Montserrat-Light", size: 14)
                l.numberOfLines = 0
                l.textAlignment = .center
                return l
            }()
            self.postsStackView?.addArrangedSubview(noPostsLabel)
            self.postsStackView?.isHidden = false
            self.postsCollectionView?.isHidden = true
        }
        else { //User has posts to display
            self.postsCollectionView?.delegate = self
            self.postsCollectionView?.dataSource = self
            self.postsCollectionView?.layoutIfNeeded()
            self.postsStackView?.isHidden = true
            self.postsCollectionView?.isHidden = false
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.filter({ $0 is FeedMediaPost || $0 is FeedTextPost || $0 is FeedPoll || $0 is FeedQuiz}).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = posts?.filter({ $0 is FeedMediaPost || $0 is FeedTextPost || $0 is FeedPoll || $0 is FeedQuiz}).reversed()[indexPath.row]
        if type is FeedMediaPost {
            guard let c = self.postsCollectionView?.dequeueReusableCell(withReuseIdentifier: "profileImagePostCell", for: indexPath) as? ProfilePostImageCell else { return UICollectionViewCell() }
            c.populate(with: (type as! FeedMediaPost).UrlToPost ?? "", postId: (type as! FeedMediaPost).PostId ?? -1)
            return c
        }
        else if type is FeedTextPost {
            guard let c = self.postsCollectionView?.dequeueReusableCell(withReuseIdentifier: "profileTextPostCell", for: indexPath) as? ProfilePostTextCell else { return UICollectionViewCell() }
            c.populate(with: (type as! FeedTextPost).PostText ?? "", postId: (type as! FeedTextPost).PostId ?? -1)
            return c
        }
        else if type is FeedPoll {
            guard let c = self.postsCollectionView?.dequeueReusableCell(withReuseIdentifier: "profilePollPostCell", for: indexPath) as? ProfilePostPollCell else {
                return UICollectionViewCell() }
            c.populate(with: (type as! FeedPoll).PollQuestion ?? "", postId: (type as! FeedPoll).PostId ?? -1)
            return c
        }
        else if type is FeedQuiz {
            guard let c = self.postsCollectionView?.dequeueReusableCell(withReuseIdentifier: "profileQuizPostCell", for: indexPath) as? ProfilePostQuizCell else { return UICollectionViewCell() }
            c.populate(with: (type as! FeedQuiz).QuizTitle ?? "", postId: (type as! FeedQuiz).PostId ?? -1)
            return c
        }
        else { return UICollectionViewCell() }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let squareWidthSize = ((self.postsCollectionView?.frame.width ?? 300) / 3) - 8
        return CGSize(width: squareWidthSize, height: squareWidthSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = posts?.filter({ $0 is FeedMediaPost || $0 is FeedTextPost || $0 is FeedPoll || $0 is FeedQuiz}).reversed()[indexPath.row]
        if type is FeedPost {
            print("test")
        }
        
        
    }
    
}
