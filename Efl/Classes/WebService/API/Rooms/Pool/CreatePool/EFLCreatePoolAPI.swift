//
//  EFLCreatePoolAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLcreatePoolAPIType{
    case Create
    case Update
}


class EFLCreatePoolAPI: EFLBaseAPI {
    var apiCall = EFLcreatePoolAPIType.Create
    var poolRoomID : String?

    func createPoolWith(request: EFLCreatePoolRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLcreatePoolAPIType.Create
        performRequest(request, completion: completion)
    }
    
    func updatePoolWith(poolroomId: String?, request: EFLUpdatePoolRequestModel?, and completion:RequestCompletion) {
        poolRoomID = poolroomId
        apiCall = EFLcreatePoolAPIType.Update
        performRequest(request, completion: completion)
    }

    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        switch apiCall {
        case .Update:
            return URLPoolRoom + poolRoomID! + "/"
        case .Create:
            return URLPoolRoom
        }
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        
        let response  = Mapper<EFLCreatePoolResponse>().map(response!)
        return response
    }
    
    override func requestMethod() -> Alamofire.Method {
        switch apiCall {
        case .Update:
            return .PATCH
        case .Create:
            return .POST
        }
    }
    
    override func requestParameterEncoding() -> Alamofire.ParameterEncoding {
        switch apiCall {
        case .Update:
            return .JSON
        case .Create:
            return .JSON
        }
    }
}
