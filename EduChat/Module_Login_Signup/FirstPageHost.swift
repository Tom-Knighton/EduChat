//
//  FirstPageHost.swift
//  EduChat
//
//  Created by Tom Knighton on 12/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ChameleonFramework

class FirstPageHost: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
        
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func goToWebPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://educhat.tomk.online")!, options: [:], completionHandler: nil)
    }
    

}
