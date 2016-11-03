//
//  EFLBaseNavigationController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import QuartzCore

class EFLBaseNavigationController: UINavigationController {
    
    var statusStyle: UIStatusBarStyle = .Default
}


// MARK: - Shadow Settings
extension EFLBaseNavigationController {
    
    func setShadow() {
        let layer = self.navigationBar.layer
        layer.shadowColor = UIColor.eflBlackColor().CGColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.masksToBounds = false
        layer.shouldRasterize = true
    }
    
    func removeShadow() {
        let layer = self.navigationBar.layer
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
}
