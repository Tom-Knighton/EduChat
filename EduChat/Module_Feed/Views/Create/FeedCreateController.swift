//
//  FeedCreateController.swift
//  EduChat
//
//  Created by Tom Knighton on 13/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit
import Loaf
class FeedCreateController: UITableViewController {

    ///MARK: BASICPOST
    @IBOutlet weak var currentUserImg: UIImageView!
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var commentView: PlaceholderTextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    //MARK: POLL POST
    @IBOutlet weak var pollQuestionTextView: PlaceholderTextView!
    @IBOutlet weak var addPollAnswerButton: UIButton!
    @IBOutlet weak var pollStackView: UIStackView?
    var pollAnswers : [FeedPollAnswer]? = []
    
    var selectedSubject = 1
    let picker = UIImagePickerController()
    
    @IBOutlet weak var basicPostCreateView: UIView!
    @IBOutlet weak var pollPostCreateView: UIView!
    
    
    var isBasicPost = true; var isImagePost = false; var isVideoPost = false; var isPollPost = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self //We control our image picker
        self.commentView.inputAccessoryView = self.inputAccessory() //Adds the image bar above keyboard
        self.pollQuestionTextView.inputAccessoryView = self.inputAccessory()
        self.currentUserImg.sd_setImage(with: URL(string: EduChat.currentUser?.UserProfilePictureURL ?? ""), completed: nil) //Sets the user's image in the image view
        self.currentUsername.text = EduChat.currentUser?.UserName ?? "" //Sets the label text to our username
        self.endEditingWhenViewTapped() //Close the keyboard when tapped
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postPost(_:)))
        
        //POLL:
        self.addPollAnswerButton.setBackgroundColor(color: .flatBlue(), forState: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        //Overriding willAppearMethod to not call super()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.commentView.becomeFirstResponder() //Bring up keyboard straight away
    }
    
    //MARK: Post Button Pressed
    @objc func postPost(_ sender: Any) {
        self.lockAndDisplayActivityIndicator(enable: true) //Locks view
        if self.isBasicPost {
            if self.isImagePost { //Selectd image
                FeedMethods.UploadFeedMediaAttachment(image: self.postImageView.image) { (url) in //Calls upload attachment
                    if let url = url { //URL Returned
                        let mediaPost = FeedMediaPost(PostId: 0, PosterId: EduChat.currentUser?.UserId ?? 0, SubjectId: self.selectedSubject, PostType: "media", DatePosted: Date().toString(), IsAnnouncement: false, IsDeleted: false, UrlToPost: url, PostDescription: self.commentView.text, IsVideo: false)
                        // ^ Creates MediaPost object
                        FeedMethods.UploadMediaPost(post: mediaPost!, completion: { (returnPost) in //Uploads post
                            self.lockAndDisplayActivityIndicator(enable: false) //Unlock display
                            if returnPost != nil { self.navigationController?.popViewController(animated: true) }
                                // ^ if a post is returned
                            else { self.displayBasicError(title: "Error", message: "An error occurred uploading this post")}
                            //Else show an error
                        })
                    }
                    else { self.displayBasicError(title: "Error", message: "An error occurred uploading this post"); self.lockAndDisplayActivityIndicator(enable: false)} //Else show an error
                }
            }
            else if self.isVideoPost {
                //VIDEO POST
            }
            else { //TEXT PST
                let textPost = FeedTextPost(PostId: 0, PosterId: EduChat.currentUser?.UserId ?? 0, SubjectId: selectedSubject, PostType: "text", DatePosted: Date().toString(), IsAnnouncement: false, IsDeleted: false, PostText: self.commentView.text)! //Creates post object
                FeedMethods.UploadTextPost(post: textPost) { (returnPost) in //Calls UploadTextPost()
                    if returnPost != nil { self.navigationController?.popViewController(animated: true) }
                    else { self.displayBasicError(title: "Error", message: "An error occurred uploading this post")}
                }
            }
        }
        else if self.isPollPost { //Poll
            let question = self.pollQuestionTextView.text.trim() //Get the trimmed text of the poll question
            if question == "" || question == " " { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Error", message: "Please enter a question"); return; } //If no question entered, display enter and return
            if self.pollAnswers?.count ?? 0 > 4 || self.pollAnswers?.count ?? 0 < 2 { self.displayBasicError(title: "Error", message: "Please enter between 2 and 4 answers"); self.lockAndDisplayActivityIndicator(enable: false); return }
            //^ If not enough (or somehow too many) answers, display error and return
            let poll = FeedPoll(PostId: 0, PosterId: EduChat.currentUser?.UserId ?? 0, SubjectId: self.selectedSubject, PostType: "poll", DatePosted: Date().toString(), IsAnnouncement: false, IsDeleted: false, question: question) //Create FeedPoll object
            poll?.Answers = self.pollAnswers ?? [] //set the Answers array on the object to the inputted ones
            FeedMethods.UploadPoll(poll: poll!) { (returnPoll) in //Call UploadPoll API method
                if returnPoll != nil { self.navigationController?.popViewController(animated: true) } //If poll returned, pop the display
                else { self.displayBasicError(title: "Error", message: "An error occurred uploading poll"); self.lockAndDisplayActivityIndicator(enable: false) } //Otherwise, show an error
            }
        }
    }
    
}

