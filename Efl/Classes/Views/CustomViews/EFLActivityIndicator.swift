//
//  EFLActivityIndicator.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLActivityIndicator: UIView {

    private var spinnerImageView : UIImageView!
    
    class var sharedSpinner : EFLActivityIndicator {
        struct Static {
            static var instance : EFLActivityIndicator?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = EFLActivityIndicator()
        }
        return Static.instance!
    }

    init()
    {
        super.init(frame: APP_DELEGATE.window!.frame)
        self.setSpinner()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.setSpinner()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setSpinner()
    }
    
    func setSpinner() {
        
        self.backgroundColor = UIColor.eflBlackColor()
        self.alpha = 0.5
        spinnerImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
        spinnerImageView.center = self.center
        let image: UIImage = UIImage(named: SpinnerWhiteIcon)!
        spinnerImageView?.image = image
        self.addSubview(spinnerImageView)
    }
    
    func showIndicator() {
        APP_DELEGATE.window?.addSubview(self)
        self.startAnimation()
    }
    
    func hideIndicator() {
        self.stopAnimation()
        self.removeFromSuperview()
    }
    
    func startAnimation() {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2*M_PI
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = Float.infinity
        
        self.spinnerImageView.layer.addAnimation(rotationAnimation, forKey: nil)
    }
    
    func stopAnimation() {
        self.spinnerImageView.layer.removeAllAnimations();
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
