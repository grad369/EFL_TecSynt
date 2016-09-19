//
//  EFLPoolRoomAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLPoolRoomAPIType {
    case List
    case Details
    case Default
}

class EFLPoolRoomAPI: EFLBaseAPI {
    var apiCall = EFLPoolRoomAPIType.Default
    var poolroomId: String?

    func getPoolRoomList(request: EFLPoolRoomRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLPoolRoomAPIType.List
        performRequest(request, completion: completion)
    }
    
    func getPoolRoom(poolroomIdParam: String,request: EFLPoolRoomRequestModel?, and completion:RequestCompletion) {
        poolroomId = poolroomIdParam
        apiCall = EFLPoolRoomAPIType.Details
        performRequest(request, completion: completion)
    }
    
    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        switch apiCall {
        case .List:
            return EFLAPIManager.sharedAPIManager.playerURLSuffix + "/" + URLPoolRoom
        case .Details:
            return URLPoolRoom + poolroomId!
        default:
            return URLPoolRoom
        }
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        switch apiCall {
        case .List:
            let response  = Mapper<EFLPoolRoomListResponse>().map(response!)
            return response
        case .Details:
            let response  = Mapper<EFLPoolRoomResponse>().map(response!)
            return response
        default:
            return nil
        }
    }
    
    override func requestMethod() -> Alamofire.Method {
        return .GET
    }
}
