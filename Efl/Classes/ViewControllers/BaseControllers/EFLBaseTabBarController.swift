//
//  EFLBaseTabBarController.swift
//  Efl
//
//  Created by vishnu vijayan on 25/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setImage()
        self.setSelectedImage()
        self.setShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Set Shadow
    func setShadow() {
        
        self.tabBar.layer.borderColor = UIColor.clearColor().CGColor
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.clipsToBounds = true
        
        let borderLine:UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame), 0.5))
        borderLine.backgroundColor = UIColor.efllighterGreyColor()
        borderLine.alpha = 0.5
        self.tabBar.layer.addSublayer(borderLine.layer)
    }
    
    // MARK: Set TabBarITem Image
    func setImage() -> Void {
        
        let tabBarItem1 = self.tabBar.items![0] as UITabBarItem
        let tabBarItem2 = self.tabBar.items![1] as UITabBarItem
        let tabBarItem3 = self.tabBar.items![2] as UITabBarItem
        
        tabBarItem1.image = UIImage(named: TabBarSettingsInActiveItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.image = UIImage(named: TabBarRoomsInActiveItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem3.image = UIImage(named: TabBarFriendsInActiveItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
    }

    // MARK: Set TabBarITem Selected Image
    func setSelectedImage() -> Void {
        
        let tabBarItem1 = self.tabBar.items![0] as UITabBarItem
        let tabBarItem2 = self.tabBar.items![1] as UITabBarItem
        let tabBarItem3 = self.tabBar.items![2] as UITabBarItem

        tabBarItem1.selectedImage = UIImage(named: TabBarSettingsItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.selectedImage = UIImage(named: TabBarRoomsItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem3.selectedImage = UIImage(named: TabBarFriendsItemIcon)?.imageWithRenderingMode(.AlwaysOriginal)
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
