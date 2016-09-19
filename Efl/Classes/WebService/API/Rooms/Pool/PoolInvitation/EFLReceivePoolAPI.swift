//
//  EFLReceivePoolAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 27/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

class EFLReceivePoolAPI: EFLBaseAPI {

    func getReceivePoolWith(request: EFLReceivePoolRequestModel?, and completion:RequestCompletion) {
        
        performRequest(request, completion: completion)
    }
    
    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        return URLPoolRoom
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        
        let response  = Mapper<EFLREceivePoolResponse>().map(response!)
        return response
    }
    
    override func requestMethod() -> Alamofire.Method {
        return .PUT
    }
    
    override func requestParameterEncoding() -> Alamofire.ParameterEncoding {
        return .URLEncodedInURL
    }

}
