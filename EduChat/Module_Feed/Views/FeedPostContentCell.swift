//
//  FeedPostContentCell.swift
//  EduChat
//
//  Created by Tom Knighton on 17/12/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import Lightbox
import Loaf

class FeedCellTextPost: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postOptions: UIButton!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postLikesLabel: UILabel!
    var post : FeedTextPost?
    var feedDelegate : FeedMainTableDelegate?
    
    func populate(with TextPost: FeedTextPost) { //Passed a feedtextpost object
        self.post = TextPost //Sets our global variable to the post passed
        self.posterName.text = self.post?.Poster?.UserName ?? "" //Below just fills out the cell with our data
        self.posterImage.sd_setImage(with: URL(string: post?.Poster?.UserProfilePictureURL ?? ""), completed: nil)
        self.postText.text = self.post?.PostText ?? ""
        self.postLikesLabel.text = self.post?.Likes?.count == 1 ? "1 Like" : "\(self.post?.Likes?.count ?? 0) Likes"
        
        if (self.post?.isLiked() ?? false) { self.postLikeButton.setImage(UIImage(named: "love"), for: .normal)} //If is liked, set image to filled in heart
        else { self.postLikeButton.setImage(UIImage(named: "heart"), for: .normal)}
    }
    
    @IBAction func postOptionsPressed(_ sender: Any) {
        let sheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            //
        }))
        sheet.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { (_) in
            //
        }))
        sheet.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (_) in
            UIPasteboard.general.string = self.post?.PostText ?? ""
            Loaf("Post copied successfully!", state: .success, sender: UIApplication.topViewController()!).show()
            let generator = UINotificationFeedbackGenerator(); generator.notificationOccurred(.success)
        }))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { (_) in
            //
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(sheet, animated: true, completion: nil)
        
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        FeedMethods.SetLikeForPost(postid: self.post?.PostId ?? 0, userid: EduChat.currentUser?.UserId ?? 0, like: !(self.post?.isLiked() ?? false)) { (newPost) in
            self.feedDelegate?.UpdatePost(post: newPost)
            if !(self.post?.isLiked() ?? false) == true {
                self.postLikeButton.setImage(UIImage(named: "love"), for: .normal)
            }
            else { self.postLikeButton.setImage(UIImage(named: "heart"), for: .normal) }
            self.post?.modifyLike(like: !(self.post?.isLiked() ?? false), postid: self.post?.PostId ?? 0)
            self.postLikesLabel.text = self.post?.Likes?.count == 1 ? "1 Like" : "\(self.post?.Likes?.count ?? 0) Likes"
        }
    }
    @IBAction func commentsButtonPressed(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "feedCommentsView") as? FeedCommentsTable else { return; }
        vc.postId = self.post?.PostId
        
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


class FeedCellMediaPost: UITableViewCell {
    @IBOutlet weak var postDescription: UILabel?
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var postOptions: UIButton!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postLikesLabel: UILabel!
    var post : FeedMediaPost?
    var feedDelegate: FeedMainTableDelegate?
    func populate(with MediaPost: FeedMediaPost) { //Passed a FeedMediaPost object
        self.post = MediaPost //sets our global post object to the one passed
        self.posterImage?.sd_setImage(with: URL(string: post?.Poster?.UserProfilePictureURL ?? ""), completed: nil)
        self.posterName?.text = self.post?.Poster?.UserName
        self.postImage?.sd_setImage(with: URL(string: self.post?.UrlToPost ?? ""), completed: nil)
        self.postDescription?.text = self.post?.PostDescription ?? ""
        self.postLikesLabel.text = self.post?.Likes?.count == 1 ? "1 Like" : "\(self.post?.Likes?.count ?? 0) Likes"
        
        if (self.post?.isLiked() ?? false) { self.postLikeButton.setImage(UIImage(named: "love"), for: .normal)}
        else { self.postLikeButton.setImage(UIImage(named: "heart"), for: .normal)}
        //Above fills in the cell with the data passed to us
    }
    @IBAction func postOptionsPressed(_ sender: Any) { //Post options pressed for FeedMediaPost
        let sheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet) //creates the action sheet
        sheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in //Report option
            //
        }))
        sheet.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { (_) in //View the profile
            //
        }))
        sheet.addAction(UIAlertAction(title: "View Image", style: .default, handler: { (_) in //View the image in full
            let images = [LightboxImage(imageURL: URL(string: self.post?.UrlToPost ?? "")!, text: self.post?.PostDescription ?? "")]
            let controller = LightboxController(images: images, startIndex: 0)
            controller.dynamicBackground = true //^ Creates a LightboxImage (full screen) with a blurry background
            UIApplication.topViewController()?.present(controller, animated: true, completion: nil) //Presents the view
        }))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { (_) in //Share option
            //
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds the cancel option
        UIApplication.topViewController()?.present(sheet, animated: true, completion: nil) //Presents the action sheet
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        FeedMethods.SetLikeForPost(postid: self.post?.PostId ?? 0, userid: EduChat.currentUser?.UserId ?? 0, like: !(self.post?.isLiked() ?? false)) { (newPost) in //Calls SetLikeForPost API method
            self.feedDelegate?.UpdatePost(post: newPost as Any) //Calls Our UpdatePost method on the table view
            if !(self.post?.isLiked() ?? false) == true { //If the user is liking the image
                self.postLikeButton.setImage(UIImage(named: "love"), for: .normal) //Set the heart to full
            }
            else { self.postLikeButton.setImage(UIImage(named: "heart"), for: .normal) } //Else set it to normal
            self.post?.modifyLike(like: !(self.post?.isLiked() ?? false), postid: self.post?.PostId ?? 0) //Modify the like value
            self.postLikesLabel.text = self.post?.Likes?.count == 1 ? "1 Like" : "\(self.post?.Likes?.count ?? 0) Likes"
        }
    }
    @IBAction func commentsButtonPressed(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "feedCommentsView") as? FeedCommentsTable else { return; }
        vc.postId = self.post?.PostId
        
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
