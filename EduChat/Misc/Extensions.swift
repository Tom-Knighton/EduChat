//
//  Extensions.swift
//  EduChat
//
//  Created by Tom Knighton on 11/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

extension String {
    var toBool : Bool {
        return NSString(string: self).boolValue
    }
    
    var encrypt: String {
        let password : Array<UInt8> = Array(self.utf8) // Converts string to an array of UInt8
        let hash : Array<UInt8> = Array("tYWbvhsGjuJvppzDiofv".utf8) //Secret 'salt' string
        
        let key = try! PKCS5.PBKDF2(password: password, salt: hash).calculate() //Encrypts the password with the salt
        return key.toBase64() ?? "" //returns the encrypted password as a string
    }
    
    var isEmail : Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    var isValidPassword : Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}", options: [])
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension UIViewController {
    func endEditingWhenViewTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func displayBasicError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    var activityView : UIView {
        return (self.storyboard?.instantiateViewController(withIdentifier: "Login_Activity").view)!
    }
    
    func lockAndDisplayActivityIndicator(enable: Bool) {
        if enable {
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(activityView)
        }
        else {
            self.view.isUserInteractionEnabled = true
            self.view.viewWithTag(999)?.removeFromSuperview()
        }
    }
}

extension UIView {
    func displayBasicError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
