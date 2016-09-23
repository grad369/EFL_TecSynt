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
        
        self.backgroundColor = UIColor.eflBlackColor()
        
        self.alpha = 0.5
        
        
        if !CGPointEqualToPoint(centerPoint, CGPointZero){
            self.spinnerImageView.center = centerPoint
        }
        let image: UIImage = UIImage(named: SpinnerWhiteIcon)!
        self.spinnerImageView.image = image
        self.addSubview(spinnerImageView)
        
        self.spinnerSuperView.addSubview(self)
        
    }
    
//    func setSpinner() {
//        
//        self.backgroundColor = UIColor.eflBlackColor()
//        self.alpha = 0.5
//        spinnerImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
//        spinnerImageView.center = self.center
//        let image: UIImage = UIImage(named: SpinnerWhiteIcon)!
//        spinnerImageView?.image = image
//        self.addSubview(spinnerImageView)
//    }
    
    func showIndicator() {
//        APP_DELEGATE.window?.addSubview(self)
        self.spinnerSuperView.addSubview(self)
        self.startAnimation()
    }
    
    func hideIndicator() {
        self.stopAnimation()
        self.removeFromSuperview()
    }
    
    func startAnimation() {
        
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotationAnimation.fromValue = 0.0
//        rotationAnimation.toValue = 2*M_PI
//        rotationAnimation.duration = 1.5
//        rotationAnimation.repeatCount = Float.infinity 
//        self.spinnerImageView.layer.addAnimation(rotationAnimation, forKey:"rotation")
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: { () -> Void in
            
            self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, CGFloat(M_PI_2))
            
        }) { (finished) -> Void in
                print("FINISHED!!!")
        }
    }
    
    func stopAnimation() {
        self.spinnerImageView.layer.removeAllAnimations();
    }
    


}
