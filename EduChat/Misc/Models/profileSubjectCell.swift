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

class profilePostCell : UICollectionViewCell {
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    func populate(with post: Any) { //Gets ANy object
        if post is FeedTextPost { //If is text post
            self.postImage.isHidden = true; //Hide image
            self.postLabel.isHidden = false; self.postLabel.text = (post as! FeedTextPost).PostText ?? ""
            //Show label and set text to post
        } //Same for other posts
        else if post is FeedMediaPost {
            self.postImage.isHidden = false;
            self.postImage.isHidden = true;
            self.postImage.sd_setImage(with: URL(string: (post as! FeedMediaPost).UrlToPost ?? ""), completed: nil)
        }
        else if post is FeedPoll {
            self.postImage.isHidden = true;
            self.postLabel.isHidden = false; self.postLabel.text = (post as! FeedPoll).PollQuestion ?? ""
        }
        else if post is FeedQuiz {
            self.postImage.isHidden = true;
            self.postLabel.isHidden = false; self.postLabel.text = (post as! FeedQuiz).QuizTitle ?? ""
        }
    }
    func populate(with textPost: FeedTextPost) {
        self.postImage.isHidden = true;
        self.postLabel.isHidden = false; self.postLabel.text = textPost.PostText ?? ""
    }
    func populate(with mediaPost: FeedMediaPost) {
        self.postImage.isHidden = false;
        self.postImage.isHidden = true;
        self.postImage.sd_setImage(with: URL(string: mediaPost.UrlToPost ?? ""), completed: nil)
    }
    func populate(with pollPost: FeedPoll) {
        self.postImage.isHidden = true;
        self.postLabel.isHidden = false; self.postLabel.text = pollPost.PollQuestion ?? ""
    }
    func populate(with quizPost: FeedQuiz) {
        self.postImage.isHidden = true;
        self.postLabel.isHidden = false; self.postLabel.text = quizPost.QuizTitle ?? ""
    }
    
}
