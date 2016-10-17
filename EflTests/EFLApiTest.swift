//
//  EFLApiTest.swift
//  Efl
//
//  Created by TS on 13.09.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import XCTest
@testable import Efl
@testable import FBSDKLoginKit
@testable import FBSDKCoreKit
@testable import FBSDKShareKit

let FacebookToken = "EACQS8z7e3YgBAFNS9NtQUOZCDq10HOzFfRDvW3NTd7nRHuZBgEIFVEJ6wTTBYzoXXn3ZAJ24BPqgE7IIJwNeuDG9loXSlbB7hZBQoLcgp9xUJp1XN8va2oUUzY8KaPBzoZALAmpjZCB7yviTA4S2lZCDyY5uN2WbV0w0fvCdX1jr9ZAaESkUfRypRLFzWMcUDEhcoLKzWfCfenO4zQxoZCk7A0KWYAZC4ZB89wZD"

class EFLApiTest: XCTestCase {
    
    var currentServerTime: String?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func tes1tLoginFacebook() {
        let expectation: XCTestExpectation = self.expectationWithDescription("setFacebookPermissionsWith")
        let expectation1: XCTestExpectation = self.expectationWithDescription("getFacebookDataWith")
        let expectation2: XCTestExpectation = self.expectationWithDescription("loginPlayer")
        
        EFLFacebookManager.sharedFacebookManager.setFacebookPermissionsWith { (loginResult, error) in
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                EFLFacebookManager.sharedFacebookManager.getFacebookDataWith({ (connection, result, error) in
                    expectation1.fulfill()
                    XCTAssertNil(error)
                    let t = (loginResult.token.tokenString, facebookId: (result.valueForKey("id") as? String)!)
                    
                    let requestModel = self.loginRequestModel(t.0, facebookId: t.1)
                    EFLPlayerAPI().loginPlayer(requestModel)  { (error, data) -> Void in
                        expectation2.fulfill()
                        
                        if data == nil {return}
                        let response = (data as! EFLPlayerResponse)
                        if response.status == ResponseStatusSuccess {
                            EFLManager.sharedManager.player_id = (response.data?.player_id)!
                            EFLManager.sharedManager.refreshPlayerData(response.data!)
                        }
                    }
                })
            }
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    func tes1tCompetitionApi() {
       let expectation: XCTestExpectation = self.expectationWithDescription("getCompetitionList")
       let expectation1: XCTestExpectation = self.expectationWithDescription("getCompetition")
        
        let request = EFLCompetitionRequestModel()
        request.last_updated_on = EFLUtility.readValueFromUserDefaults(COMPETITION_LIST_LAST_UPDATED_TIME_STAMP_KEY)
        
        EFLCompetitionAPI().getCompetitionList(request) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "getCompetitionList: error must be nil")
            XCTAssertNotNil(data, "getCompetitionList: data must be don't nil")
            
            let response = (data as! EFLCompetitionListResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "getCompetitionList: response must be success")
            XCTAssertTrue(response.data.competitions.count > 0, "getCompetitionList: competitions must greater then 0")
            
            let competitionId = response.data.competitions.last!
            
            let requestModel = EFLCompetitionRequestModel()
            requestModel.last_updated_on = EFLCompetitionDataManager.sharedDataManager.getCompetitionLastUpdatedTimeStamp(String(competitionId))
            
            EFLCompetitionAPI().getCompetition(String(competitionId), request: requestModel) { (error, data) in
                expectation1.fulfill()
                XCTAssertNil(error, "getCompetition: error must be nil")
                XCTAssertNotNil(data, "getCompetition: data must be don't nil")
                let response = (data as! EFLCompetitionListResponse)
                XCTAssertTrue(response.status == ResponseStatusSuccess, "getCompetition: response must be success")
            }
        }

        self.waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    
    //EFLPlayerAPI
    func testPlayerApiLogin() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testPlayerApiLogin")
        let model = EFLPlayerLoginRequestModel()
        model.facebook_token = FacebookToken
        model.facebook_id = "1157880720940416"
        
