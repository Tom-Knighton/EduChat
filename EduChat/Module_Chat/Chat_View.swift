//
//  Chat_View.swift
//  EduChat
//
//  Created by Tom Knighton on 17/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Lightbox
import Loaf

class Chat_View: MessagesViewController {
    
    var currentChat : Chat? //Initialises variable to hold Chat Object
    var messages : [ChatMessage] = [] //Initialises array to hold ChatMessages, set to empty
    
    var shouldRegisterLongPress : Bool = true //Tracking whether we should register long press
    
    open lazy var attachmentManager: AttachmentManager = { [unowned self] in //Creates an AttachmentManager object
        let manager = AttachmentManager()
        manager.delegate = self //Sets delegate to self so we can deal with events
        return manager
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messagesCollectionView.messagesDataSource = self //Sets data sources and delegates to self so we can deal with events
        self.messagesCollectionView.messagesDisplayDelegate = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messageCellDelegate = self
        self.messageInputBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onChatMessage(_:)), name: .onChatMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRemoveMessage(_:)), name: .removeMessage, object: nil)
        //^ Adds an observer for when we call our 'onChatMessage' notification from elsewhere
        self.messagesCollectionView.delegate = self
        configureUI() //Calls configureUI()
        loadChatDetails() //calls loadChatDetails()
        loadFirstMessages() //calls loadFirstMessages()
        
       
    }
  
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) //Calls super inheritence
        if size ==  .zero || !isNextMessageSameSender(at: indexPath) { //If bubble has tail
            return size //returns normal size
        }
        else {
            //let newSize = CGSize(width: size.width - 12, height: size.height) //Else, adjust the width by 12px
            return size //return this new size bubble
        }
    }
    
    func loadChatDetails() {
        /* CHAT NAME */
        if self.currentChat?.members?.count == 1 { self.title = "Lonely Chat :(" } //sets title to Lonely Chat if only 1 user
        else if self.currentChat?.members?.count == 2 {
            self.title = self.currentChat?.members?.first(where: {$0.UserId != EduChat.currentUser?.UserId})?.User?.UserName
            // ^ if 2 users set title to the name of the other user
        }
        else { self.title = self.currentChat?.chatName ?? "Group Chat" } //else set title to the name of the chat
    }
    
    func loadFirstMessages() {
        DispatchQueue.main.async { //On an async thread
            ChatMethods.GetAllMessagesForChat(chatId: self.currentChat?.chatId ?? 0, completion: { (msgs, err) in //Call our API endpoint
                if err == nil { //If no errors
                    self.messages = msgs ?? [] //put messages into our global array
                    self.messagesCollectionView.reloadData() //Reload the table
                    self.messagesCollectionView.scrollToBottom() //Scroll to bottom of table
                }
            })
        }
    }
    
    
   
    
    @objc func onChatMessage(_ notification : NSNotification) {
        if let messageId = notification.userInfo?["messageId"] as? Int { //If data is in correct format
            ChatMethods.GetMessageById(messageId: messageId) { (msg) in //Gets the message by the id
                if msg != nil { self.insertMessage(msg!) } //if msg exists, call insertmessage
                self.messagesCollectionView.scrollToBottom(animated: true) //scrolls to bottom
            }
        }
    }
    @objc func onRemoveMessage(_ notification: NSNotification) { //When we recieve the notificiation
        if let messageId = notification.userInfo?["messageId"] as? Int { //If data is in correct format
            let index = self.messages.firstIndex{ $0.MessageId == messageId } //Find the index of the message with our iD
            self.messages.remove(at: index ?? 0) //Remove it from the data source array
            self.messagesCollectionView.deleteSections(IndexSet(integer: index ?? 0)) //Delete the sections
            if self.messages.count >= 2 { //IF there are many messages we need to reload views for profile pictures etc.
                self.messagesCollectionView.reloadSections([self.messages.count - 2]) //Reloads abve
            }
           
        }
    }
    
    func insertMessage(_ message: ChatMessage) {
        self.messages.append(message) //Adds the message to the list
        self.messagesCollectionView.insertSections([self.messages.count - 1]) //Inserts into the table
        if self.messages.count >= 2 { //IF there are many messages we need to reload views for profile pictures etc.
            self.messagesCollectionView.reloadSections([self.messages.count - 2]) //Reloads abve
        }
        self.messagesCollectionView.scrollToBottom() //Scrolls to bottom
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false //Disables iOS default menu from appearing
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) //Calls super method for cell at index path
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressDo(_:))) //Create a long press recogniser
        cell.addGestureRecognizer(longPressGes) //Add the reconiser to each cell
        return cell //Returns the modified cell to the collection view
    }
    
    
    @objc func longPressDo(_ ges: UILongPressGestureRecognizer) { //On a long press recognised
        if shouldRegisterLongPress { //If we should detect it
            shouldRegisterLongPress = false //Stop listening temporarily
            let touchLocation = ges.location(in: messagesCollectionView) //Get the touch location
            guard let indexPath = messagesCollectionView.indexPathForItem(at: touchLocation) else { return } //If the location is actually a message
            let msg = self.messages[indexPath.section] //Get the message from the touch point
            var alertText = "Select an option"; if msg.MessageType == 1 { alertText = alertText+": "+(msg.MessageText ?? "") } //Set the alert text
            let alert = UIAlertController(title: "Message Options", message: alertText, preferredStyle: .actionSheet) //Create the alert

            switch msg.MessageType { //Switch through each message type
            case 1: //text
                alert.addAction(UIAlertAction(title: "Copy Text", style: .default, handler: { (_) in //adds copy text action
                    UIPasteboard.general.string = msg.MessageText ?? "" //sets the text to the clipboard
                    self.shouldRegisterLongPress = true //starts listening again
                    Loaf("Message copied successfully!", state: .success, sender: UIApplication.topViewController()!).show()
                    let generator = UINotificationFeedbackGenerator(); generator.notificationOccurred(.success)
                }))
                break;
            case 2: //image
                alert.addAction(UIAlertAction(title: "View Image", style: .default, handler: { (_) in //adds view action
                    let img = UIImageView(); img.sd_setImage(with: URL(string: msg.MessageText ?? ""), completed: nil)
                    //^ Creates image view and sets image to the url
                    let imgs = [LightboxImage(image: img.image ?? UIImage())]
                    let controller = LightboxController(images: imgs, startIndex: 0)
                     //Creates full screen image view
                    self.present(controller, animated: true, completion: nil) //shows the image in full screen
                    self.shouldRegisterLongPress = true //starts listening again
                }))
                alert.addAction(UIAlertAction(title: "Save Image", style: .default, handler: { (_) in //adds save action
                    let img = UIImageView(); img.sd_setImage(with: URL(string: msg.MessageText ?? ""), completed: nil)
                    //^ Creates image view and sets image to the url
                    UIImageWriteToSavedPhotosAlbum(img.image ?? UIImage(), nil, nil, nil) //Shows img in full screen
                    self.shouldRegisterLongPress = true
                }))
            default:
                break;
            }
            if msg.UserId == EduChat.currentUser?.UserId ?? 0 { //if the message is from the sender
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in //adds delete action
                    ChatMethods.RemoveMessage(chat: self.currentChat!, messageId: msg.MessageId ?? 0)                    
                    self.shouldRegisterLongPress = true //do nothing for now
                }))
            }
            else {
                alert.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { (_) in //Adds view profile
                    UserMethods.GetUserById(userid: msg.UserId ?? 0, completion: { (user, err) in //Gets msg user
                        if let user = user { //if user is not nil
                            //guard let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as? Profile_Content) else { return } //loads profile view
                            //vc.currentUser = user; //sets profile to currentUser
                            //UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            //^ Pushes view onto stack
                        }
                    })
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in //adds cancel action
                self.shouldRegisterLongPress = true //do nothing and start listening
            }))
            UIApplication.topViewController()!.present(alert, animated: true, completion: nil) //Present the alert above everything else
        }
    }
  
   
    

}

