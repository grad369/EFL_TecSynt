import UIKit

class BaseAPIError: NSObject {
    
    var code: Int?
    var message : String?
    
    
    class func getErrorObjectForHttpStatus(status: NSInteger) -> BaseAPIError {
        switch status {
        case HTTP_STATUS_OK:                      return APIErrorTypeNone()             // 200
        case HTTP_STATUS_CREATED:                 return APIErrorTypeNone()             // 201
        case HTTP_STATUS_NO_CONTENT:              return APIErrorTypeResponse()         // 204
        case HTTP_STATUS_BAD_REQUEST:             return APIErrorTypeRequest()         // 400
        case HTTP_STATUS_NOT_FOUND:               return APIErrorTypeRequest()        // 404
        case HTTP_STATUS_UNAUTHORIZED:            return APIErrorTypeAuthentication()  // 401
        case HTTP_STATUS_INTERNAL_SERVER_ERROR:   return APIErrorTypeServer()          // 500
        case HTTP_STATUS_GATEWAY_TIMEOUT:         return APIErrorTypeTimeOut()
        case HTTP_STATUS_REQUEST_TIME_OUT:        return APIErrorTypeTimeOut()

        default:                                  return APIErrorTypeGeneric()       // All others
            
      
        }
    }
    
    class func initWithHttpStatusCode(httpStatusCode: Int) -> BaseAPIError {
        let apiError = getErrorObjectForHttpStatus(httpStatusCode)
        apiError.message = getMessageForErrorType(apiError)
        return apiError
    }
    
    class func initWithHttpErrorMessage(httpStatusCode: Int, message: String) -> BaseAPIError{
        let apiError = getErrorObjectForHttpStatus(httpStatusCode)
        apiError.message = message
        return apiError
    }
    
    class func initWith(error : NSError?) -> BaseAPIError{
        let responseError = BaseAPIError()
        responseError.code = error?.code
        responseError.message = error?.userInfo[ErrorLocalizedDescription] as? String
        return responseError

    }
    
    class func initErrorWith(errorObject: BaseAPIError,and error : NSError?) -> BaseAPIError{
        
        errorObject.code = error?.code
        errorObject.message = error?.userInfo[ErrorLocalizedDescription] as? String
        return errorObject
    }
    
    class func getMessageForErrorType(apiError: BaseAPIError) -> String {

        
        if apiError.isKindOfClass(APIErrorTypeNone){
            return KSuccessMessage
        }else if apiError.isKindOfClass(APIErrorTypeTimeOut){
            return KNetworkTimeOutMessage
        }else if apiError.isKindOfClass(APIErrorTypeNetwork){
            return KNoNetworkMessage
        }else if apiError.isKindOfClass(APIErrorTypeAuthentication){
            return KNetworkAuthMessage
        }else if apiError.isKindOfClass(APIErrorTypeResponse){
            return KResponseFailureMessage
        }else if apiError.isKindOfClass(APIErrorTypeRequest){
            return KRequestFailureMessage
        }else if apiError.isKindOfClass(APIErrorTypeServer){
            return KServerNotReachableMessage
        }else if apiError.isKindOfClass(APIErrorTypeGeneric){
            return KUnknownErrorMessage
        }else{
            return KUnknownErrorMessage
        }

    }
}
