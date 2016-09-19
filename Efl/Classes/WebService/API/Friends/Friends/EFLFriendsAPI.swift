//
//  EFLFriendsAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLFriendsAPIType {
    case Get
    case Update
    case Default
}

class EFLFriendsAPI: EFLBaseAPI {
    var apiCall = EFLFriendsAPIType.Default

    func getFriends(request: EFLFriendsGetRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLFriendsAPIType.Get
        performRequest(request, completion: completion)
    }

    func updateFriends(request: EFLFriendsUpdateRequestModel?, and completion:RequestCompletion) { //Invite friends from Facebook
        apiCall = EFLFriendsAPIType.Update
        performRequest(request, completion: completion)
    }

    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        return EFLAPIManager.sharedAPIManager.friendsURLSuffix
    }

    override func requestMethod() -> Alamofire.Method {

        switch apiCall {
        case .Get:
            return .GET
        case .Update:
            return .PATCH
        default:
            return .GET
        }
    }

    override func requestParameterEncoding() -> Alamofire.ParameterEncoding {
        switch apiCall {
        case .Get:
            return .URL
        case .Update:
            return .JSON
        default:
            return .URL
        }
    }

    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        let response  = Mapper<EFLFriendsResponse>().map(response!)
        return response
    }
}