extension Chat_View {
    func configureUI() {
        
        //Sets misc. colours:
        self.messageInputBar.inputTextView.backgroundColor = UIColor.white
        self.messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        self.messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        self.messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        self.messageInputBar.inputTextView.layer.borderWidth = 1.0
        self.messageInputBar.inputTextView.layer.cornerRadius = 16.0
        self.messageInputBar.inputTextView.layer.masksToBounds = true
        self.messageInputBar.inputTextView.delegate = self
        self.messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.messageInputBar.setRightStackViewWidthConstant(to: 38, animated: false)
        //Initialises send button:
        self.messageInputBar.setStackViewItems([self.messageInputBar.sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        self.messageInputBar.sendButton.imageView?.backgroundColor = UIColor.flatSkyBlue()
        self.messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 1.5, bottom: 1.5, right: 2)
        self.messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        self.messageInputBar.sendButton.image = UIImage(named: "send")
        self.messageInputBar.sendButton.title = nil
        self.messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        self.messageInputBar.sendButton.backgroundColor = .clear
        self.messageInputBar.middleContentViewPadding.right = -38
        self.messageInputBar.separatorLine.isHidden = true
        self.messageInputBar.isTranslucent = true
        let button = InputBarButtonItem()
        
        button.onKeyboardSwipeGesture { item, gesture in
            if gesture.direction == .left {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
            } else if gesture.direction == .right {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
            }
        } //Hide the button if swiped away ^
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(UIImage(named: "attach")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        button.onSelected { (action) in
            self.libraryCall() //Open photo libray when pressed
        }
        self.messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        self.messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        self.messageInputBar.inputPlugins = [attachmentManager] //Add our attachment manager
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageIncomingAvatarSize(.zero) //Hides avatars
        
        scrollsToBottomOnKeyboardBeginsEditing = true // scrolls to bottom when keyboard opened
        maintainPositionOnKeyboardFrameChanged = true // If user scrolls up while keyboard is open, do not force back down
    }
}

extension Chat_View : MessagesDataSource {
    
    
    func currentSender() -> SenderType {
        return EduChat.currentUser! //The current sender is our user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section] //Sets each message from the message array
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count //Totals up the messagess
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.sd_setImage(with: URL(string: self.messages[indexPath.section].User?.UserProfilePictureURL ?? ""))
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2; avatarView.layer.borderColor = UIColor.flatGray().cgColor
        //sets avatar to the image of the sender, hides if it is not the last message in a row from that user
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if !isNextMessageSameSender(at: indexPath) { //If this is last message in row from user
            let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft //Changes tail direction
            return .bubbleTail(tail, .curved)
        }
        return .bubble //Normal bubble style
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < self.messages.count else { return false }
        return self.messages[indexPath.section].UserId == self.messages[indexPath.section + 1].UserId
    }
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return self.messages[indexPath.section].UserId == self.messages[indexPath.section - 1].UserId
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        if self.messages[indexPath.section].UserId == EduChat.currentUser?.UserId { return .zero }
        else if isNextMessageSameSender(at: indexPath) { return .zero }
        else { return CGSize(width: 100, height: 50) }
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) { //Fr every media image item
        imageView.sd_setImage(with: URL(string: self.messages[indexPath.section].MessageText ?? "")!, placeholderImage: UIImage(), options: .allowInvalidSSLCertificates, context: [:]) //Downloads and caches the image at the URL
    }
    

    
}

extension Chat_View : InputBarAccessoryViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) { //Hooks into text bars send button
        if (text.trim() != "" && text.trim() != " ") {
            // ^ Creates text object with text entered
            let msg = ChatMessage(chatid: self.currentChat?.chatId ?? 0, userid: EduChat.currentUser?.UserId ?? 0, messageType: 1, messageText: text.trim(), dateCreated: Date().toString())
            msg?.User = EduChat.currentUser //Sets the message's user to the current one
            ChatMethods.AddNewMessageToChat(chatid: self.currentChat?.chatId ?? 0, message: msg!) { (success, returnMsg) in //Cals AddNewMessage endpoint
                if success == false { print("error") } //if fails, print error
                else { MainHost.chatConnection.sendMessage(senderId: EduChat.currentUser?.UserId ?? 0, groupToSendTo: self.currentChat?.getGroupNameForSignalR() ?? "", messageId: returnMsg?.MessageId ?? 0)} //Else, call our SignalR function
            }
            self.messageInputBar.inputTextView.text = "" //Clears input bar
        }
        if (attachmentManager.attachments.count > 0) { //Checks if any attachments have been added
            for attachment in attachmentManager.attachments { //Loops through each attachment
                switch (attachment) { //The attachment object is a 'struct' so we switch through possible types
                case .image(let image): //If it is an image
                    ChatMethods.UploadChatAttachment(chatId: self.currentChat?.chatId ?? 0, img: image) { (url) in //Uploads image
                       
                        let msg = ChatMessage(chatid: self.currentChat?.chatId ?? 0, userid: EduChat.currentUser?.UserId ?? 0, messageType: 2, messageText: url ?? "", dateCreated: Date().toString())
                        msg?.User = EduChat.currentUser //Sets the message's user to the current one
                        // ^ After the new URL is returned, create a new message object, attach the date and user
                        ChatMethods.AddNewMessageToChat(chatid: self.currentChat?.chatId ?? 0, message: msg!, completion: { (success, returnMsg) in
                            if success == false { print("error") } //<^ Sends off message to API, if there is an error print it
                            else { //If not, send the message through the SignalR connection and add it to the current chat view
                                MainHost.chatConnection.sendMessage(senderId: EduChat.currentUser?.UserId ?? 0, groupToSendTo: self.currentChat?.getGroupNameForSignalR() ?? "", messageId: returnMsg?.MessageId ?? 0)
                            }
                        })
                    }
                    break;
                case .url(_): //The API demands switch statements are exhaustive, so we just ignore other cases
                    break;
                case .data(_):
                    break;
                case .other(_):
                    break;
                }
            }
        }
    }
    
    func libraryCall() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
    
}

extension Chat_View : AttachmentManagerDelegate {
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
        
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = self.messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
    
    
    
}

extension Chat_View : UITextViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if self.attachmentManager.attachments.count == 0 {
            if text.trim() == "" { self.messageInputBar.sendButton.isEnabled = false }
            else { self.messageInputBar.sendButton.isEnabled = true }
        }
        else { self.messageInputBar.sendButton.isEnabled = true }
    }
}



extension Chat_View : MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        let c = cell as! MediaMessageCell
        let imgs = [LightboxImage(image: c.imageView.image ?? UIImage())]
        let controller = LightboxController(images: imgs, startIndex: 0)
        self.present(controller, animated: true, completion: nil)
    }
    

}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
