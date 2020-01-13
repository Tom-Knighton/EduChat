//
//  FeedCommentsTable.swift
//  EduChat
//
//  Created by Tom Knighton on 08/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import ListPlaceholder
import HGPlaceholders

class FeedCommentsTable: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var keyboardHeight : CGFloat = 300
    open lazy var messageInputBar = FeedCommentInputBar()
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    open override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    var postId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageInputBar.delegate = self
        self.messageInputBar.inputTextView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset.bottom = 50
        self.tableView.keyboardDismissMode = .interactive
        self.loadComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    var comments : [FeedComment] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCommentCell", for: indexPath) as? FeedCommentsCell else { return UITableViewCell() }
        cell.populate(with: self.comments[indexPath.row])
        return cell
    }
    
    func loadComments() {
        FeedMethods.GetAllCommentsForPost(postid: self.postId ?? 0) { (comments) in
            self.comments = comments ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

}

extension FeedCommentsTable: InputBarAccessoryViewDelegate, UITextViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        self.tableView.contentInset.bottom = size.height + self.keyboardHeight //keyboard size estimate
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
            self.tableView.contentInset.bottom = keyboardHeight
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tableView.scrollToBottomRow()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let comment = FeedComment(UserId: EduChat.currentUser?.UserId ?? 0, PostId: self.postId ?? 0, Comment: text.trim(), IsAdmin: false, IsDeleted: false)! //Creates the FeedComment object
        FeedMethods.CreateComment(for: self.postId ?? 0, Comment: comment) { (returnComment) in //Calls our CreateComment API
            if returnComment != nil { self.comments.append(returnComment!); self.tableView.reloadData(); } //If we return a comment, add it to table
        }
        self.messageInputBar.inputTextView.text = ""
    }
    
    
}

class FeedCommentInputBar : InputBarAccessoryView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        inputTextView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setRightStackViewWidthConstant(to: 38, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        sendButton.imageView?.backgroundColor = tintColor
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_up")
        sendButton.title = nil
        sendButton.imageView?.layer.cornerRadius = 16
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -38
        separatorLine.isHidden = true
        isTranslucent = true
    }
}
