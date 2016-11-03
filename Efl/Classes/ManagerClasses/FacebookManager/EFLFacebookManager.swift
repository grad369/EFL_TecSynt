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
        
        graphRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            completion(connection : connection, result: result, error: error)
        }
    }
    
    func getFacebookFriendIds(completion: (facebookIds: [String]) -> Void) {
        
        func facebookIds(token: String) {
            let params = ["fields": "id, first_name, last_name, middle_name, name"]
            let version = FBSDK_TARGET_PLATFORM_VERSION
            let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                let r = result as! NSDictionary
                print(r)
                print(connection.URLResponse)
                completion(facebookIds: ["s"])
            }
        }
        
        let token = FBSDKAccessToken.currentAccessToken()
        
        if token != nil {
            facebookIds(token.tokenString)
        } else {
            self.refreshCurrentToken({
                facebookIds(token.tokenString)
            })
        }
    }
    
    func refreshCurrentToken(completion: () -> Void) {
        let hasGranted: Bool = FBSDKAccessToken.currentAccessToken().hasGranted(FBSDKAccessToken.currentAccessToken().permissions.first as! String)
        // TODO: use hasGranted, if hasGranted = false application must go to registration screen 
        
        FBSDKAccessToken.refreshCurrentAccessToken { (connection: FBSDKGraphRequestConnection!, obj: AnyObject!, error: NSError!) in
            completion()
        }
    }
}
