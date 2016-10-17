//
//  BaseAPIConstants.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

enum Status: Int {
    case StatusLoading, StatusCompleted, StatusFailed
}

// MARK: - HTTP Status codes
public let HTTP_STATUS_OK                      = 200
public let HTTP_STATUS_CREATED                 = 201
public let HTTP_STATUS_ACCEPTED                = 202
public let HTTP_STATUS_PARTIAL_RESPONSE        = 203
public let HTTP_STATUS_NO_CONTENT              = 204

public let HTTP_STATUS_MOVED                   = 301
public let HTTP_STATUS_FOUND                   = 302
public let HTTP_STATUS_METHOD                  = 303
public let HTTP_STATUS_NOT_MODIFIED            = 303

public let HTTP_STATUS_BAD_REQUEST             = 400
public let HTTP_STATUS_UNAUTHORIZED            = 401
public let HTTP_STATUS_PAYMENT_REQUIRED        = 402
public let HTTP_STATUS_FORBIDDEN               = 403
public let HTTP_STATUS_NOT_FOUND               = 404
public let HTTP_STATUS_REQUEST_TIME_OUT        = 408
public let HTTP_STATUS_CONFLICT                = 409

public let HTTP_STATUS_INTERNAL_SERVER_ERROR   = 500
public let HTTP_STATUS_NOT_IMPLEMENTED         = 501
public let HTTP_STATUS_SERVICE_OVERLOADED      = 502
public let HTTP_STATUS_GATEWAY_TIMEOUT         = 504

// MARK: - Server Status codes
public let SERVER_STATUS_SUCCESS                = "20" // Success
public let SERVER_STATUS_UNAUTHERIZED           = "41" // Unauthorized/Authentication Error
public let SERVER_STATUS_RESOURSE_GONE          = "44" // Resource gone
public let SERVER_STATUS_CONFLICT_IN_REQUEST    = "49" // Conflict in request - (eg: same email is used to subscribe again)
public let SERVER_STATUS_UNSUPPORTED_MEDIA_TYPE = "46" // Unsupported Media Type
public let SERVER_STATUS_INVALID_REQUEST_FORMAT = "30" // Invalid Request Format

// MARK: app utility constants
public let REQUEST_TIMEOUT_IN_SECONDS = 60
public let REQUEST_TIMEOUT_MULTIPART_IN_SECONDS = 180


// MARK: app boolean Keys
public let SHOULD_LOG = false
public let SHOULD_USE_TEST_RESPONSE = false

// MARK: app utility Keys
public let ErrorLocalizedDescription = "NSLocalizedDescription"

public let AFNetworkingOperationFailingURLResponseDataErrorKey = "com.alamofire.serialization.response.error.data"

// MARK: api response messages
public let KSuccessMessage              = "Success"
public let KNetworkTimeOutMessage       = "Your session is timed out"
public let KNoNetworkMessage            = "Please make sure you have internet connection and try again."
public let KNetworkAuthMessage          = "Authentication failure"
public let KRequestFailureMessage       = "Request failed"
public let KResponseFailureMessage      = "No response found"
public let KServerNotReachableMessage   = "Server not reachable. Please try again later"
public let KSystemErrorMessage          = "System error, please try again later"
public let KUnknownErrorMessage         = "System error, please try again later"

// MARK: Urls

//TODO: UnComment below line to active Staging Server
public let URLBase = "http://efl-server-staging-1.appspot.com/api/v1.0/"

//TODO: UnComment below line to active Production Server
//public let URLBase = ""

//Request Header Keys
public let RequestAuthorizationHeaderKey = "X-Authorization"

//URL Suffix
/*
    Same url end point for login/sign up and profile update.
    POST for login/sign up
    PATCH for profile update
 */
public let URLPlayer            = "players/"
public let URLFriends           = "/friends/"
public let URLDevices           = "/devices/"

public let URLTermsAndPolicy    = "http://znet.company/efl/terms.php"
public let URLCompetitions      = "competitions/"
public let URLPoolRoom          = "poolrooms/"
