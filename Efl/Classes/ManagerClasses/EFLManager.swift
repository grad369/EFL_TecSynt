//
//  EFLManager.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class EFLManager: NSObject {
    var isPlayerRefreshed = false
    var isFriendsRefreshed = false
    var isRoomsRefreshed = false
    
    var isPlayerSynchronisedStarted = false
    var isFriendsSynchronisedStarted = false
    var isRoomsSynchronisedStarted = false
    var isCompetitionSynchronisationStarted = false

    var player_id : Int = -1
    var device_token : String = "43e798c31a282d129a34d84472bbdd7632562ff0732b58a85a27c5d9fdf59b69" // TO DO: should be filled, while registering Push Notification from App Delegate

    var roomId = EmptyString
    var createPoolRequestModel = EFLCreatePoolRequestModel()

    static let sharedManager = EFLManager()
    
    //Save player data to cache
    func refreshPlayerData(player:EFLPlayerResponseModel) {

        if let playerId = player.player_id {
            EFLUtility.saveValuesToUserDefaults(String(playerId), key: EFL_PLAYER_ID_KEY)
        }
        if let facebookId = player.facebook_id {
            EFLUtility.saveValuesToUserDefaults(facebookId, key: FACEBOOK_ID_KEY)
        }
        if let authorizationToken = player.jwt_token {
            EFLUtility.saveValuesToUserDefaults(authorizationToken, key: AUTHORIZATION_TOKEN_KEY)
        }
        if let facebookToken = player.facebook_token {
            EFLUtility.saveValuesToUserDefaults(facebookToken, key: FB_ACCESS_TOKEN_KEY)
        }
        if let firstName = player.first_name {
            EFLUtility.saveValuesToUserDefaults(firstName, key: FIRST_NAME_KEY)
        }
        if let lastName = player.last_name {
            EFLUtility.saveValuesToUserDefaults(lastName, key: LAST_NAME_KEY)
        }
        if let imageURL = player.image {
            EFLUtility.saveValuesToUserDefaults(imageURL, key: PROFILE_IMAGE_URL_KEY)
            EFLUtility.removeUserImage()
        }
        if let lastUpdatedTimeStamp = player.last_updated_on {
            EFLUtility.saveValuesToUserDefaults(lastUpdatedTimeStamp, key: PLAYER_LAST_UPDATED_TIME_STAMP_KEY)
        }
        if let notificationReceivedInvite = player.notification_received_invite {
            EFLUtility.saveBoolenToUserDefaults(notificationReceivedInvite, key: NOTIFICATION_RECEIVED_INVITE_KEY)
        }
        if let notificationReceivedResponse = player.notification_received_response {
            EFLUtility.saveBoolenToUserDefaults(notificationReceivedResponse, key: NOTIFICATION_RECEIVED_RESPONSE_KEY)
        }
        if let notificationPicksReminder = player.notification_picks_reminder {
            EFLUtility.saveBoolenToUserDefaults(notificationPicksReminder, key: NOTIFICATION_PICKS_REMINDER_KEY)
        }
        if let notificationReceivedResult = player.notification_received_result {
            EFLUtility.saveBoolenToUserDefaults(notificationReceivedResult, key: NOTIFICATION_RECEIVED_RESULT_KEY)
        }
    }
    
    func updateDeviceId(deviceModel: EFLDeviceModel){
        if let deviceId = deviceModel.device_id {
            EFLUtility.saveValuesToUserDefaults(String (deviceId), key: DEVICE_ID_KEY)
        }
    }
    
    //MARK: Handle HTTP error cases
    func handleHTTPErrorCasesInView(view: UIView, bannerOffset: CGFloat) {
        EFLBannerView.sharedBanner.showBanner(view, message: "ALERT_FAILURE_TITLE".localized, yOffset: bannerOffset)
    }
    
    func logOut() {

        EFLUtility.removeValueFromUserDefaults(EFL_PLAYER_ID_KEY)
        EFLUtility.removeValueFromUserDefaults(AUTHORIZATION_TOKEN_KEY)
        EFLUtility.removeValueFromUserDefaults(FB_ACCESS_TOKEN_KEY)
        EFLUtility.removeValueFromUserDefaults(FIRST_NAME_KEY)
        EFLUtility.removeValueFromUserDefaults(LAST_NAME_KEY)
        EFLUtility.removeValueFromUserDefaults(PROFILE_IMAGE_URL_KEY)
        EFLUtility.removeValueFromUserDefaults(PLAYER_LAST_UPDATED_TIME_STAMP_KEY)
        EFLUtility.removeValueFromUserDefaults(FACEBOOK_ID_KEY)

        EFLUtility.removeValueFromUserDefaults(NOTIFICATION_RECEIVED_INVITE_KEY)
        EFLUtility.removeValueFromUserDefaults(NOTIFICATION_RECEIVED_RESPONSE_KEY)
        EFLUtility.removeValueFromUserDefaults(NOTIFICATION_PICKS_REMINDER_KEY)
        EFLUtility.removeValueFromUserDefaults(NOTIFICATION_RECEIVED_RESULT_KEY)
        
        EFLUtility.removeValueFromUserDefaults(PLAYER_LAST_UPDATED_TIME_STAMP_KEY)
        EFLUtility.removeValueFromUserDefaults(FRIENDS_LAST_UPDATED_TIME_STAMP_KEY)
        EFLUtility.removeValueFromUserDefaults(FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY)

        EFLFacebookManager.sharedFacebookManager.fbLoginManager.logOut()
//        EFLPlayerDataManager.sharedDataManager.truncateDataBase()
    }
    
    
}
