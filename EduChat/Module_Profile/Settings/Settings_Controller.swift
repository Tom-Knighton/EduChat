//
//  Settings_Controller.swift
//  EduChat
//
//  Created by Tom Knighton on 04/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class Settings_Controller: UITableViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let settingsParent = self.parent as! Settings_Host
        //settingsParent.saveContrainerViewRefference(vc: self)
        //settingsParent.
        loadData()
    }

    func loadData() {
        self.usernameField.text = EduChat.currentUser?.UserName ?? ""
        self.nameField.text = EduChat.currentUser?.UserFullName ?? ""
        self.genderField.text = EduChat.currentUser?.UserGender ?? ""
        self.emailField.text = EduChat.currentUser?.UserEmail ?? ""
        self.schoolField.text = EduChat.currentUser?.UserSchool ?? ""
        //Sets text field to user's stats
    }
    
    

    @IBAction func logOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        EduChat.currentUser = nil
        EduChat.isAuthenticated = false
        UserDefaults.standard.set(-1, forKey: "CacheUserId")
        UserDefaults.standard.set("", forKey: "CacheUserEmail")
        UserDefaults.standard.set("", forKey: "CacheUserPass")
        let view = UIStoryboard(name: "Login_Signup", bundle: nil).instantiateInitialViewController()
        UIApplication.topViewController()?.present(view!, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        let modifUName = self.usernameField.text?.trim() ?? ""
        let modifFName = self.nameField.text?.trim() ?? ""
        let modifGender = self.genderField.text?.trim() ?? ""
        let modifEmail = self.emailField.text?.trim() ?? ""
        let modifSchool = self.schoolField.text?.trim() ?? ""
        //^ sets some variables to the trimmed text from our fields
        var modifUser = EduChat.currentUser //Creates a new user object based on the current user
        self.lockAndDisplayActivityIndicator(enable: true) //Locks and shows spinner
        UserMethods.IsUsernameFree(username: modifUName) { (isUFree) in //Asks API if username is free
            if isUFree || (!isUFree && modifUName == EduChat.currentUser?.UserName){ //If it is free OR the user hasn't changed the username from what it was
                UserMethods.IsEmailFree(email: modifEmail, completion: { (isEFree) in //Asks API if email is free
                    if isEFree || (!isEFree && modifEmail == EduChat.currentUser?.UserEmail) { //If is free OR the user hasn't changed it
                        if modifUName == "" || modifFName == "" || modifGender == "" || modifEmail == "" { //If required files aren't filled in
                            UIApplication.topViewController()?.displayBasicError(title: "Error", message: "Please fill out all required fields")
                            self.lockAndDisplayActivityIndicator(enable: false)
                            return; //Exits procedure
                        }
                        else { //If they are filled in
                            modifUser?.UserName = modifUName; modifUser?.UserEmail = modifEmail; modifUser?.UserGender = modifGender
                            modifUser?.UserFullName =  modifFName; // < ^ sets modifiedUser object to new values
                            if (modifSchool == "") { modifUser?.UserSchool = "N/A" }
                            else { modifUser?.UserSchool = modifSchool}
                            UserMethods.ModifyUser(usr: modifUser!, userid: EduChat.currentUser?.UserId ?? 0) { (User, Err) in //Calls ModifyUser endpoint
                                self.lockAndDisplayActivityIndicator(enable: false) //unlocks display
                                if Err == nil { //If no error
                                    EduChat.currentUser = User //sets current user to new modified user
                                    self.navigationController?.popViewController(animated: true) //dismisses view
                                }
                                else {
                                    self.displayBasicError(title: "Error", message: "An error occurred")
                                }
                            }
                        }
                    }
                    else {
                        self.lockAndDisplayActivityIndicator(enable: false)
                        self.displayBasicError(title: "Error", message: "That email is already taken!")
                    }
                })
            }
            else {
                self.lockAndDisplayActivityIndicator(enable: false)
                self.displayBasicError(title: "Error", message: "That username is already taken!")
            }
        }
    }
    
}
