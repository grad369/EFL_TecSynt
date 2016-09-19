//
//  EFLCreatePoolRequestModel.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCreatePoolRequestModel: EFLBaseAPIRequest {

    var pool_name                : String?
    var competition_id           = 0
    var message                  : String?
    var players                  : [EFLAddPlayerModel] = []
    var pool_image               : String?
}