        EFLPlayerAPI().loginPlayer(model) { (error, data) in
            expectation.fulfill()
            let response = (data as! EFLPlayerResponse)
            self.currentServerTime = response.data!.current_server_time 
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testPlayerApiLogin--: response must be success")
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    func testPlayerApiUpdate() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testPlayerApiUpdate")
        
        let model = EFLPlayerUpdateRequestModel()
        model.first_name = "Ops11"
//        model.last_name = "Kov"
//        model.image = NSData()
//        model.facebook_token = FacebookToken
//        model.notification_received_invite = false
//        model.notification_received_response = true
//        model.notification_picks_reminder = true
//        model.notification_received_result = true
        
        EFLPlayerAPI().updatePlayer(model) { (error, data) in
            expectation.fulfill()
            let response = (data as! EFLPlayerResponse)
            print(error)
            print(response.data?.last_name)
            self.currentServerTime = response.data?.current_server_time!
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testPlayerApiUpdate--: response must be success")
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    func testPlayerApiRefresh() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testPlayerApiRefresh")
        
        let model = EFLPlayerRefreshRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLPlayerAPI().refreshPlayer(model) { (error, data) in
            expectation.fulfill()
            let response = (data as! EFLPlayerResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testPlayerApiRefresh--: response must be success")
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    // EFLCompetitionAPI
    func testEFLCompetitionAPIGetCompetitionList() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testEFLCompetitionAPIGetCompetitionList")
        
        let model = EFLCompetitionRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLCompetitionAPI().getCompetitionList(model) { (error, data) in
            expectation.fulfill()
            let response = (data as! EFLCompetitionListResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testEFLCompetitionAPIGetCompetitionList--: response must be success")
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    func testEFLCompetitionAPIGetCompetition() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testEFLCompetitionAPIGetCompetition")
        
        let model = EFLCompetitionRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLCompetitionAPI().getCompetition("0", request: model) { (error, data) in
            expectation.fulfill()
            let response = (data as! EFLCompetitionResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testEFLCompetitionAPIGetCompetition--: response must be success")
        }
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    
    // EFLDeviceAPI
    func testDeviceApiCreateOrUpdateDevice() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testDeviceApi")
        
        EFLDeviceAPI().createOrUpdateDevice(EFLUtility.getDeviceModel(), and: { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testDeviceApi--: error must be nil \(error.code)")
            print(error.message)
            XCTAssertNotNil(data, "testDeviceApi--: data must be don't nil")
            
            let response = (data as! EFLDeviceResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testDeviceApi--: response must be success")
        })
        
        self.waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    
    // EFLPoolRoomAPI
    func testPoolRoomAPIGetPoolRoomList() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testPoolRoomAPIGetPoolRoomList")
        
        let model = EFLPoolRoomRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLPoolRoomAPI().getPoolRoomList(model) { (error, data) in
            
            expectation.fulfill()
            XCTAssertNil(error, "testPoolRoomAPIGetPoolRoomList--: error must be nil")
            XCTAssertNotNil(data, "testPoolRoomAPIGetPoolRoomList--: data must be don't nil")
            
            let response = (data as! EFLPoolRoomListResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testPoolRoomAPIGetPoolRoomList--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    func testPoolRoomAPIGetPoolRoom() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testPoolRoomAPIGetPoolRoom")
        
        let model = EFLPoolRoomRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLPoolRoomAPI().getPoolRoom("0",  request: model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testPoolRoomAPIGetPoolRoom--: error must be nil")
            XCTAssertNotNil(data, "testPoolRoomAPIGetPoolRoom--: data must be don't nil")
            
            let response = (data as! EFLPoolRoomResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testPoolRoomAPIGetPoolRoom--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    
    // EFLCreatePoolAPI
    func testCreatePoolAPICreatePool() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testCreatePoolAPICreatePool")
        
        let playerModel = EFLAddPlayerModel()
        playerModel.player_id = 5
        playerModel.invite_status = "Cool"
        
        let model = EFLCreatePoolRequestModel()
        model.pool_name = "PoolName"
        model.competition_id = 0
        model.message = "Common message"
        model.pool_image = "PoolImage"
        model.players = [playerModel]
        
        EFLCreatePoolAPI().createPoolWith(model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testCreatePoolAPICreatePool--: error must be nil")
            XCTAssertNotNil(data, "testCreatePoolAPICreatePool--: data must be don't nil")
            
            let response = (data as! EFLCreatePoolResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testCreatePoolAPICreatePool--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }

    func testCreatePoolAPIUpdatePool() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testCreatePoolAPIUpdatePool")
        
        let playerModel = EFLAddPlayerModel()
        playerModel.player_id = 0
        playerModel.invite_status = "Cool1"
        
        let model = EFLUpdatePoolRequestModel()
        model.pool_name = "PoolName1"
        model.message = "Common message1"
        model.pool_image = "PoolImage1"
        model.players = [playerModel]
        
        EFLCreatePoolAPI().updatePoolWith("5", request: model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testCreatePoolAPIUpdatePool--: error must be nil")
            XCTAssertNotNil(data, "testCreatePoolAPIUpdatePool--: data must be don't nil")
            
            let response = (data as! EFLCreatePoolResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testCreatePoolAPIUpdatePool--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    // EFLReceivePoolAPI
    func testReceivePoolAPIGetReceivePool() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testReceivePoolAPIGetReceivePool")
        
        let model = EFLReceivePoolRequestModel()
        model.player_id = "0"
        model.is_accepted = "0"
        
        EFLReceivePoolAPI().getReceivePoolWith(model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testReceivePoolAPIGetReceivePool--: error must be nil")
            XCTAssertNotNil(data, "testReceivePoolAPIGetReceivePool--: data must be don't nil")
            
            let response = (data as! EFLReceivePoolResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testReceivePoolAPIGetReceivePool--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    
    // EFLFriendsAPI
    func testFriendsAPIGetFriends() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testFriendsAPIGetFriends")
        
        let model = EFLFriendsGetRequestModel()
        model.last_updated_on = "2016-09-20 14:46:33"//self.currentServerTime!
        
        EFLFriendsAPI().getFriends(model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testFriendsAPIGetFriends--: error must be nil")
            XCTAssertNotNil(data, "testFriendsAPIGetFriends--: data must be don't nil")
            
            let response = (data as! EFLFriendsResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testFriendsAPIGetFriends--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    
    func testFriendsAPIUpdateFriends() {
        let expectation: XCTestExpectation = self.expectationWithDescription("testFriendsAPIUpdateFriends")
        
        let model = EFLFriendsUpdateRequestModel()
        model.facebook_ids = ["1157880720940416"]
        
        EFLFriendsAPI().updateFriends(model) { (error, data) in
            expectation.fulfill()
            XCTAssertNil(error, "testFriendsAPIUpdateFriends--: error must be nil")
            XCTAssertNotNil(data, "testFriendsAPIUpdateFriends--: data must be don't nil")
            
            let response = (data as! EFLFriendsResponse)
            XCTAssertTrue(response.status == ResponseStatusSuccess, "testFriendsAPIUpdateFriends--: response must be success")
        }
        
        self.waitForExpectationsWithTimeout(8, handler: nil)
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // Private
    func loginRequestModel(accessToken: String, facebookId: String) -> EFLPlayerLoginRequestModel {
        let requestModel = EFLPlayerLoginRequestModel()
        requestModel.facebook_token = accessToken
        requestModel.facebook_id = facebookId
        return requestModel
    }
}
