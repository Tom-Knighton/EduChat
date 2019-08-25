//
//  zeroPage.swift
//  EduChat
//
//  Created by Tom Knighton on 25/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class zeroPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad")
        let cachedId = UserDefaults.standard.integer(forKey: "CacheUserId")
        let cachedEmail = UserDefaults.standard.string(forKey: "CacheUserEmail") ?? ""
        let cachedHash = UserDefaults.standard.string(forKey: "CacheUserPass") ?? ""
        
        if (cachedId != 0 && cachedEmail != "" && cachedHash != "") {
            let aUsr = AuthenticatingUser(authenticator: cachedEmail, passhash: cachedHash)
            UserMethods.AuthenticateUser(usr: aUsr!) { (User, Err) in
                if Err == nil {
                    //Success, user still logged in
                    
                    DispatchQueue.main.async {
                        print("goToMain")

                        self.performSegue(withIdentifier: "zeroPageToMain", sender: self)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "zeroPageToLSFlow", sender: self)
                        print("lsFLOw1")
                    }
                    //User is no longer valid
                }
            }
        }
        else {
            // User has not logged in before
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "zeroPageToLSFlow", sender: self)
                print("lsflow2")
            }
        }
    
    }

  

}
