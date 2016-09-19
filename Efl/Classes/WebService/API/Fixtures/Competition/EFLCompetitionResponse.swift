//
//  EFLCompetitionResponse.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCompetitionResponse: EFLBaseAPIResponse {
    
    var data = EFLCompetitionResponseModel()
    
    override func mapping(map: Map) {
        super.mapping(map)
        data   <- map["data"]
    }
}
