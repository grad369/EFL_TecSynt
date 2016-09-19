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
//@testable import PMKVObserver


class EFLApiTest: XCTestCase {
    
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
        self.waitForExpectationsWithTimeout(20, handler: nil)
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
    
    func testDeviceApi() {
        let expectation: XCTestExpectation = self.expectationWithDescription("createOrUpdateDevice")
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            expectation.fulfill()
            
            EFLDeviceAPI().createOrUpdateDevice(EFLUtility.getDeviceModel(), and: { (error, data) in
                XCTAssertNil(error, "createOrUpdateDevice: error must be nil")
                XCTAssertNotNil(data, "createOrUpdateDevice: data must be don't nil")
                
                let response = (data as! EFLDeviceResponse)
                XCTAssertTrue(response.status == ResponseStatusSuccess, "createOrUpdateDevice: response must be success")
            })
        })
        self.waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testPlayerApi() {
        EFLPlayerAPI().loginPlaye
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