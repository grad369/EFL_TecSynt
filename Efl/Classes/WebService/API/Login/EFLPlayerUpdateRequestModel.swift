//
//  EFLPlayerUpdateRequestModel.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPlayerUpdateRequestModel: EFLBaseAPIRequest {

    var first_name: String?
    var last_name: String?
    var image: NSData?
    var facebook_token: String?
    var notification_received_invite:   Bool = false
    var notification_received_response: Bool = false
    var notification_picks_reminder:    Bool = false
    var notification_received_result:   Bool = false
}





