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
    
    var videoPlayer: MPMoviePlayerController!
    var spinner: EFLActivityIndicator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(self.view)

        
//        self.spinner?.showIndicator()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.playVideo()
    }

    //MARK: Play BackGround Video
    func playVideo() -> Void {
        
        let path = NSBundle.mainBundle().pathForResource("Login_BG_Video", ofType:"mp4")
        let url = NSURL.fileURLWithPath(path!)
        if self.videoPlayer == nil {
            self.videoPlayer = MPMoviePlayerController(contentURL: url)
                self.videoPlayer.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.videoPlayer.view.sizeToFit()
                self.videoPlayer.scalingMode = MPMovieScalingMode.Fill
                self.videoPlayer.fullscreen = true
                self.videoPlayer.controlStyle = MPMovieControlStyle.None
                self.videoPlayer.movieSourceType = MPMovieSourceType.File
                self.videoPlayer.repeatMode = MPMovieRepeatMode.One
                self.view.addSubview(self.videoPlayer.view)
                self.view.sendSubviewToBack(self.videoPlayer.view)
        }
        self.videoPlayer.play()
    }
    
    // MARK: IBActions
    
    //MARK : Login With Facebook
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
                        self.spinner = EFLActivityIndicator(supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
                        self.spinner!.showIndicator()
                        
                        EFLFacebookManager.sharedFacebookManager.getFacebookDataWith({ (connection, result, error) in
                            
                            if error == nil {
                                self.loginToApp(loginResult.token.tokenString, facebookId: (result.valueForKey("id") as? String)!)
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
    
    //MARK: Terms And Privacy
    @IBAction func termsAndPrivacyAction(sender: AnyObject) {
        let termsPolicyVC = self.storyboard?.instantiateViewControllerWithIdentifier(TERMS_POLICY_VC_ID) as! EFLTermsPolicyViewController
        self.navigationController?.pushViewController(termsPolicyVC, animated: true)
    }
    
    // MARK: Login Method
    
    func loginToApp(accessToken: String, facebookId: String) {
        
        let requestModel = self.loginRequestModel(accessToken, facebookId: facebookId)
        EFLPlayerAPI().loginPlayer(requestModel)  { (error, data) -> Void in
//            EFLActivityIndicator.sharedSpinner.hideIndicator()
            
//            let spinner = EFLActivityIndicator(supView: self.view, size: CGSizeMake(45, 45), centerPoint: self.view.center)
//            spinner.hideIndicator()
            
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
                    EFLManager.sharedManager.player_id = (response.data?.player_id)!
                    EFLManager.sharedManager.refreshPlayerData(response.data!)

                    self.syncDatas()
                    
                    let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier(TAB_BAR_CONTROLLER_ID) as! EFLBaseTabBarController
                    tabBarController.selectedIndex = 1
                    self.navigationController?.pushViewController(tabBarController, animated: true)

                }
                else {
                    self.handleResponseFailure(response)
                }
            }
        }
    }
    
    
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
    
    
    // MARK: Login Request
    func loginRequestModel(accessToken: String, facebookId: String) -> EFLPlayerLoginRequestModel {
        let requestModel = EFLPlayerLoginRequestModel()
        requestModel.facebook_token = accessToken
        requestModel.facebook_id = facebookId
        return requestModel
    }
    
    // MARK: Hanlde login response
    func handleResponseFailure(response: EFLPlayerResponse) {
        print(response.message)
    }
    
    // MARK: Login Failure Alert
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
