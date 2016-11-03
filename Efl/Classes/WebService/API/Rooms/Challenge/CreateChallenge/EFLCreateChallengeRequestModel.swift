//
//  EFLCreateChallengeRequestModel.swift
//  Efl
//
//  Created by vaskov on 01.11.16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

class EFLCreateChallengeRequestModel: EFLBaseAPIRequest {
    
    var competition_id           = 0
    var message                  : String?
    var players                  : [EFLAddPlayerModel] = []
    var matches                  = []
}
