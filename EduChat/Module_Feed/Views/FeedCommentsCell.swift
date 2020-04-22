//
//  FeedCommentsCell.swift
//  EduChat
//
//  Created by Tom Knighton on 08/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class FeedCommentsCell: UITableViewCell {
    
    @IBOutlet weak var commenterImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var commentDetails: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(with Comment: FeedComment) {
        let comment = NSMutableAttributedString(string: Comment.Comment ?? "", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont()]) //Part of a mutable string with the comment text
        let fullComment = NSMutableAttributedString(string: (Comment.commenter?.UserName ?? "") + " ", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 14) ?? UIFont()]) //Part of the mutable string made of the username
        fullComment.append(comment) //Adds the comment to the username
        self.comment.attributedText = fullComment //sets the label text to the fullComment
        self.commenterImage.sd_setImage(with: URL(string: Comment.commenter?.UserProfilePictureURL ?? ""), completed: nil)
        // Sets the profile image to the user's profile image
        self.commentDetails.text = Comment.DatePosted?.toDate().timeAgoSinceNow //Sets the date ago label to the date ago posted
    }

}
