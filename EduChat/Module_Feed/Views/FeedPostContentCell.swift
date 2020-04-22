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
            UserMethods.GetUserById(userid: self.post?.PosterId ?? 0, completion: { (user, err) in //Gets msg user
                if let user = user { //if user is not nil
                   // guard let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as? Profile_Content) else { return } //loads profile view
                    //vc.currentUser = user; //sets profile to currentUser
                    //UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    //^ Pushes view onto stack
                }
            })
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
            UserMethods.GetUserById(userid: self.post?.PosterId ?? 0, completion: { (user, err) in //Gets msg user
                if let user = user { //if user is not nil
                    //guard let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as? Profile_Content) else { return } //loads profile view
                    //vc.currentUser = user; //sets profile to currentUser
                    //UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    //^ Pushes view onto stack
                }
            })
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
            self.feedDelegate?.UpdatePost(post: newPost) //Calls Our UpdatePost method on the table view
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


class FeedPollCell : UITableViewCell {
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var postQuestion: UILabel!
    @IBOutlet weak var pollStackView: UIStackView!
    var feedDelegate : FeedMainTableDelegate?
    var poll : FeedPoll?
    
    func populate(with poll: FeedPoll) {
        self.poll = poll //Sets global value to our poll
        self.posterImage.sd_setImage(with: URL(string: poll.Poster?.UserProfilePictureURL ?? ""), completed: nil)
        //Sets the user's profile image
        self.posterName.text = poll.Poster?.UserName ?? "" //Sets profile username
        self.postQuestion.text = poll.PollQuestion ?? "" //Sets the question label text
        self.pollStackView.removeAllArrangedSubviews() //Remove all the views that have previously been added to stack
        // ^ this is because iOS caches each table view, so every time we reconfigure it, views will be added again
        for answer in poll.Answers ?? [] { //For each possible answer
            let answerButton = UIButton(frame: .zero) //Create a button object
            answerButton.backgroundColor = .clear //Clears background
            answerButton.cornerRadius = 15 //Rounded corners
            answerButton.borderWidth = 1 //Border width to thin
            answerButton.borderColor = UIColor(hex: "#0096FF") //Sets colour to Apple's blue
            answerButton.setTitleColor(UIColor(hexString: "#0096FF"), for: .normal) //^
            answerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true //Adds the height for the button
            answerButton.tag = answer.AnswerId ?? 0 //Tags the button with the answerId
            
            if poll.hasVoted(userId: EduChat.currentUser?.UserId ?? 0) == false {//IF user has not yet voted
                answerButton.setTitle(answer.Answer ?? "", for: .normal) //Sets the tile to the answer
                answerButton.isEnabled = true
            }
            else { //If user HAS voted
                let totalVotes : Int = poll.Answers?.map({$0.Votes?.count ?? 0}).reduce(0, +) ?? 0
                // ^ combines every vote for every answer to get a total number of votes
                let percentage = (answer.Votes?.count ?? 0 / totalVotes) * 100 //percentage of votes for this answer
                answerButton.setTitle((answer.Answer ?? "")+" : \(percentage)%", for: .normal)
                // ^ sets title to answer + the percentage of total votes
                answerButton.isEnabled = false //DIsables the button from being pressed
            }

            answerButton.addTarget(self, action: #selector(pollAnswerPressed(_:)), for: .touchUpInside)
            //^ When the button is pressed, call pollAnswerPressed
            self.pollStackView.addArrangedSubview(answerButton) //Add the button to the stack view
        }
    }
    
    @objc func pollAnswerPressed(_ sender: UIButton) {
        if self.poll?.hasVoted(userId: EduChat.currentUser?.UserId ?? 0) == false { //Just in case
            guard let answer = self.poll?.Answers?.first(where: { $0.AnswerId == sender.tag }) else { return; }
            // ^ Try and get the answer object from the button's tag, if fail: return
            
            answer.Votes?.append(FeedAnswerVote(UserId: EduChat.currentUser?.UserId ?? 0, AnswerId: answer.AnswerId ?? 0)!)
            // ^ Adds temp vote object so we can reload
            self.populate(with: self.poll!) //Reloads poll to change buttons
            FeedMethods.VoteForPoll(on: self.poll?.PostId ?? 0, for: answer.AnswerId ?? 0, userid: EduChat.currentUser?.UserId ?? 0) { (newVotes) in //Calls VoteForPoll
                self.poll?.Answers = newVotes ?? self.poll?.Answers //Sets the polls
                self.feedDelegate?.UpdatePost(post: self.poll!) //Calls to update table
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        print("like pressed 1")

        FeedMethods.SetLikeForPost(postid: self.poll?.PostId ?? 0, userid: EduChat.currentUser?.UserId ?? 0, like: !(self.poll?.isLiked() ?? false)) {
            (newPost) in //Calls SetLikeForPost API method
            print("like pressed")
            self.feedDelegate?.UpdatePost(post: newPost) //Calls Our UpdatePost method on the table view
            if !(self.poll?.isLiked() ?? false) == true { //If the user is liking the image
                self.postLikeButton.setImage(UIImage(named: "love"), for: .normal) //Set the heart to full
            }
            else { self.postLikeButton.setImage(UIImage(named: "heart"), for: .normal) } //Else set it to normal
            self.poll?.modifyLike(like: !(self.poll?.isLiked() ?? false), postid: self.poll?.PostId ?? 0) //Modify the like value
            self.postLikesLabel.text = self.poll?.Likes?.count == 1 ? "1 Like" : "\(self.poll?.Likes?.count ?? 0) Likes"
        }
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "feedCommentsView") as? FeedCommentsTable else { return; }
        vc.postId = self.poll?.PostId
        
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func postOptionsPressed(_ sender: Any) {
        let sheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            //
        }))
        sheet.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { (_) in
            UserMethods.GetUserById(userid: self.poll?.PosterId ?? 0, completion: { (user, err) in //Gets msg user
                if let user = user { //if user is not nil
                    //guard let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as? Profile_Content) else { return } //loads profile view
                    //vc.currentUser = user; //sets profile to currentUser
                    //UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    //^ Pushes view onto stack
                }
            })
        }))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { (_) in
            //
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(sheet, animated: true, completion: nil)
    }
    
    
}

class FeedQuizCell : UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var goToQuizButton: UIButton!
    @IBOutlet weak var quizDifficulty: UILabel!
    @IBOutlet weak var likePostButton: UIButton!
    @IBOutlet weak var postLikes: UILabel!
    var quiz : FeedQuiz?
    
    func populate(with quiz: FeedQuiz) {
        self.quiz = quiz //Sets global quiz to quiz
        self.posterImage.sd_setImage(with: URL(string: quiz.Poster?.UserProfilePictureURL ?? ""), completed: nil)
        //^ Sets poster's image to user's profile picture
        self.posterName.text = quiz.Poster?.UserName ?? "" //Sets label text to user's name
        self.quizTitle.text = quiz.QuizTitle ?? "" //Sets the label text to the quiz's title
        self.goToQuizButton.setTitle("Play Quiz  ➡️", for: .normal) //Sets button label
        self.quizDifficulty.text = "Difficulty: "+(quiz.DifficultyLevel ?? "") //Adds difficulty to label
    }
    
    @IBAction func playQuizPressed(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedQuizController") as? FeedQuizController else {
            return }
        vc.currentQuiz = self.quiz
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
}
