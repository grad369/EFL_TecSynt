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

@UIApplicationMain
class AppDelegate: UIResponder {
    
    var window: UIWindow?
    var rootNavigationController: EFLBaseNavigationController?
}



extension AppDelegate: UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        self.window!.rootViewController = addRootNavigationController()
        
        if EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY) != nil {
            EFLManager.sharedManager.player_id = Int(EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY)!)!
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        EFLUtility.checkAndRefreshData()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}


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
            EFLManager.sharedManager.player_id = Int(EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY)!)!
        }
        
        return rootNavigationController!;
    }
    
    func test() {
        //EFLAPIManager.sharedAPIManager.createOrUpdateDeviceDetails()
//        EFLAPIManager.sharedAPIManager.refreshPlayer(){
//            (status: String) in
//            
//        }
//        EFLAPIManager.sharedAPIManager.getFriends(){
//            (status: String) in
//            
//        }
        EFLAPIManager.sharedAPIManager.friendList(){
            (status: String) in
        }
//        EFLAPIManager.sharedAPIManager.getCompetitionList()
//        EFLAPIManager.sharedAPIManager.getCompetition()
//        EFLAPIManager.sharedAPIManager.getPoolRoomList()
//        EFLAPIManager.sharedAPIManager.getPoolRoom()
        
    }
}

