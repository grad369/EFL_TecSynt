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
    private weak var spinnerSuperView: UIView!
    
    class var sharedSpinner : EFLActivityIndicator {
        struct Static {
            static var instance : EFLActivityIndicator?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
//            Static.instance = EFLActivityIndicator()
        }
        return Static.instance!
    }

    init()
    {
        super.init(frame: APP_DELEGATE.window!.frame)
//        self.setSpinner()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
//        self.setSpinner()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
//        self.setSpinner()
    }
    
    deinit {
        
    }
    // = CGSizeMake(30, 30)
    init(supView: UIView, size: CGSize, centerPoint: CGPoint = CGPointZero) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.spinnerSuperView = supView
        self.spinnerImageView = UIImageView(frame: CGRectMake(centerPoint.x - size.width/2, centerPoint.y - size.height/2, size.width, size.height))
        let image: UIImage = UIImage(named: SpinnerWhiteIcon)!
        self.spinnerImageView.image = image
        self.addSubview(spinnerImageView)
        
        self.backgroundColor = UIColor.eflBlackColor()
        self.alpha = 0.5
        
        if !CGPointEqualToPoint(centerPoint, CGPointZero){
            self.spinnerImageView.center = centerPoint
        }
    }
    
    func showIndicator() {
        self.spinnerSuperView.addSubview(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.startAnimation()
        }
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
        self.spinnerImageView.layer.addAnimation(rotationAnimation, forKey:"rotation")
    }
    
    func stopAnimation() {
        self.spinnerImageView.layer.removeAllAnimations();
    }
    


}
