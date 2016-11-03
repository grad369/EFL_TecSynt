//
//  EFLLoginViewController.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import MediaPlayer
import FBSDKLoginKit

class EFLLoginViewController: EFLBaseViewController {
    @IBOutlet weak var termsAndPolicyLabel: UILabel!
    
    var spinner: EFLActivityIndicator? = nil
    
    lazy var videoPlayer: MPMoviePlayerController = {
        let path = NSBundle.mainBundle().pathForResource("Login_BG_Video", ofType:"mp4")
        let url = NSURL.fileURLWithPath(path!)
        let player = MPMoviePlayerController(contentURL: url)
        player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        player.view.sizeToFit()
        player.scalingMode = MPMovieScalingMode.Fill
        player.fullscreen = true
        player.controlStyle = MPMovieControlStyle.None
        player.movieSourceType = MPMovieSourceType.File
        player.repeatMode = MPMovieRepeatMode.One
        self.view.addSubview(player.view)
        self.view.sendSubviewToBack(player.view)
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(self.view)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.playVideo()
    }
}


// MARK: - Actions
extension EFLLoginViewController {

    // MARK: Play BackGround Video
    func playVideo() -> Void {
        self.videoPlayer.play()
    }
    
    // MARK : Login With Facebook
    @IBAction func loginWithFacebookAction(sender: AnyObject) {
        
        if ReachabilityManager.isReachable() {
            EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
                if (error != nil) {
                    EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                } else if loginResult.isCancelled {
                    print("User cancelled authentication")
                }
                else {
                    if (FBSDKAccessToken.currentAccessToken() != nil) {
                        self.spinner = EFLActivityIndicator(supView: self.view, size: CGSizeMake(45, 45))
                        self.spinner!.showIndicator()
                        
                        EFLFacebookManager.sharedFacebookManager.getFacebookDataWith({ (connection, result, error) in
                            
                            if error == nil {
                                self.loginToApp(loginResult.token.tokenString, facebookId: (result.valueForKey("id") as? String)!)
                                EFLUtility.saveValuesToUserDefaults(loginResult.token.tokenString, key: FB_ACCESS_TOKEN_KEY)
                            } else {
                                //  EFLActivityIndicator.sharedSpinner.hideIndicator()
                                self.spinner!.hideIndicator()
                                EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                            }
                        })
                    }
                    else {
                        EFLUtility.showOKAlertWithMessage(error.localizedDescription, andTitle: EmptyString)
                    }
                }
            }
        }
        else {
            EFLBannerView.sharedBanner.showBanner(self.view, message: "NO_CONNECTION".localized, yOffset: 0)
        }
    }
    
    // MARK: Terms And Privacy
    @IBAction func termsAndPrivacyAction(sender: AnyObject) {
        let termsPolicyVC = self.storyboard?.instantiateViewControllerWithIdentifier(WEB_VC_ID) as! EFLWebViewController
        self.navigationController?.pushViewController(termsPolicyVC, animated: true)
    }
}


// MARK: - Show alerts
private extension EFLLoginViewController {
    
    func showLoginFailureAlert(accessToken: String, facebookId: String) {
        let alert: UIAlertController = UIAlertController(title: "ALERT_FAILURE_TITLE".localized, message: "ALERT_FAILURE_MESSAGE".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
    
        let cancel: UIAlertAction = UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler: nil)
        
        let tryAgain: UIAlertAction = UIAlertAction(title: "TRY_AGAIN_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler:{
            (alert: UIAlertAction!) in
            self.loginToApp(accessToken, facebookId: facebookId)
        })
        
        alert.addAction(cancel)
        alert.addAction(tryAgain)
            
        self.presentViewController(alert, animated: true, completion: {
            alert.view.tintColor = UIColor.eflGreenColor()
        })
    }
}


// MARK: - Private function
private extension EFLLoginViewController {
    
    func syncDatas() {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            if !(EFLManager.sharedManager.device_token.isEmpty){
                EFLAPIManager.sharedAPIManager.createOrUpdateDeviceDetails()
            }
            
            EFLAPIManager.sharedAPIManager.getFriends({ (status) in
                print("getFriends \(status)")
                if status == CompletionStatusSuccess {
                    EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)
                }
            })
            
            EFLAPIManager.sharedAPIManager.getPoolRoomList { (status) in
                print("getPoolRoomList \(status)")
                if status == CompletionStatusSuccess {
                    EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_MINUTE_LAST_UPDATED_TIME_STAMP_KEY)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    func loginToApp(accessToken: String, facebookId: String) {
        let requestModel = self.loginRequestModel(accessToken, facebookId: facebookId)
        EFLPlayerAPI().loginPlayer(requestModel)  { (error, data) -> Void in
            
            self.spinner!.hideIndicator()
            if !error.isKindOfClass(APIErrorTypeNone){
                if error.code == HTTP_STATUS_REQUEST_TIME_OUT || error.code == HTTP_STATUS_CONFLICT {
                    self.showLoginFailureAlert(accessToken, facebookId: facebookId)
                }
                else {
                    EFLUtility.showOKAlertWithMessage("ALERT_FAILURE_TITLE".localized, andTitle: EmptyString)
                }
                return
            }
            else
            {
                if data == nil {return}
                let response = (data as! EFLPlayerResponse)
                if response.status == ResponseStatusSuccess {
                    EFLManager.sharedManager.player_id = (response.data?.player?.player_id)!
                    EFLManager.sharedManager.refreshPlayerData(response.data!.player!)
                    
                    self.syncDatas()
                    self.pushFromLoginScreenToTabBar()
                }
            }
        }
    }
    
    func loginRequestModel(accessToken: String, facebookId: String) -> EFLPlayerLoginRequestModel {
        let requestModel = EFLPlayerLoginRequestModel()
        requestModel.facebook_token = accessToken
        requestModel.facebook_id = facebookId
        return requestModel
    }
    
    func pushFromLoginScreenToTabBar() {
        UIApplication.sharedApplication().statusBarHidden = false
        
        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier(TAB_BAR_CONTROLLER_ID) as! EFLBaseTabBarController
        tabBarController.selectedIndex = 1
        self.navigationController?.pushViewController(tabBarController, animated: true)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            let viewControllers = NSMutableArray(array: (self.navigationController!.viewControllers))
            viewControllers.removeObject(0)
            self.navigationController!.viewControllers = viewControllers.copy() as! [UIViewController]
        }
    }
}
