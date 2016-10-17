//
//  EFLConstants.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

enum EFLTransitionAnimationType {
    case None
    case Default
    case FlipHorizontal
}

enum EFLBarButtonType {
    case None
    case Ok
    case Plus
    case Send
    case AddFriends
    case Back
    case Close
    case Cancel
    case Share
}

enum EFLBarButtonPlaceType {
    case Left
    case Right
}

enum EFLColorType {
    case Black
    case White
    case Green
}


public let EmptyString = ""
public let DeviceType = "ios"

public let CompletionStatusSuccess = "Success"
public let CompletionStatusLoading = "Loading"
public let CompletionStatusFailed = "Failed"

public let ResponseStatusSuccess    = "success"
public let ResponseStatusError      = "error"

// UserDefault Keys

    //Player Keys
public let AUTHORIZATION_TOKEN_KEY                  = "AuthorizationToken"
public let FB_ACCESS_TOKEN_KEY                      = "FaceBookAccessToken"
public let FACEBOOK_ID_KEY                          = "FaceBookID"
public let EFL_PLAYER_ID_KEY                        = "PlayerID"
public let FIRST_NAME_KEY                           = "FirstName"
public let LAST_NAME_KEY                            = "LastName"
public let PROFILE_IMAGE_URL_KEY                    = "ProfileImageURL"

    //Notification Keys
public let NOTIFICATION_RECEIVED_INVITE_KEY         = "NotificationReceivedInvite"
public let NOTIFICATION_RECEIVED_RESPONSE_KEY       = "NotificationReceivedResponse"
public let NOTIFICATION_PICKS_REMINDER_KEY          = "NotificationPicksReminder"
public let NOTIFICATION_RECEIVED_RESULT_KEY         = "notificationReceivedResult"

    //Device Keys
public let DEVICE_TOKEN_KEY                         = "DeviceToken"
public let DEVICE_ID_KEY                            = "DeviceId"
public let DEVICE_TYPE_KEY                          = "DeviceType"
public let DEVICE_LANGUAGE_KEY                      = "DeviceLanguage"
public let DEVICE_UTC_OFFSET_KEY                    = "DeviceUTCOffset"

    //Time Stamp Keys
public let FRONT_END_1_MINUTE_LAST_UPDATED_TIME_STAMP_KEY   = "FrontEndOneMinuteUpdatedTimeStamp"
public let FRONT_END_1_HOUR_LAST_UPDATED_TIME_STAMP_KEY     = "FrontEndOneHourUpdatedTimeStamp"

public let PLAYER_LAST_UPDATED_TIME_STAMP_KEY               = "PlayerLastUpdatedTimeStamp" // Player last updated time stamp from server
public let FRIENDS_LAST_UPDATED_TIME_STAMP_KEY              = "FriendsLastUpdatedTimeStamp" // Friends last updated time stamp from server
public let COMPETITION_LIST_LAST_UPDATED_TIME_STAMP_KEY     = "CompetitionListLastUpdatedTimeStamp" // Competition list last updated time stamp from server
public let POOL_ROOM_LIST_LAST_UPDATED_TIME_STAMP_KEY       = "PoolRoomListLastUpdatedTimeStamp" // Pool room list last updated time stamp from server

// Local database keys

    //Friends
public let FriendsIdKey                 = "playerId"
public let FriendsFirstNameKey          = "firstName"
public let FriendsLastNameKey           = "lastName"
public let FriendsImageUrlKey           = "imageURL"
public let FriendsImageKey              = "image"
public let FriendsIsSignedUpKey         = "isSignedUp"

// Storyboard IDs

public let ROOT_NAVIGATION_ID                       = "RootNavigationControllerID"
public let LOGIN_VC_ID                              = "EFLLoginViewControllerID"
public let TERMS_POLICY_VC_ID                       = "EFLTermsPolicyViewControllerID"
public let TAB_BAR_CONTROLLER_ID                    = "EFLBaseTabBarControllerID"
public let PROFILE_VIEW_CONTROLLER_ID               = "EFLProfileViewControllerID"
public let FRIENDS_SHARE_VIEW_CONTROLLER_ID         = "EFLFriendsShareViewControllerID"
public let SELECT_COMPETITION_VIEW_CONTROLLER_ID    = "EFLSelectCompetitionViewControllerID"
public let CREATE_POOL_VIEW_CONTROLLER_ID           = "EFLCreatePoolViewControllerID"
public let ADD_PLAYER_VIEW_CONTROLLER_ID            = "EFLAddPlayerViewControllerID"
public let POOL_ACTION_VIEW_CONTROLLER_ID           = "EFLPoolActionViewControllerID"
public let POOL_DETAILS_VIEW_CONTROLLER_ID          = "EFLPoolDetailsViewControllerID"


// Notification Names
public let REFRESH_DATA_NOTIFICATION = "RefreshPlayerData" // Used to refresh UI after player and friends refresh calls

// Image Names

// Spinner Images
public let SpinnerWhiteIcon         = "SpinnerWhiteIcon"
public let SpinnerWhiteSmallIcon    = "SpinnerWhiteSmallIcon"

// TabBarItem Image Names
public let TabBarSettingsItemIcon           = "TabBarSettingsIcon"
public let TabBarRoomsItemIcon              = "TabBarRoomsIcon"
public let TabBarFriendsItemIcon            = "TabBarFriendsIcon"
public let TabBarSettingsInActiveItemIcon   = "TabBarSettingsInactiveIcon"
public let TabBarRoomsInActiveItemIcon      = "TabBarRoomsInactiveIcon"
public let TabBarFriendsInActiveItemIcon    = "TabBarFriendsInactiveIcon"

// Avatar Image Names
public let Avatar70x70          = "Avatar70x70Icon"
public let Avatar50x50          = "Avatar50x50Icon"
public let Avatar40x40          = "Avatar40x40Icon"
public let AvatarPool40x40      = "AvatarPool40x40Icon"
public let AvatarPool50x50      = "AvatarPool50x50Icon"

//Integer Constants

//Refresh constants
public let hourConstant: NSTimeInterval = 3600
public let minuteConstnt: NSTimeInterval = 60

//Banner animation duration
public let BannerCrossDissolveTime: Int64 = 2

//Room/Player Image scale size
public let imageScaleSize: CGSize = CGSizeMake(240, 240)
