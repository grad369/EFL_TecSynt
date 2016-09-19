//
//  EFLLogoutResponse.swift
//  Efl
//
//  Created by Athul Raj on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

class EFLLogoutResponse: EFLBaseAPIResponse {
    
    var data: String?
    
    override func mapping(map: Map) {
        super.mapping(map)
        data    <- map["data"]
    }
}