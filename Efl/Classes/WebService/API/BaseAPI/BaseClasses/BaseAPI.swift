//
//  BaseAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

class BaseAPI: NSObject {
    
    typealias RequestCompletion = (error: BaseAPIError, data: AnyObject?) -> Void
    
    /**
     * Override this method in the subclass.
     * - returns : baseUrl string
     */
    func baseUrl() -> String {
//        assert(false, "This method must be overridden by the subclass")
        fatalError("This method must be overridden by the subclass")
    }
    
    /**
     * Override this method in the subclass.
     * - returns : requestUrl string
     */
    func requestUrl() -> String {
//        assert(false, "This method must be overridden by the subclass")
        fatalError("This method must be overridden by the subclass")
    }
    
    /**
     * Override this method in the subclass.
     * - returns : timeout interval
     */
    func requestTimeOutIntervals() -> Int {
        
        return REQUEST_TIMEOUT_IN_SECONDS
    }
    
    /**
     * Override this method to return request headers as key/value pairs
     * - returns : requestHeader dictionary
     */
    func requestHeaders() -> Dictionary<String, String>? {
        
//        assert(false, "This method must be overridden by the subclass")
        fatalError("This method must be overridden by the subclass")
    }
    
    /**
     * Implement this method to configure the request method type:
     * OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
     * - returns: Alamofire Method
     */
    func requestMethod() -> Alamofire.Method {
//        assert(false, "The BaseApi method 'requestMethod()' must be overriden by a subclass")
        fatalError("The BaseApi method 'requestMethod()' must be overriden by a subclass")
    }
    
    /**
     * Override this method in the subclass if needed.
     * - returns : parameter Encoding
     */
    func requestParameterEncoding() -> Alamofire.ParameterEncoding {
        return .URL
    }
    /**
     * Return false to prevent the baseUrl from being prepended to the requestUrl
     * - returns: boolean
     */
    func shouldPrependBaseUrl() -> Bool {
        return true
    }
    
    /**
     * Return true to for multipart upload
     * - returns: boolean
     */
    func multiPartUpload() -> Bool {
        return false
    }
    
    /**
     * Return true to for download with progress
     * - returns: boolean
     */
    func downloadWithProgress() -> Bool {
        return false
    }
    
    /**
     * Build request url
     * - returns: request url
     */
    func buildUrl() -> String {
        var completeUrl = "";
        if(shouldPrependBaseUrl()) {
            completeUrl = baseUrl()
        }
        completeUrl = completeUrl + requestUrl()
        return completeUrl
    }
    
