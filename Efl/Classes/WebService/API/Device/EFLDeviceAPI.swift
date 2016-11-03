//
//  EFLDeviceAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLDeviceAPIType{
    case Create
    case Update
}

class EFLDeviceAPI: EFLBaseAPI {
    var apiMethod = EFLDeviceAPIType.Update
    
//    func updateDeviceWith(request: EFLDeviceRequestModel?, and completion:RequestCompletion) {
//        apiMethod = EFLDeviceAPIType.Update
//        performRequest(request, completion: completion)
//    }
//    
//    func createDeviceWith(request: EFLDeviceRequestModel?, and completion:RequestCompletion) {
//        apiMethod = EFLDeviceAPIType.Create
//        performRequest(request, completion: completion)
//    }
    
    func createOrUpdateDevice(request: EFLDeviceRequestModel?, and completion:RequestCompletion) {
        
        if (EFLUtility.readValueFromUserDefaults(DEVICE_ID_KEY) != nil) {
            apiMethod = EFLDeviceAPIType.Update
        }
        else {
            apiMethod = EFLDeviceAPIType.Create
        }
        performRequest(request, completion: completion)
    }
    
    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        
        switch apiMethod {
        case .Create:
            print(EFLAPIManager.sharedAPIManager.playerURLSuffix + URLDevices)
            return EFLAPIManager.sharedAPIManager.playerURLSuffix + URLDevices
        default:
            return EFLAPIManager.sharedAPIManager.deviceUpdateURLPrefix
        }
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        
        let response  = Mapper<EFLDeviceResponse>().map(response!)
        return response
    }
    
    override func requestMethod() -> Alamofire.Method {
        switch apiMethod {
        case .Create:
            return .POST
        default:
            return .PATCH
        }
    }
    
//    override func multiPartUpload() -> Bool {
//        
//        switch apiMethod {
//        case .Create:
//            return false
//        default:
//            return true
//        }
//    }
    
    override func requestParameterEncoding() -> Alamofire.ParameterEncoding {
        return .URL
    }
    
}
