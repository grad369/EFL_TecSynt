//
//  EFLCompetitionAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import Alamofire

enum EFLCompetitionAPIType {
    case List
    case Details
    case Default
}

class EFLCompetitionAPI: EFLBaseAPI {
    var apiCall = EFLCompetitionAPIType.Default
    var competitionId: String?
    
    func getCompetitionList(request: EFLCompetitionRequestModel?, and completion:RequestCompletion) {
        apiCall = EFLCompetitionAPIType.List
        performRequest(request, completion: completion)
    }
    
    func getCompetition(competitionIdParam: String, request: EFLCompetitionRequestModel?, and completion:RequestCompletion) {
        competitionId = competitionIdParam
        apiCall = EFLCompetitionAPIType.Details
        performRequest(request, completion: completion)
    }

    override func baseUrl() -> String {
        return URLBase
    }
    
    override func requestUrl() -> String {
        switch apiCall {
        case .List:
            return URLCompetitions
        case .Details:
            return URLCompetitions + competitionId!
        default:
            return URLCompetitions
        }
    }
    
    override func requestMethod() -> Alamofire.Method {
        return .GET
    }
    
    override func processSuccessResponse(with response: AnyObject?) -> EFLBaseAPIResponse?{
        switch apiCall {
        case .List:
            let response  = Mapper<EFLCompetitionListResponse>().map(response!)
            return response
        case .Details:
            let response  = Mapper<EFLCompetitionResponse>().map(response!)
            return response
        default:
            return nil
        }
    }
}
