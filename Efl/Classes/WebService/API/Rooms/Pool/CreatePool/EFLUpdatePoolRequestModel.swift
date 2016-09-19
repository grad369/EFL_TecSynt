//
//  EFLUpdatePoolRequestModel.swift
//  Efl
//
//  Created by vishnu vijayan on 08/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLUpdatePoolRequestModel:EFLBaseAPIRequest {
    
    var pool_name                : String?
    var message                  : String?
    var players                  : [EFLAddPlayerModel] = []
    var pool_image               : String?
}
