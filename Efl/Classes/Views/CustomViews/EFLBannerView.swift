//
//  EFLBannerView.swift
//  Efl
//
//  Created by vishnu vijayan on 10/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

public let upperHeightBelowNavBar: CGFloat! = 15
public let xLabelOffset: CGFloat! = 10
public let yLabelOffset: CGFloat! = 8

class EFLBannerView: UIView {
    
    private var currentlyOnView : Bool!
    private var bannerLabel : UILabel!
    private var previousView: UIView?
    
    var heightOffset: CGFloat = 0
    
    class var sharedBanner : EFLBannerView {
    
        struct Static {
            static var instance : EFLBannerView?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            
            Static.instance = EFLBannerView()
        }
        return Static.instance!
    }
    
    init()
    {
        super.init(frame: CGRectMake((APP_DELEGATE.window?.rootViewController!.view.frame.origin.x)!, (APP_DELEGATE.window?.rootViewController!.view.frame.origin.y)!, (APP_DELEGATE.window?.rootViewController!.view.frame.size.width)!, 0))
        self.setupNotificationBanner()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.setupNotificationBanner()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupNotificationBanner()
    }
    
}


extension EFLBannerView {
    
    func showBanner(currentView:UIView, message:String, yOffset:CGFloat) {
        
        if !currentlyOnView! {
            self.currentlyOnView = true
            heightOffset = yOffset
            self.frame = CGRectMake(0, heightOffset - upperHeightBelowNavBar, currentView.frame.size.width, 0)
            
            bannerLabel = UILabel(frame:CGRectMake(xLabelOffset, 0, self.frame.size.width - (2 * xLabelOffset), 0))
            bannerLabel.numberOfLines = 0;
            bannerLabel.font = FONT_REGULAR_13
            bannerLabel.textColor = UIColor.eflWhiteColor()
            bannerLabel.textAlignment = NSTextAlignment.Center
            bannerLabel.text = message
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.frame = CGRectMake(0, self.heightOffset - upperHeightBelowNavBar, self.frame.size.width, self.heightForView(message, width: currentView.frame.size.width - (2 * xLabelOffset)) + (2 * yLabelOffset) + upperHeightBelowNavBar)
                self.bannerLabel.frame = CGRectMake(xLabelOffset, yLabelOffset + upperHeightBelowNavBar, self.frame.size.width - (2 * xLabelOffset), self.frame.size.height - (2 * yLabelOffset) - upperHeightBelowNavBar)
                self.bannerLabel.layoutIfNeeded()
                }, completion: { finished in
                    
                    if finished{
                        self.hideBanner()
                    }
            })
            self.addSubview(bannerLabel)
            
            let subviewsArray  = currentView.subviews
            var index: NSInteger?
            for item in subviewsArray {
                if item.isKindOfClass(EFLTriangleView) {
                      index = subviewsArray.indexOf(item)
                    currentView.insertSubview(self, atIndex: index!)

                }else {
                    currentView.addSubview(self)
                }
            }
        }
    }
    
    func hideBanner() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),BannerCrossDissolveTime * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.5, animations: {
                self.frame = CGRectMake(0, self.heightOffset - upperHeightBelowNavBar, (APP_DELEGATE.window?.rootViewController!.view.frame.size.width)!, 0)
                self.bannerLabel.frame = CGRectMake(xLabelOffset, 0, self.frame.size.width - (2 * xLabelOffset), 0)
                self.bannerLabel.layoutIfNeeded()
                }, completion: {
                    finished in
                    if finished{
                        self.bannerLabel.removeFromSuperview()
                        self.removeFromSuperview()
                        self.currentlyOnView = false
                    }
            })
        }
    }

}


// MARK: - Private functions
private extension EFLBannerView {
    
    func setupNotificationBanner() {
        
        self.backgroundColor = UIColor.eflBlackColor().colorWithAlphaComponent(0.7)
        self.frame = CGRectMake((APP_DELEGATE.window?.rootViewController!.view.frame.origin.x)!, (APP_DELEGATE.window?.rootViewController!.view.frame.origin.y)!, (APP_DELEGATE.window?.rootViewController!.view.frame.size.width)!, 0)
        currentlyOnView = false
        bannerLabel = UILabel(frame:CGRectZero)
    }
    
    func heightForView(text:String, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        label.font = FONT_REGULAR_13
        label.sizeToFit()
        return label.frame.height
    }
}