//MARK: InputAccessory
extension FeedCreateController {
    func inputAccessory() -> UIView {
        let inputAccessory = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let navItem = UINavigationItem()
        let addImageItem = UIBarButtonItem(image: UIImage(named: "image"), style: .plain, target: self, action: #selector(addImagePressed(_:)))
        let addPollItem = UIBarButtonItem(image: UIImage(named: "poll"), style: .plain, target: self, action: #selector(addPollPressed(_:)))
        navItem.rightBarButtonItems = [addPollItem, addImageItem]
        
        inputAccessory.pushItem(navItem, animated: false)
        return inputAccessory
    }
    
    @objc func addImagePressed(_ selector: UIBarButtonItem) {
        self.basicPostCreateView.isHidden = false
        self.pollPostCreateView.isHidden = true
        self.present(picker, animated: true, completion: nil)
    }
    @objc func addPollPressed(_ selector: UIBarButtonItem) {
        self.resignFirstResponder()
        if self.isBasicPost {
            self.basicPostCreateView.isHidden = true
            self.pollPostCreateView.isHidden = false
            self.isBasicPost = false; self.isPollPost = true;
            self.pollQuestionTextView.becomeFirstResponder()
        }
        else {
            self.basicPostCreateView.isHidden = false
            self.pollPostCreateView.isHidden = true
            self.isBasicPost = true; self.isPollPost = false;
            self.commentView.becomeFirstResponder()
        }
    }
}

//MARK: ImagePicker
extension FeedCreateController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let oImage = info[.originalImage] as? UIImage else {
            return
        }
        self.dismiss(animated: true, completion: nil)
        addImage(image: oImage)
        
    }
    
    func addImage(image: UIImage) {
        self.postImageView.image = image
        self.imageWidthConstraint.constant = 150
        self.commentView.placeholder = "Add a comment"
        self.isBasicPost = true; self.isImagePost = true;
    }
    func removeImage() {
        self.postImageView.image = UIImage()
        self.imageWidthConstraint.constant = 0
        self.commentView.placeholder = "What do you want to say?"
        self.isBasicPost = true; self.isImagePost = false;
    }
}

//MARK: Poll
extension FeedCreateController {
    @IBAction func didPressAddAnswer(_ sender: UIButton) { //When addAnswer presses
        if self.pollAnswers?.count ?? 0 < 4 {
            let alert = UIAlertController(title: "Enter Poll Option", message: "Enter the answer:", preferredStyle: .alert)
            alert.addTextField { (textField) in //^ Creates alert < Adds text field
                textField.autocorrectionType = .default //Sets autocorrection to user's default
                textField.autocapitalizationType = .sentences //Sets capitalisation to each sentence
            }
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in //Adds a confirm option
                guard let answerText = alert.textFields?[0] else { return } //Gets the text field
                let userAnswer = answerText.text?.trim()
                if userAnswer == "" || userAnswer == " " { return; }
                if self.pollAnswers?.contains(where: {$0.Answer == userAnswer}) ?? false { return; }
                self.pollStackView?.addArrangedSubview(self.createPollButton(answer: answerText.text ?? ""))
                //^ Call createPollButton() and add the returned button to the stack view
                let answer = FeedPollAnswer(PostId: 0, Answer: answerText.text ?? "") //Create an answer object from the text
                self.pollAnswers?.append(answer!) //Add the above object to global array
                if self.pollAnswers?.count ?? 0 == 4 { self.addPollAnswerButton.isEnabled = false; self.addPollAnswerButton.alpha = 0.5 }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //Adds cancel option
            self.present(alert, animated: true, completion: nil) //Presents alert
        }
    }
    
    func createPollButton(answer: String) -> UIButton { //Create button method returns a UIButton
        let button = UIButton(frame: .zero) //Inits button
        button.cornerRadius = 15 //Gives rounded corners
        button.borderWidth = 1; button.borderColor = UIColor(hex: "#0096FF") //Gives thin blue border
        button.setTitleColor(UIColor(hex: "#0096FF"), for: .normal); button.setBackgroundColor(color: .clear, forState: .normal) //Sets title colour to blue
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true //Sets height to 40
        button.setTitle(answer, for: .normal) //Sets the title to the answer the user entered
        button.addTarget(self, action: #selector(pollAnswerPressed(_:)), for: .touchUpInside)
        //^ Sets what to do when its tapped, call pollAnswerPressed()
        return button //Returns the button
    }
    @objc func pollAnswerPressed(_ sender: UIButton) { //On pollAnswerPressed
        let index = self.pollAnswers?.firstIndex(where: {$0.Answer == sender.titleLabel?.text ?? ""}) ?? 0
        //^ FInd the index of the answer with that title in the array
        self.pollAnswers?.remove(at: index) //Removes from array
        self.pollStackView?.removeArrangedSubview(sender) //Removes from stack
        NSLayoutConstraint.deactivate(sender.constraints) //Removes height constraint
        sender.removeFromSuperview() //Removes button from every view
        if self.pollAnswers?.count ?? 0 < 4 { self.addPollAnswerButton.isEnabled = true; self.addPollAnswerButton.alpha = 1 }
    }
}
