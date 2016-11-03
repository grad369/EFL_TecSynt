//
//  EFLBaseAPIResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseAPIResponse: BaseAPIResponse {

    var status : String?
    var message : String?
    var code: String?

    var error : String?
    var error_description: String?

    override func mapping(map: Map) {
        error <- map["error"]
        error_description <- map["error_description"]
        status <- map["status"]
        message <- map["message"]
        code <- map["code"]
    }
    
    override func getAPIError(statusCode: NSInteger?) -> BaseAPIError {
        
        if (error_description != nil){
            let error_object = BaseAPIError.initWithHttpErrorMessage(statusCode!, message: error_description!)
            error_object.code = statusCode
            return error_object
        }else{
            let error: BaseAPIError
            error = BaseAPIError.getErrorObjectForHttpStatus(statusCode!)
            error.message = BaseAPIError.getMessageForErrorType(error)
            error.code = statusCode
            return error
        }
    }
    
    static func getAPIError(statusCode: NSInteger?) -> BaseAPIError {
        
        
            let error: BaseAPIError
            error = BaseAPIError.getErrorObjectForHttpStatus(statusCode!)
            error.message = BaseAPIError.getMessageForErrorType(error)
            error.code = statusCode
            return error
        
    }
}
