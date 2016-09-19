//
//  EFLDeviceResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLDeviceResponse: EFLBaseAPIResponse {
    
    var data: EFLDeviceModel?
    
    override func mapping(map: Map) {
        super.mapping(map)
        data    <- map["data"]
    }
}