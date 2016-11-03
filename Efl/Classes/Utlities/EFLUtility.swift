//
//  EFLUtility.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

public class EFLUtility: NSObject {
    
    // MARK : UserDefaults methods
    // MARK : Set values to user defaults
    static func saveValuesToUserDefaults(value: String, key: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    // MARK : Set Bool to user defaults
    static func saveBoolenToUserDefaults(value: Bool, key: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(value, forKey: key)
        userDefaults.synchronize()
    }

    // MARK : Read values from user defaults
    static func readValueFromUserDefaults(key: String) -> String? {
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(key)
        {
            return value as? String
        }
        return nil
    }
    
    // MARK : Read Bool from user defaults
    static func readBooleanFromUserDefaults(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }

    // MARK : Remove values from user defaults
    static func removeValueFromUserDefaults(key :String)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(key)
        userDefaults.synchronize()
    }
    
    // MARK: Check empty string
    static func isEmptyString(text : String?) -> Bool {
        if text == nil { return true }
        if text!.isEmpty { return true }
        return false
    }
    
    // MARK : Save user image
    static func saveUserImage(image: UIImage) {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("UserImage.JPEG")!.path!
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            removeUserImage()
        }

        let imageData       = UIImageJPEGRepresentation(image, 0.6)
        let result = imageData!.writeToFile(filePath, atomically: true)
        if result {
            print("Saved Image")
        }
    }
    
    
    // MARK : remove user image
    static func removeUserImage() {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("UserImage.JPEG")!.path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            do {
                try fileManager.removeItemAtPath(filePath)
            } catch {
            }
        }
    }

    // MARK : get user image
    static func getUserImage() -> UIImage? {
        
        let fileManager = NSFileManager.defaultManager()
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("UserImage.JPEG")!.path!
        
        if fileManager.fileExistsAtPath(filePath) {
            return UIImage(contentsOfFile: filePath)
        } else {
            return nil
        }
    }
    
    // MARK: Create Device Request
    static func getDeviceModel() -> EFLDeviceRequestModel {
        let requestModel = EFLDeviceRequestModel()
        requestModel.device_token = EFLManager.sharedManager.device_token
        requestModel.device_type = DeviceType
        requestModel.device_language = DeviceLanguagueCode
        requestModel.device_utc_offset = LocalTimeZoneAbbreviation
        print(requestModel.device_type)
        print(requestModel.device_token)
        print(requestModel.device_language)
        print(requestModel.device_utc_offset)
        return requestModel
    }
    
    // MARK : AlertController methods
    // MARK : Alert with ok button
    static func showOKAlertWithMessage(message :String, andTitle title:String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.eflGreenColor()
        let ok : UIAlertAction = UIAlertAction(title: "ALERT_OK_BUTTON_TITLE".localized, style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        self.showAlert(alert)
    }
    
    static func showAlert(alert: UIViewController){
        let presentingViewController = APP_DELEGATE.rootNavigationController?.viewControllers.last
        if presentingViewController?.presentedViewController != nil{
            presentingViewController?.presentedViewController?.presentViewController(alert, animated: true, completion: {
                alert.view.tintColor = UIColor.eflGreenColor()
            })
        }else{
            presentingViewController?.presentViewController(alert, animated: true, completion: {
                alert.view.tintColor = UIColor.eflGreenColor()
            })
        }
    }

    // MARK: Scale Down Image
    static func scaleDownImage(image: UIImage, ToSize newSize: CGSize) -> UIImage {
        
        var desiredSize = newSize
        if image.size.width < newSize.width && image.size.height < newSize.height {
            return image
        }
        
        if image.size.width > newSize.width || image.size.height > newSize.height {
            let factorValue = self.getFactorValue(image.size, desiredSize: newSize)
            desiredSize = CGSizeMake(image.size.width / factorValue, image.size.height / factorValue)
        }
        
        UIGraphicsBeginImageContextWithOptions(desiredSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, desiredSize.width, desiredSize.height))
        let newImgae = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImgae!
    }
    
    static func getFactorValue(imageSize: CGSize, desiredSize: CGSize) -> CGFloat {
        var biggest: CGFloat!
        if imageSize.width >= imageSize.height {
            biggest = imageSize.width
        }
        else {
            biggest = imageSize.height
        }
        let dividorValue = biggest / desiredSize.width
        return dividorValue
    }
    
    // MARK: Remove Alamofire Image Cache
    static func clearImageFromCache(imageURL: String) {
        let URL = NSURL(string: imageURL)!
        let URLRequest = NSURLRequest(URL: URL)
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        
        // Clear the URLRequest from the in-memory cache
        imageDownloader.imageCache?.removeImageForRequest(URLRequest, withAdditionalIdentifier: nil)
        
        // Clear the URLRequest from the on-disk cache
        imageDownloader.sessionManager.session.configuration.URLCache?.removeCachedResponseForRequest(URLRequest)
    }
    
    
    static func checkAndRefreshData() {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            if let timeStampOneHour = (EFLUtility.readValueFromUserDefaults(FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)) {
                let timeStamp = (timeStampOneHour as NSString).doubleValue
                if (CurrentTimestamp - timeStamp) > hourConstant { //if last updated time stamp > 1 hour
                    
                    self.getCompetitionList()
                    
                    if EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY) != nil { //Check if user is logged in
                        
                        if !EFLManager.sharedManager.isPlayerSynchronisedStarted {
                            EFLManager.sharedManager.isPlayerSynchronisedStarted = true
                            EFLAPIManager.sharedAPIManager.refreshPlayer { (status) in
                                EFLManager.sharedManager.isPlayerSynchronisedStarted = false
                                if status == CompletionStatusSuccess {
                                    EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)
                                }
                            }
                        }
                        
                        
                        if !EFLManager.sharedManager.isFriendsSynchronisedStarted {
                            EFLManager.sharedManager.isFriendsSynchronisedStarted = true
                            EFLAPIManager.sharedAPIManager.getFriends { (status) in
                                EFLManager.sharedManager.isFriendsSynchronisedStarted = false
                                if status == CompletionStatusSuccess {
                                    EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.getCompetitionList()
            }
            
            if let timeStampOneMinute = (EFLUtility.readValueFromUserDefaults(FRONT_END_1_MINUTE_LAST_UPDATED_TIME_STAMP_KEY)) {
                let timeStamp = (timeStampOneMinute as NSString).doubleValue
                if EFLUtility.readValueFromUserDefaults(FB_ACCESS_TOKEN_KEY) != nil { //Check if user is logged in
                    if (CurrentTimestamp - timeStamp) > minuteConstnt {
                        
                        if !EFLManager.sharedManager.isRoomsSynchronisedStarted {
                            EFLManager.sharedManager.isRoomsSynchronisedStarted = true
                            EFLAPIManager.sharedAPIManager.getPoolRoomList { (status) in
                                EFLManager.sharedManager.isRoomsSynchronisedStarted = false
                                if status == CompletionStatusSuccess {
                                    EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_MINUTE_LAST_UPDATED_TIME_STAMP_KEY)
                                }
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    // MARK: Get competition list
    static func getCompetitionList() {
        
        if !EFLManager.sharedManager.isCompetitionSynchronisationStarted {
            EFLManager.sharedManager.isCompetitionSynchronisationStarted = true
            EFLAPIManager.sharedAPIManager.getCompetitionList { (status) in
                EFLUtility.saveValuesToUserDefaults(CurrentTimestamp.description, key: FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)
                EFLManager.sharedManager.isCompetitionSynchronisationStarted = false
                print("getCompetitionList \(status)")
            }
        }
    }
    
}
