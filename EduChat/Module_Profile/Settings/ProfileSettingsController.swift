//
//  ProfileSettingsController.swift
//  EduChat
//
//  Created by Tom Knighton on 06/02/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

enum ProfileSubjectCellTypes { //Types of cells to display
    case image
    case basicDetails
    case bio
    case details
    case sensitive
}



class ProfileSettingsController: UITableViewController {

    var currentViewingUser : User? = EduChat.currentUser
    var uneditedCurrentUser : User? = EduChat.currentUser
    
    let cellTypes : [ProfileSubjectCellTypes] = [.image, .basicDetails, .bio, .details, .sensitive] //Array of cell types that will actually be displayed
    var cells : [UITableViewCell] = [] //Updated models of cells
    
    var hasModifiedImage: Bool = false; var newImage : UIImage?
    //Global variables, if user has changed image and if so to what
    
    var delegate : ProfileControllerDelegate? //Link to the Profile Screen
    
    override func viewDidLoad() { //On view load
        super.viewDidLoad() //Calls super viewDidLoad
        self.endEditingWhenViewTapped() //Dismiss keyboard when view tapped
        self.setupTable() //Sets up table dimensions
        
    }
    override func viewWillAppear(_ animated: Bool) { //Every time view appears
        super.viewWillAppear(animated)
        self.createNavBarItems() //Recreate nav bar buttons as iOS likes them to disappear
    }

