//
//  ProfileSettingsDelegate.swift
//  EduChat
//
//  Created by Tom Knighton on 15/03/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

/**
 A protocol that allows for the ProfileSettingsController to recieve updates from the settings views
 */
public protocol ProfileSettingsDelegate : AnyObject {
    
    /// Updates the 'User' object that is currently being edited and displayed
    ///
    /// - Parameter user: The user being updated
    func updateEditedUser(_ user: User?)
    
    /// Updates the image displayed as the modified user's profile image
    /// - Parameter img: The image being passed as the new image
    func updateProfilePicture(_ img: UIImage?)
    
    /// Allows views to ask the View Controller to display alerts or any top level views
    /// - Parameter vc: The controller to be displayed
    func displayView(vc: UIViewController?)
}
