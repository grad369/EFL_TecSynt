//
//  EFLAPIManager.swift
//  Efl
//
//  Created by vishnu vijayan on 12/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class EFLAPIManager: NSObject {
    static let sharedAPIManager = EFLAPIManager()
    typealias APICompletion = (status: String) -> Void
    
    // MARK: URL Siffix
    
    //Player URL + Player ID
    var playerURLSuffix: String {
        return URLPlayer + (EFLUtility.readValueFromUserDefaults(EFL_PLAYER_ID_KEY))!
    }
    
    //Device URL + Device ID
    var deviceURLSuffix: String {
        if ((EFLUtility.readValueFromUserDefaults(DEVICE_ID_KEY)) != nil){
            return URLDevices + (EFLUtility.readValueFromUserDefaults(DEVICE_ID_KEY))!
        }
        return ""
    }
    
    //Player URL + Player ID + /friends/
    var friendsURLSuffix: String {
        return playerURLSuffix + URLFriends
    }
    
    //Player URL + Player ID + /devices/ + Device ID
    var deviceUpdateURLPrefix: String{
        return playerURLSuffix + deviceURLSuffix
    }
    
    //Handle API failure cases with HTTP status codes
    func handleAPIFailure(statusCode: Int) {
        print(statusCode)
    }
    
    
    //Device ID update API on log in
    
    // MARK: Create/Update Device API
    func createOrUpdateDeviceDetails(){
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            EFLDeviceAPI().createOrUpdateDevice(EFLUtility.getDeviceModel(), and: { (error, data) in
                if !error.isKindOfClass(APIErrorTypeNone){
                    print(error.code)
                    print("DEVICE REGISTRATION FAILED")
                    return
                }else{
                    if data == nil {return}//TODO: Check this.
                    let response = (data as! EFLDeviceResponse)
                    if response.status == ResponseStatusSuccess {
                        if response.data == nil {return}//TODO: Check this.
                        EFLManager.sharedManager.updateDeviceId(response.data!)
                    }
                }
            })
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    
    // MARK: Player API methods
    
    //Refresh player details in background
    func refreshPlayer(completion: APICompletion) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            let requestModel = EFLPlayerRefreshRequestModel()
            requestModel.modified_since = EFLUtility.readValueFromUserDefaults(PLAYER_LAST_UPDATED_TIME_STAMP_KEY)!
            EFLPlayerAPI().refreshPlayer(requestModel)  { (error, data) -> Void in
                
                if !error.isKindOfClass(APIErrorTypeNone){
                    print(error.code)
                    completion(status: CompletionStatusFailed)
                }
                else
                {
                    if data == nil {return}//TODO: Check this.
                    let response = (data as! EFLPlayerResponse)
                    if response.status == ResponseStatusSuccess {
                        if response.data == nil {return}//TODO: Check this.
                        print(response.data!)
                        EFLManager.sharedManager.refreshPlayerData(response.data!.player!)
                        if response.data!.player!.first_name != nil || response.data!.player!.last_name != nil || response.data!.player!.image != nil {
                            NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_DATA_NOTIFICATION, object: nil)
                            EFLManager.sharedManager.isPlayerRefreshed = true
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: CompletionStatusSuccess)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: CompletionStatusFailed)
                        })
                        
                    }
                }
            }
            
        })
    }
    
    // MARK: Friends API methods
    
    // Get/Update friends in background
    func getFriends(completion: APICompletion) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            EFLCoreDataManager.sharedInstance.writerManagedObjectContext.performBlock({
                self.friendList({ (status) in
                    completion(status: status)
                })
            })
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    // Get Friend List
    func friendList(completion: APICompletion) {
        let requestModel = EFLFriendsGetRequestModel()
        requestModel.modified_since = EFLUtility.readValueFromUserDefaults(FRIENDS_LAST_UPDATED_TIME_STAMP_KEY)
        
        EFLFriendsAPI().getFriends(requestModel) { (error, data) -> Void in
            
            if !error.isKindOfClass(APIErrorTypeNone) {
                print(error.code)
                completion(status: CompletionStatusFailed)
            }
            else {
                if data == nil {return}
                let response = (data as! EFLFriendsResponse)
                if response.status == ResponseStatusSuccess {
                    if response.data == nil {return}//TODO: Check this.
                    EFLPlayerDataManager.sharedDataManager.syncFriends(response.data!)
                    EFLUtility.saveValuesToUserDefaults((response.data?.current_server_time)!, key: FRIENDS_LAST_UPDATED_TIME_STAMP_KEY)
                    completion(status: CompletionStatusSuccess)
                }
                else {
                    //print(response.message)
                    completion(status: CompletionStatusFailed)
                }
            }
        }
    }
    
    // MARK: Competition API methods
    
    //Get competition list (List of all competition ids)
    func getCompetitionList(completion: APICompletion) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            let requestModel = EFLCompetitionRequestModel()
            requestModel.modified_since = EFLUtility.readValueFromUserDefaults(COMPETITION_LIST_LAST_UPDATED_TIME_STAMP_KEY)
            
            EFLCompetitionAPI().getCompetitionList(requestModel) { (error, data) in
                if !error.isKindOfClass(APIErrorTypeNone) {
                    print(error.code)
                    completion(status: CompletionStatusFailed)
                }
                else {
                    let response = (data as! EFLCompetitionListResponse)
                    if response.status == ResponseStatusSuccess {
                        EFLUtility.saveValuesToUserDefaults(response.data.current_server_time, key: COMPETITION_LIST_LAST_UPDATED_TIME_STAMP_KEY)
                        if response.data.competitions.count > 0 {
                            
                            EFLCoreDataManager.sharedInstance.writerManagedObjectContext.performBlock({
                                EFLAPIManager.sharedAPIManager.getCompetition(response.data.competitions) { (status) in
                                    print("competitions fetch completed \(status)")
                                    EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
                                        print("competitions saved \(success)")

                                    }
                                    completion(status: CompletionStatusSuccess)
                                }})
                        }
                        else {
                            completion(status: CompletionStatusSuccess)
                        }
                    }
                    else {
                        //print(response.message)
                        completion(status: CompletionStatusFailed)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    //Get competition  (details of a competition)
    func getCompetition(competitions: [Int], completion: APICompletion) {
        var count = competitions.count
        
        for competitionId in competitions {
            let requestModel = EFLCompetitionRequestModel()
            requestModel.modified_since = EFLCompetitionDataManager.sharedDataManager.getCompetitionLastUpdatedTimeStamp(String(competitionId))
            
            EFLCompetitionAPI().getCompetition(String(competitionId), request: requestModel) { (error, data) in
                count = count - 1
                if !error.isKindOfClass(APIErrorTypeNone) {
                    print("competition \(competitionId) get failed \(error.code)")
                    if count == 0 {
                        completion(status: CompletionStatusSuccess)
                    }
                }
                else {

                    if data == nil {return}
                    let response = (data as! EFLCompetitionResponse)
                    if response.status == ResponseStatusSuccess {
                        print("competition \(competitionId) get success")
                        EFLCompetitionDataManager.sharedDataManager.syncCompetitionToCache(response.data)
                    }
                    else {
                        //print("competition get failed : \(response.message)")
                    }
                    
                    if count == 0 {
                        completion(status: CompletionStatusSuccess)
                    }
                }
            }
        }
    }
    
    // MARK: Pool Room API methods
    //Get pool room list (List of all competition ids)
    func getPoolRoomList(completion: APICompletion) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            let requestModel = EFLPoolRoomRequestModel()
            requestModel.last_updated_on = EFLUtility.readValueFromUserDefaults(POOL_ROOM_LIST_LAST_UPDATED_TIME_STAMP_KEY)
            
            EFLPoolRoomAPI().getPoolRoomList(requestModel) { (error, data) in
                if !error.isKindOfClass(APIErrorTypeNone) {
                    print(error.code)
                    completion(status: CompletionStatusFailed)
                }
                else {
                    if data == nil {return}
                    let response = (data as! EFLPoolRoomListResponse)
                    if response.status == ResponseStatusSuccess {
                        EFLUtility.saveValuesToUserDefaults(response.data.current_server_time, key: POOL_ROOM_LIST_LAST_UPDATED_TIME_STAMP_KEY)
                        if response.data.poolrooms.count > 0 {
                            EFLManager.sharedManager.isRoomsRefreshed = true
                            
                            EFLCoreDataManager.sharedInstance.writerManagedObjectContext.performBlock({
                                
                                EFLAPIManager.sharedAPIManager.getPoolRoom(response.data.poolrooms) { (status) in
                                    print("pool rooms fetch completed \(status)")

                                    EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
                                        print("pool rooms saved \(success)")

                                        NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_DATA_NOTIFICATION, object: nil)
                                        completion(status: CompletionStatusSuccess)

                                    }
                                }})
                        }
                        completion(status: CompletionStatusLoading)
                    }
                    else {
                        //print(response.message)
                        completion(status: CompletionStatusFailed)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
    }
    
    //Get pool room  (details of pool room)
    func getPoolRoom(poolRooms: [Int], completion: APICompletion) {
        
        var count = poolRooms.count
        for poolRoomId in poolRooms {
            let requestModel = EFLPoolRoomRequestModel()
            requestModel.last_updated_on = EFLCompetitionDataManager.sharedDataManager.getCompetitionLastUpdatedTimeStamp(String(poolRoomId))
            
            EFLPoolRoomAPI().getPoolRoom(String(poolRoomId), request: requestModel) { (error, data) in
                count = count - 1
                if !error.isKindOfClass(APIErrorTypeNone) {
                    print("pool room \(poolRoomId) get failed \(error.code)")
                    if count == 0 {
                        completion(status: CompletionStatusSuccess)
                    }
                }
                else {
                    if data == nil {return}
                    let response = (data as! EFLPoolRoomResponse)
                    if response.status == ResponseStatusSuccess {
                        EFLPoolRoomDataManager.sharedDataManager.syncPoolRoomToCache(response.data.poolroom)
                        print("pool room \(poolRoomId) get success")
                    }
                    else {
                        //print("pool room get failed : \(response.message)")

                    }
                    if count == 0 {
                        completion(status: CompletionStatusSuccess)
                    }
                }
            }
        }
    }
    
}


