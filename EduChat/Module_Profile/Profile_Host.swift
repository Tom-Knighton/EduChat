//
//  Profile_Host.swift
//  EduChat
//
//  Created by Tom Knighton on 15/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import Pastel
import EZSwipeController
import ChameleonFramework

class Profile_Host: EZSwipeController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
    
    override func setupView() {
        self.datasource = self
    }
}

extension Profile_Host: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedHost")
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileHost")
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatHost")
        
        return [feedVC!, profileVC!, chatVC!]
    }
    
    func indexOfStartingPage() -> Int {
        return 1
    }
    
    func changedToPageIndex(_ index: Int) {
        switch (index) {
        case 0:
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.blue
            }
            break;
        case 1:
            UIView.animate(withDuration: 0.5) {
                 self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
            }
            break;
        case 2:
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.red
            }
            break;
        default:
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
            }
            break;
        }
    }
    
}
