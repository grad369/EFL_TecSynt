//
//  BaseAPIResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class BaseAPIResponse: BaseMapableModel {

    func getAPIError(statusCode: NSInteger?) -> BaseAPIError {
//        assert(false, "You must override the BaseAPIResponse method")
        fatalError("You must override the BaseAPIResponse method")
    }

}
