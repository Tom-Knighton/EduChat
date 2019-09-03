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
import Magnetic
import Alamofire

extension String {
    var toBool : Bool {
        return NSString(string: self).boolValue
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

    var encrypt: String {
        let password : Array<UInt8> = Array(self.utf8) // Converts string to an array of UInt8
        let hash : Array<UInt8> = Array("tYWbvhsGjuJvppzDiofv".utf8) //Secret 'salt' string
        
        let key = try! PKCS5.PBKDF2(password: password, salt: hash).calculate() //Encrypts the password with the salt
        return key.toBase64() ?? "" //returns the encrypted password as a string
    }
    
    var isEmail : Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        // ^ regex for a string in the format of an email
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        //if string matches
    }
    
    var isValidPassword : Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-_]).{8,}", options: [])
        // ^ regex for a string that has at least one lower case, one upper case, one special character and is 8 or more characters long
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        //if string matches
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
    
    var bubbleSubjectPicker : UIViewController {
        return UIStoryboard(name: "Login_Signup", bundle: nil).instantiateViewController(withIdentifier: "SubjectBubblePicker") as UIViewController
    }
    var zeroPageController : UIViewController{
        return UIStoryboard(name: "Login_Signup", bundle: nil).instantiateViewController(withIdentifier: "zeroPage") as UIViewController
    }
    
    func lockAndDisplayActivityIndicator(enable: Bool) {
        if enable {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(activityView)
        }
        else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.view.viewWithTag(999)?.removeFromSuperview()
        }
    }
    
    func displayBubbleSubjectPicker() {
        
        self.present(bubbleSubjectPicker, animated: true, completion: nil)
    }
    
    func kickToZeroPage() {
        self.present(zeroPageController, animated: false, completion: nil)
    }
}

extension UIView {
    func displayBasicError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
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



private let arrayParametersKey = "arrayParametersKey"
public struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}



