//
//  MainHost.swift
//  EduChat
//
//  Created by Tom Knighton on 22/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class MainHost: UITabBarController {

    static var chatConnection : Chat_Signal = Chat_Signal()
    override func viewDidLoad() {
        self.view.backgroundColor = .flatWhite()
        self.selectedIndex = 1
        
        for tabBarItem in tabBar.items!
        {
            guard #available(iOS 13, *) else {
                if tabBarItem.image != UIImage(named: "user") {
                    tabBarItem.title = ""
                    tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -8, right: 0)
                }
                return
            }
                     
        }
        MainHost.chatConnection.setup_signal()
        
        if EduChat.currentUser == nil || EduChat.isAuthenticated == false {
            UIApplication.topViewController()?.kickToZeroPage()
            return
        }
        if EduChat.currentUser?.Subjects?.count == 0 {
            UIApplication.topViewController()?.displayBubbleSubjectPicker()
        }
    }
    

   
}
