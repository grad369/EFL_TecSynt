//
//  EFLBaseAPI.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLBaseAPI: BaseAPI {

    override func requestHeaders() -> Dictionary<String, String>? {
        if let auth = EFLUtility.readValueFromUserDefaults(AUTHORIZATION_TOKEN_KEY) {
            return [RequestAuthorizationHeaderKey: auth];
        }
        return nil
    }
}
