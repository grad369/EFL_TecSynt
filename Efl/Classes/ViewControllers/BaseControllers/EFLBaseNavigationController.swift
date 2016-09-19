//
//  EFLBaseNavigationController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let logoImage: [UIImage] = [
            UIImage(named: "SpinnerWhiteIcon.png")!,
            UIImage(named: "SpinnerGreyIcon")!
        ]
        let animatedImageView: UIImageView = UIImageView(frame: CGRectMake(30 , 30,30, 30))
        animatedImageView.animationImages = logoImage
        animatedImageView.animationDuration = 1.0
        animatedImageView.animationRepeatCount = 0
        animatedImageView.startAnimating()
        self.view.addSubview(animatedImageView)
 */
        //self.navigationItem.titleView?.addSubview(animatedImageView)
        // Do any additional setup after loading the view.
        self.setShadow()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation Bar Seperation Hide
    
    func removeNavigationBarSperarationView(){
        self.tabBarController?.tabBar.hidden = true
        
        self.navigationBar.clipsToBounds = true
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.eflGreenColor()
        }
    }
   
    // MARK: - Shadow Settings
    
    func setShadow() {
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = UIColor.eflGreenColor()
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: FONT_MEDIUM_19!, NSForegroundColorAttributeName: UIColor.eflWhiteColor()]
        
        self.navigationBar.layer.shadowColor = UIColor.eflBlackColor().CGColor
        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.navigationBar.layer.shadowRadius = 2.0;
        self.navigationBar.layer.shadowOpacity = 0.5;
        
        for parent in self.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        self.navigationBar.clipsToBounds = false
    }
    
    func removeShadow() {
        self.navigationBar.layer.shadowColor = UIColor.eflBlackColor().CGColor
        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.navigationBar.layer.shadowRadius = 0.3;
        self.navigationBar.layer.shadowOpacity = 0.5;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
