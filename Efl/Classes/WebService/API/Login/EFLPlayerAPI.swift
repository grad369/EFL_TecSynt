//
//  EFLPlayerAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 31/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLPlayerAPIType {
    case Login
    case Refresh
    case Update
    case Default
}

class EFLPlayerAPI: EFLBaseAPI {
    var apiCall = EFLPlayerAPIType.Default
    
    func loginPlayer(request: EFLPlayerLoginRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLPlayerAPIType.Login
        performRequest(request, completion: completion)
    }
    
    func updatePlayer(request: EFLPlayerUpdateRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLPlayerAPIType.Update
        performRequest(request, completion: completion)
    }
    
    func refreshPlayer(request: EFLPlayerRefreshRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLPlayerAPIType.Refresh
        performRequest(request, completion: completion)
    }
    
    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        
        switch apiCall {
        case .Login:
            return URLPlayer
        case .Update:
            return EFLAPIManager.sharedAPIManager.playerURLSuffix
        case .Refresh:
            return EFLAPIManager.sharedAPIManager.playerURLSuffix
        default:
            return URLPlayer
        }
        
    }
    
    override func requestMethod() -> Alamofire.Method {
        
        switch apiCall {
        case .Login:
            return .POST
        case .Update:
            return .PATCH
        case .Refresh:
            return .GET
        default:
            return .GET
        }
    }

    override func multiPartUpload() -> Bool {
        
        switch apiCall {
        case .Login:
            return false
        case .Update:
            return true
        case .Refresh:
            return false
        default:
            return false
        }
    }

    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        let response  = Mapper<EFLPlayerResponse>().map(response!)
        return response
    }
}
