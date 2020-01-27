//
//  FeedQuizResultCell.swift
//  EduChat
//
//  Created by Tom Knighton on 21/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class FeedQuizResultCell: UITableViewCell {
    
    @IBOutlet var userImage : UIImageView?
    @IBOutlet var userName : UILabel?
    @IBOutlet var userScore : UILabel?
    @IBOutlet var datePosted : UILabel?

    func populate(with result: FeedQuizResult?, and quiz: FeedQuiz?) { //Passed a result and quiz object
        self.userImage?.layer.cornerRadius = 20; self.userImage?.layer.masksToBounds = true;
        self.userImage?.sd_setImage(with: URL(string: result?.User?.UserProfilePictureURL ?? ""), completed: nil)
        //Sets the image to the user's image
        self.userName?.text = result?.User?.UserName ?? "" //Sets username label to user's
        self.datePosted?.text = result?.DatePosted?.toDate().timeAgoSinceNow //Sets date label to the time ago
        self.userScore?.text = String(describing: result?.OverallScore ?? 0) + "/" + String(describing: quiz?.Questions?.count ?? 0) 
        //Sets the score label to the answerCorrectly number + / + the total number of questions
    }

}
