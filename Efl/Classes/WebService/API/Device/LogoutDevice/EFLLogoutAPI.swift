//
//  EFLLogoutAPI.swift
//  Efl
//
//  Created by Athul Raj on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import Alamofire

class EFLLogoutAPI: EFLBaseAPI {
    
    func logout(completion:RequestCompletion) {
        performRequest(BaseMappableObject(), completion: completion)
    }
    
    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        return EFLAPIManager.sharedAPIManager.deviceUpdateURLPrefix
        //    /api/v1.0/players/{id}/devices/{id}
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        
        let response  = Mapper<EFLLogoutResponse>().map(response!)
        return response
    }
    
    override func requestMethod() -> Alamofire.Method {
        return .DELETE
    }

}