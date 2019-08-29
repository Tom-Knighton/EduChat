//
//  Profile_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 15/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ShadowView
import ChameleonFramework

class Profile_Content: UITableViewController {

    @IBOutlet weak var profileHeaderView: ShadowView!
    @IBOutlet weak var profileHeaderName: UILabel!
    @IBOutlet weak var profileHeaderImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileHeaderView.shadowRadius = 5
        self.profileHeaderView.shadowOffset = CGSize.zero
        self.profileHeaderView.shadowColor = UIColor.flatBlack
        self.profileHeaderView.shadowOpacity = 0.3
        
        self.profileHeaderName.text = EduChat.currentUser?.UserFullName
        //self.profileHeaderImage.image.url
    }
    
    
    
    
}

