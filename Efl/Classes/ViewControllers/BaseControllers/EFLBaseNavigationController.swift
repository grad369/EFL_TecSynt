//
//  EFLBaseNavigationController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseNavigationController: UINavigationController {
    
    var statusStyle: UIStatusBarStyle = .Default
    // MARK: - View life
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setShadow()
    }
}


extension EFLBaseNavigationController { // Public functions
    
    // MARK: Navigation Bar Seperation Hide
    func removeNavigationBarSperarationView(){
        self.tabBarController?.tabBar.hidden = true
        
        self.navigationBar.clipsToBounds = true
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.eflRedColor()
        }
    }
    
    // MARK: - Shadow Settings
    func setShadow() {
      //  self.navigationBar.translucent = false
//        self.navigationBar.barTintColor = UIColor.eflGreenColor()
//        self.navigationBar.titleTextAttributes = [NSFontAttributeName: FONT_MEDIUM_19!, NSForegroundColorAttributeName: UIColor.eflWhiteColor()]
        
//        self.navigationBar.layer.shadowColor = UIColor.eflBlackColor().CGColor
//        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 0.0)
//        self.navigationBar.layer.shadowRadius = 2.0
//        self.navigationBar.layer.shadowOpacity = 0.5
        
        for parent in self.navigationBar.subviews {
            for childView in parent.subviews {
                print(childView)
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
//        self.navigationBar.clipsToBounds = false
    }
    
    func removeShadow() {
        self.navigationBar.layer.shadowColor = UIColor.eflBlackColor().CGColor
        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.navigationBar.layer.shadowRadius = 0.3
        self.navigationBar.layer.shadowOpacity = 0.5
    }
}