    func setupTable() {
        self.tableView.estimatedRowHeight = 100 //Estimates row height at 100
        self.tableView.rowHeight = UITableView.automaticDimension //Sets them to lay themselves out with autoconstraints
    }
    func createNavBarItems() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveUserSettings)) //Creates save button
        let dismissButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.dismissPressed)) //Creates cancel button
        self.navigationItem.rightBarButtonItems = [saveButton] //Sets save button on right
        if #available(iOS 13, *) { self.navigationItem.leftBarButtonItems = [dismissButton] }
        //If iOS 13 available then screen is modally presented, display cancel button
    }
   
    @objc func dismissPressed() { //On the dismiss button
        self.dismiss(animated: true) { //Dismiss view
            self.delegate?.reloadAllData() //Reload profile date
        }
    }
    
    
    @objc func saveUserSettings() {
       
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        //^ iOS likes to not resign first responder when tapping the save button, so textFieldDidEndEditing is not fired
        //So i just end editing everywhere in app
        UIApplication.shared.sendAction(#selector(setter: UIApplication.isStatusBarHidden), to: nil, from: nil, for: .none)
        
        
        let hasModifiedImage = self.hasModifiedImage
        let newUserName = self.currentViewingUser?.UserName?.trim() ?? ""
        let newFullName = self.currentViewingUser?.UserFullName?.trim() ?? ""
        let newEmail = self.currentViewingUser?.UserEmail?.trim() ?? ""
        let newBio = self.currentViewingUser?.Bio?.trim() ?? ""
        let newSchool = self.currentViewingUser?.UserSchool?.trim() ?? ""
        let newGender = self.currentViewingUser?.UserGender?.trim() ?? ""
        let newDOB = self.currentViewingUser?.UserDOB?.trim() ?? ""
        
        //Checking for nil or empty values
        if (self.hasModifiedImage == true && self.newImage == nil) || newUserName == "" || newFullName == "" || newEmail == "" || newGender == "" || newDOB == "" { self.displayBasicError(title: "Error", message: "Please fill out all fields"); return; }
        
        //Checking for email / username availability
        //If email has been changed
        if newEmail != self.uneditedCurrentUser?.UserEmail ?? "" {
            UserMethods.IsEmailFree(email: newEmail) { (free) in
                //If email is not free, display error informing user and return
                if !free { self.displayBasicError(title: "Sorry!", message: "That e-mail address is already in use!"); return; }
            }
        }
        
        //If username has been changed
        if newUserName != self.uneditedCurrentUser?.UserName ?? "" {
            UserMethods.IsUsernameFree(username: newUserName) { (free) in
                //If username is not free, display error informing user and return
                if !free { self.displayBasicError(title: "Sorry!", message: "That username is already in use"); return}
            }
        }
        
        let tasksGroup = DispatchGroup() //Create dispatch group
        self.lockAndDisplayActivityIndicator(enable: true)
        //If Bio has been changed:
        if newBio != self.uneditedCurrentUser?.Bio ?? "" {
            tasksGroup.enter()
            UserMethods.UploadNewBio(for: self.currentViewingUser?.UserId ?? 0, bio: UserBio(UserId: self.currentViewingUser?.UserId ?? 0, Bio: newBio)!) { (bio) in
                self.currentViewingUser?.Bio = bio
                tasksGroup.leave()
            }
        }
        
        //If image has been changed:
        if hasModifiedImage {
            tasksGroup.enter()
            UserMethods.UploadUserProfilePicture(userid: self.currentViewingUser?.UserId ?? 0, img: newImage ?? UIImage()) { (newUser) in
                self.currentViewingUser?.UserProfilePictureURL = newUser?.UserProfilePictureURL ?? ""
                tasksGroup.leave()
            }
        }
        
        tasksGroup.notify(queue: .main) {
            let newUser = User(UserId: self.currentViewingUser?.UserId ?? 0, UserEmail: newEmail, UserName: newUserName, UserFullName: newFullName, UserProfilePictureURL: self.currentViewingUser?.UserProfilePictureURL ?? "", UserSchool: newSchool, UserGender: newGender, UserDOB: newDOB, IsModerator: self.currentViewingUser?.IsModerator ?? false , IsAdmin: self.currentViewingUser?.IsAdmin ?? false, IsDeleted: self.currentViewingUser?.IsDeleted ?? false, UserPassHash: self.currentViewingUser?.UserPassHash ?? "")
            UserMethods.ModifyUser(usr: newUser!, userid: newUser?.UserId ?? 0) { (finalUser, err) in
                if err != nil { self.lockAndDisplayActivityIndicator(enable: false); self.displayBasicError(title: "Sorry", message: "An Error occurred editing this user"); return; }
                EduChat.currentUser = finalUser
                self.delegate?.reloadAllData()
                guard #available(iOS 13, *) else {
                    self.navigationController?.popViewController(animated: true)
                    return;
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.cellTypes[indexPath.row]
        switch (type) { //Check type of cell and what to do:
        case .image:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsImageCell", for: indexPath) as? ProfileSettingsImageCell else { return UITableViewCell() }
            cell.populate(with: self.currentViewingUser, newImage: self.hasModifiedImage ? self.newImage : nil)
            cell.delegate = self
            cells.removeAll(where: { $0 is ProfileSettingsImageCell })
            cells.append(cell)
            return cell
            //Return the modified cell
        case .basicDetails:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsBasicCell", for: indexPath) as? ProfileSettingsBasicCell else { return UITableViewCell() }
            cell.populate(with: self.currentViewingUser)
            cell.delegate = self
            cells.removeAll(where: { $0 is ProfileSettingsBasicCell })
            cells.append(cell)
            return cell
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsBioCell", for: indexPath) as? ProfileSettingsBioCell else { return UITableViewCell() }
            cell.populate(with: self.currentViewingUser)
            cell.delegate = self
            cells.removeAll(where: { $0 is ProfileSettingsBioCell })
            cells.append(cell)
            return cell
        case .details:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsDetailsCell", for: indexPath) as? ProfileSettingsDetailsCell else { return UITableViewCell() }
            cell.populate(with: self.currentViewingUser)
            cell.delegate = self
            cells.removeAll(where: { $0 is ProfileSettingsDetailsCell })
            cells.append(cell)
            return cell
        case.sensitive:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsSensitiveCell", for: indexPath) as? ProfileSettingsSensitiveCell else { return UITableViewCell() }
            cell.delegate = self
            cells.removeAll(where: { $0 is ProfileSettingsSensitiveCell })
            cells.append(cell)
            return cell
        }
    }
}

extension ProfileSettingsController : ProfileSettingsDelegate {
    func updateEditedUser(_ user: User?) {
        self.currentViewingUser = user //Updates currentViewingUser model
    }
    
    func updateProfilePicture(_ img: UIImage?) {
        self.hasModifiedImage = true //Sets hasModifiedImage to true
        self.newImage = img //Updates actual image with new one
    }
    
    func displayView(vc: UIViewController?) {
        guard let vc = vc else { return } //Ensures vc is valid and exists
        self.present(vc, animated: true, completion: nil) //Presents vc
    }
}
