//
//  ProfilePostsCollectionCells.swift
//  EduChat
//
//  Created by Tom Knighton on 16/03/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class ProfilePostCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(postCellTapped))
        tap.cancelsTouchesInView = true
        self.addGestureRecognizer(tap)
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    @objc func postCellTapped() {
        goToPostTapped(postId: -1)
    }
    
    func goToPostTapped(postId: Int?) {
        print("tap :)")
        if postId != -1 { //Passed successfully:
            print(postId ?? 0)
        }
    }
}

class ProfilePostImageCell: ProfilePostCell {
    @IBOutlet weak var postImage : UIImageView?
    var PostId : Int?
    
    func populate(with image: UIImage?, postId: Int?) {
        self.PostId = postId ?? -1
        self.postImage?.image = image
    }
    func populate(with url: String?, postId: Int?) {
        self.PostId = postId ?? -1
        self.postImage?.sd_setImage(with: URL(string: url ?? ""), completed: nil)
    }
    override func postCellTapped() {
        goToPostTapped(postId: self.PostId ?? -1)
    }
}

class ProfilePostTextCell: ProfilePostCell {
    @IBOutlet weak var postTextLabel: UILabel?
    var PostId : Int?
    
    func populate(with text: String?, postId: Int?) {
        self.PostId = postId ?? -1
        self.postTextLabel?.text = text ?? ""
    }
    
  
}

class ProfilePostPollCell: ProfilePostCell {
    @IBOutlet weak var postTextLabel: UILabel?
    var PostId: Int?
    
    func populate(with text: String?, postId: Int?) {
        self.PostId = postId ?? -1
        self.postTextLabel?.text = text ?? ""
    }
    
    override func postCellTapped() {
        goToPostTapped(postId: self.PostId ?? -1)
    }
}

class ProfilePostQuizCell: ProfilePostCell {
    @IBOutlet weak var postTextLabel: UILabel?
    var PostId: Int?
    
    func populate(with text: String?, postId: Int?) {
        self.PostId = postId ?? -1
        self.postTextLabel?.text = text ?? ""
    }
    
}
