//
//  EFLFriendsResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLFriendsResponse: EFLBaseAPIResponse {

    var data: EFLFriendsResponseModel?
    
    override func mapping(map: Map) {
        super.mapping(map)
        data     <- map["data"]
    }
}
