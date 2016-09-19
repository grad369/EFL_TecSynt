//
//  EFLBaseViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialiseView()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initialise View
    func initialiseView() {
    }

    // MARK: - Navigation
    
    func addNavigationBackButton() {
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"NavigationBackButtonWhiteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EFLBaseViewController.backButtonAction))
        backButtonItem.tintColor = UIColor.eflWhiteColor()
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 0
        self.navigationItem.setLeftBarButtonItems([negativeSpace,backButtonItem], animated: true)
    }
    
    func addNavigationCancelButton() {
        
        let cancelButton = UIButton.init(type: UIButtonType.System)
        cancelButton.frame = CGRectMake(0, 0, 60, 44)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.setTitle("ALERT_CANCEL_BUTTON_TITLE".localized, forState: UIControlState.Normal)
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0)
        
        cancelButton.setTitleColor(UIColor.eflWhiteColor(), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = FONT_REGULAR_19
        cancelButton.addTarget(self, action: #selector(backButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.Left
        let backButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: cancelButton)
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpace.width = 0
        self.navigationItem.setLeftBarButtonItems([negativeSpace,backButtonItem], animated: true)
    }

    func hideBackButton() {
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.hidesBackButton = true
    }
    
    func backButtonAction(){
        self.navigationController?.popViewControllerAnimated(true)
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
