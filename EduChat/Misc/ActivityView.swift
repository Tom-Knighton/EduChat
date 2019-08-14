//
//  ActivityView.swift
//  EduChat
//
//  Created by Tom Knighton on 15/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit

class ActivityView: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        spinnerBG.layer.cornerRadius = 20
        spinnerBG.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        spinner.stopAnimating()
    }

   

}
