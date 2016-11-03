//
//  EFLPlayerResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPlayerResponse: EFLBaseAPIResponse {

    var data: EFLPlayerOverResponseModel?
    
    override func mapping(map: Map) {
        super.mapping(map)
        data <- map["data"]
    }
}

