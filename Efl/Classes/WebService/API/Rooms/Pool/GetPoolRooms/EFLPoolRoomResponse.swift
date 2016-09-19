//
//  EFLPoolRoomResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPoolRoomResponse: EFLBaseAPIResponse {
    
    var data = EFLPoolRoomResponseModel()
    
    override func mapping(map: Map) {
        super.mapping(map)
        data   <- map["data"]
    }
}