    /**
     * Override this method to configure the process the response object.
     * -returns: AnyObject
     */
    func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
//        assert(false, "This method must be overriden by the subclass")
        fatalError("This method must be overriden by the subclass")
    }
    
    func performRequest(object: BaseMappableObject?, completion: RequestCompletion){
        
        let params :[String:AnyObject]
        if multiPartUpload() {
            params = object!.toMultiPartDictionary()
        }else{
            params = object!.toDictionary()
        }
        
        let urlString = buildUrl()
        
        if SHOULD_LOG {
            print("URL: ", urlString);
            
//            print("Params: ", params);
        }
        if multiPartUpload(){
            performUploadRequest(with: urlString, params: params, and: completion)
        }else {
            processRequest(with: urlString, params: params, and: completion)
            
        }
    }
    
    /**
     * Process http request
     */
    func processRequest(with urlString: String,  params: [String: AnyObject]?, and completion: RequestCompletion){
        if ReachabilityManager.isReachable(){
            request(requestMethod(), urlString, parameters: params!, encoding: requestParameterEncoding(), headers: requestHeaders()).responseJSON{ response in
                
                let status_code = response.response?.statusCode
                if SHOULD_LOG {
                print("response = ",response)
                }
                
                if response.result.isSuccess{
                    let responseObject = self.processSuccessResponse(with: response.result.value)
                    let error = responseObject!.getAPIError(status_code)
                    
                    completion(error: error, data: responseObject)
                    
                }else{
                    
                    self.processFailureResponse(response, and: completion)
                }
            }
        } else {
            let error: BaseAPIError = APIErrorTypeNetwork()
            error.message = KNoNetworkMessage
            completion(error: error, data: EFLBaseAPIResponse.self)
        }
    }
    
    func performUploadRequest(with urlString: String, params: [String: AnyObject]?, and completion: RequestCompletion){
        
        if ReachabilityManager.isReachable(){
            upload(
                requestMethod(), urlString, headers: requestHeaders(), multipartFormData: { (multipartFormData) -> Void in
                    for (key, value) in params! {
                        
                        if value.isKindOfClass(NSData){
                            let fileName = EFLUtility.readValueFromUserDefaults(FIRST_NAME_KEY)! + EFLUtility.readValueFromUserDefaults(LAST_NAME_KEY)! + CurrentTimestamp.description
                            multipartFormData.appendBodyPart(data: value as! NSData, name: key, fileName: fileName, mimeType: "image/png")
                        }else{
                            if value.isKindOfClass(NSNumber)
                            {
                                var score: Int = value.integerValue
                                let numberData = NSData(bytes: &score, length: sizeof(Int))
                                multipartFormData.appendBodyPart(data: numberData, name: key)
                            }
                            else
                            {
                                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                            }
                        }
                    }
                }, encodingMemoryThreshold: 40000, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) -> Void in
                            // MARK: Request Success Block
                            // Create the response object
                            let status_code = response.response?.statusCode
                            if response.result.isSuccess {
                                if SHOULD_LOG {
                                    print("response     : ",response)
                                }
                                let responseObject = self.processSuccessResponse(with: response.result.value)
                                let error = responseObject!.getAPIError(status_code)
                                
                                completion(error: error, data: responseObject)
                            }
                            if response.result.isFailure {
                                self.processFailureResponse(response, and: completion)
                            }
                        })
                    case .Failure(let encodingError):
                        if SHOULD_LOG {
                            print("Error\(encodingError)")
                        }
                        //TO DO
                        let error: BaseAPIError = APIErrorTypeServer()
                        error.message = KNoNetworkMessage
                        completion(error: error, data: EFLBaseAPIResponse.self)
                    }
                }
            )
            
        } else {
            let error: BaseAPIError = APIErrorTypeNetwork()
            error.message = KNoNetworkMessage
            completion(error: error, data: EFLBaseAPIResponse.self)
        }
    }
    
    
    /**
     * Process failure response
     */
    func processFailureResponse(response: Response<AnyObject, NSError>, and completion: RequestCompletion) {
        
        if SHOULD_LOG {
            print("Response error code: ",response.result.error?.code)
            print("Response error info: ",response.result.error?.userInfo[ErrorLocalizedDescription])
        }
        
        if (response.response?.statusCode) != nil {
            
            let statusCode = (response.response?.statusCode)!
            
            // Create APIError object based on http status code
            let error : BaseAPIError  = BaseAPIError.initWithHttpStatusCode(statusCode)
            error.code = statusCode
            // Fetch Error from errorData
            let errorData  = response.result.error?.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
            var responseObject : EFLBaseAPIResponse?
                        
            if((errorData) != nil) {
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData((errorData as! NSData), options:NSJSONReadingOptions(rawValue: 0))
                    guard let responseDictionary :NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        
                        return
                    }
                    print("JSONDictionary! \(responseDictionary)")
                    
                    responseObject = self.processSuccessResponse(with: responseDictionary)
                    let errorObject = responseObject!.getAPIError(statusCode)
                    completion(error: errorObject, data: nil)
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                    completion(error: BaseAPIError.initWith(JSONError), data: nil)
                }
            }
            completion(error: error, data: nil)
            
        }else{
            // MARK: Request Failure Error with no response
            completion(error: BaseAPIError.initWith(response.result.error), data: nil)
        }
    }
    
}
