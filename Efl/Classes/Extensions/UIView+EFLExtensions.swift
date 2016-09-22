//
//  UIViewKK.swift
//  Efl
//
//  Created by vaskov on 21.09.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
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
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: self.layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
}

