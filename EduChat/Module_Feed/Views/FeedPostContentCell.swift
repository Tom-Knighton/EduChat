//
//  FeedPostContentCell.swift
//  EduChat
//
//  Created by Tom Knighton on 17/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class FeedPostContentCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var posterNameLabel: UILabel?
    @IBOutlet weak var postOptionsButton: UIButton?
    @IBOutlet weak var postImageView: ScaledHeightImageView?
    @IBOutlet weak var separatorLine: UIView?
    
    @IBOutlet weak var descLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
