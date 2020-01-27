//
//  EduChat+UIButton.swift
//  EduChat
//
//  Created by Tom Knighton on 15/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
   
}

public class PaddedButton : UIButton {
    @IBInspectable public var bottomInset: CGFloat {
        get { return touchPadding.bottom }
        set { touchPadding.bottom = newValue }
    }
    @IBInspectable public var leftInset: CGFloat {
        get { return touchPadding.left }
        set { touchPadding.left = newValue }
    }
    @IBInspectable public var rightInset: CGFloat {
        get { return touchPadding.right }
        set { touchPadding.right = newValue }
    }
    @IBInspectable public var topInset: CGFloat {
        get { return touchPadding.top }
        set { touchPadding.top = newValue }
    }
    
    public var touchPadding = UIEdgeInsets.zero
}
