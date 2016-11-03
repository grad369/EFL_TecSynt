//
//  AppDelegate.swift
//  Efl
//
//  Created by Vishnu Vijayan on 21/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import CoreData
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootNavigationController: EFLBaseNavigationController?
}


// MARK: - UIApplicationDelegate
extension AppDelegate  {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        self.window!.rootViewController = addRootNavigationController()
        
        if EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY) != nil {
            EFLUtility.checkAndRefreshData()
            EFLManager.sharedManager.player_id = Int(EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY)!)!
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}


// MARK: - Private Functions
private extension AppDelegate {
    
    func addRootNavigationController() -> EFLBaseNavigationController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootNavigationController = storyboard.instantiateViewControllerWithIdentifier(ROOT_NAVIGATION_ID) as? EFLBaseNavigationController
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier(LOGIN_VC_ID) as! EFLLoginViewController
        
        if EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY) == nil
        {
            rootNavigationController!.viewControllers = [loginViewController]
        }
        else
        {
            let tabBarController = storyboard.instantiateViewControllerWithIdentifier(TAB_BAR_CONTROLLER_ID) as! EFLBaseTabBarController
            tabBarController.selectedIndex = 1
            rootNavigationController!.viewControllers = [tabBarController]
            tabBarController.navigationController?.navigationBar.hidden = true
            EFLManager.sharedManager.player_id = Int(EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY)!)!
        }
        
        return rootNavigationController!;
    }
}

