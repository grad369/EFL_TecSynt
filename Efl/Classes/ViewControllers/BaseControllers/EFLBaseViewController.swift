//
//  EFLBaseViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import QuartzCore

class EFLBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurationNavigationAndStatusBars()
        self.configurationView()
    }
}

extension EFLBaseViewController {
    
    // MARK: - configuration Navigation Item and Status Bar in inherit classes
    func configurationNavigationAndStatusBars() {
    }
    
    // MARK: Initialise View in inherit classes
    func configurationView() {
    }
}


// MARK: Configuration Navigation and Status bars
extension EFLBaseViewController {
    
    func setConfigurationNavigationBar(title: String?, titleView: UIView?, backgroundColor: EFLColorType, topRoundCorner: CGFloat) {
        if title != nil {
            self.navigationItem.title = title
        }
        if titleView != nil {
            self.navigationItem.titleView = titleView
        }
        if topRoundCorner != 0 {
            roundNavigationBar(topRoundCorner)
        }
        
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.translucent = false
        
        switch backgroundColor {
        case .White:
            navigationBar.barTintColor = UIColor.eflWhiteColor()
            navigationBar.titleTextAttributes = [NSFontAttributeName: FONT_MEDIUM_19!, NSForegroundColorAttributeName: UIColor.eflBlackColor()]
        case .Green:
            navigationBar.barTintColor = UIColor.eflGreenColor()
            navigationBar.titleTextAttributes = [NSFontAttributeName: FONT_MEDIUM_19!, NSForegroundColorAttributeName: UIColor.eflWhiteColor()]
        default: break
        }
    }
    
    func setConfigurationStatusBar(colorBackgroundType: EFLColorType) {
        
        guard let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }
        
        switch colorBackgroundType {
        case .Black:
            statusBar.backgroundColor = UIColor.eflBlackColor()
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        case .White:
            statusBar.backgroundColor = UIColor.eflWhiteColor()
            UIApplication.sharedApplication().statusBarStyle = .Default
        case .Green:
            statusBar.backgroundColor = UIColor.clearColor()
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        }
        
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    func setBarButtonItem(buttonType: EFLBarButtonType, placeType: EFLBarButtonPlaceType, tintColorType: EFLColorType, widthSpace: CGFloat = 0) -> UIBarButtonItem? {
        
        let buttonItem: UIBarButtonItem? = self.barButtonItem(buttonType, placeType: placeType, tintColorType: tintColorType)
        
        if buttonItem == nil {
            return nil
        }
        
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = widthSpace
        
        if placeType == .Left {
            self.navigationItem.setLeftBarButtonItems([negativeSpace, buttonItem!], animated: true)
        } else {
            self.navigationItem.setRightBarButtonItems([buttonItem!, negativeSpace], animated: true)
        }
        
        return buttonItem
    }
}

// Mark: private functions
private extension EFLBaseViewController {
    
    func roundNavigationBar(roundCorner: CGFloat = 8) {
        let navigationBar = self.navigationController!.navigationBar
        let path = UIBezierPath(roundedRect: navigationBar.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(roundCorner, roundCorner))
        let layer = CAShapeLayer()
        layer.frame = navigationBar.bounds
        layer.path = path.CGPath
        navigationBar.layer.mask = layer
    }
    
    func barButtonItem(buttonType: EFLBarButtonType, placeType: EFLBarButtonPlaceType, tintColorType: EFLColorType) -> UIBarButtonItem? {
        var buttonItem: UIBarButtonItem?
        
        let actionSelector = Selector((placeType == .Left ? "left" : "right") + "BarButtonItemDidPress")
        
        switch buttonType {
        case .None:
            buttonItem = nil
        case .Ok:
            buttonItem = UIBarButtonItem(customView: self.buttonForBarButton("".localized, placeType: placeType, tintColorType: tintColorType))
        case .Plus:
            buttonItem = UIBarButtonItem(image: UIImage(named:"NavigationPlusButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: actionSelector)
        case .Send:
            buttonItem = UIBarButtonItem(customView: self.buttonForBarButton("SEND_BUTTON_TITLE".localized, placeType: placeType, tintColorType: tintColorType))
        case .AddFriends:
            buttonItem = UIBarButtonItem(image: UIImage(named:"topnav_addfriend_white"), style: UIBarButtonItemStyle.Plain, target: self, action: actionSelector)
        case .Back:
            buttonItem = UIBarButtonItem(image: UIImage(named:"NavigationBackButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: actionSelector)
        case .Close:
            buttonItem = UIBarButtonItem(image: UIImage(named:"NavigationPlusButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: actionSelector)
        case .Cancel:
            buttonItem = UIBarButtonItem(customView: self.buttonForBarButton("ALERT_CANCEL_BUTTON_TITLE".localized, placeType: placeType, tintColorType: tintColorType))
        case .Share:
            buttonItem = UIBarButtonItem(image: UIImage(named:"topnav_share_white"), style: UIBarButtonItemStyle.Plain, target: self, action: actionSelector)
        }
        buttonItem?.tintColor = tintColorType == .White ? UIColor.eflWhiteColor() : UIColor.eflBlackColor()
        
        return buttonItem
    }
    
    func buttonForBarButton(title: String, placeType: EFLBarButtonPlaceType, tintColorType: EFLColorType) -> UIButton {
        
        let button = UIButton.init(type: UIButtonType.System)
        button.frame = CGRectMake(0, 0, 60, 44)
        button.backgroundColor = UIColor.clearColor()
        button.setTitle(title, forState: UIControlState.Normal)
        button.contentHorizontalAlignment = (placeType == .Left ? .Left : .Right)
        
        let titleColor = tintColorType == .White ? UIColor.eflWhiteColor() : UIColor.eflBlackColor()
        let actionSelector = Selector((placeType == .Left ? "left" : "right") + "BarButtonItemDidPress")
        button.setTitleColor(titleColor, forState: UIControlState.Normal)
        button.titleLabel?.font = FONT_REGULAR_19
        button.addTarget(self, action: actionSelector, forControlEvents: UIControlEvents.TouchUpInside)
        button.titleLabel?.textAlignment = (placeType == .Left ? .Left : .Right)
        
        return button
    }
}
