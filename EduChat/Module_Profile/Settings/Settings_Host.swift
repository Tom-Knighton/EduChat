//
//  Settings_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 04/09/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class Settings_Host: UIViewController {

    var settingsVC : Settings_Controller?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingsVC = self.children[0] as! Settings_Controller
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let modifUName = self.settingsVC?.usernameField.text?.trim() ?? ""
        let modifFName = self.settingsVC?.nameField.text?.trim() ?? ""
        let modifGender = self.settingsVC?.genderField.text?.trim() ?? ""
        let modifEmail = self.settingsVC?.emailField.text?.trim() ?? ""
        let modifSchool = self.settingsVC?.schoolField.text?.trim() ?? ""
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
                                    self.dismiss(animated: true, completion: nil) //dismisses view
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
    

    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveContrainerViewRefference(vc:Settings_Controller){
        
        self.settingsVC = vc
        
    }
}
