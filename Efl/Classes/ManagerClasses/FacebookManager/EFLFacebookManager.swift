//
//  EFLFacebookManager.swift
//  Efl
//
//  Created by vishnu vijayan on 08/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class EFLFacebookManager: NSObject {
    
    static let sharedFacebookManager = EFLFacebookManager()
    typealias PermissionCompletion = (loginResult :FBSDKLoginManagerLoginResult!, error :NSError!) -> Void
    typealias FacebookDataCompletion = (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void
    
    var _fbLoginManager: FBSDKLoginManager?
    
    var fbLoginManager: FBSDKLoginManager {
        get {
            if _fbLoginManager == nil {
                _fbLoginManager = FBSDKLoginManager()
            }
            return _fbLoginManager!
        }
    }
    
    func setFacebookPermissionsWith(completion: PermissionCompletion) {
        let viewController = (UIApplication.sharedApplication().delegate as! AppDelegate).rootNavigationController?.viewControllers.last
        EFLFacebookManager.sharedFacebookManager.fbLoginManager.logInWithReadPermissions(["email","user_friends","public_profile"], fromViewController: viewController) { (loginResult :FBSDKLoginManagerLoginResult!, error :NSError!) in
            completion (loginResult: loginResult, error: error)
        }
    }
    
    func getFacebookDataWith(completion: FacebookDataCompletion) {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, locale, picture, timezone"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: FBSDK_TARGET_PLATFORM_VERSION, HTTPMethod: "GET")
        
        graphRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            completion(connection : connection, result: result, error: error)
        }
    }
}
