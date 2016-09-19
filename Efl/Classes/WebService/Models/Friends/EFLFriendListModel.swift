
//
//  EFLFriendListModel.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLFriendListModel: NSObject {

    var playerId: String            = EmptyString
    var first_name: String          = EmptyString
    var last_name: String           = EmptyString
    var profile_image_url: String   = EmptyString
    var isSelected                  = false
    var signedup_on                 = false

    override init() {
        super.init()
    }
    
    func initWithData(data: AnyObject) -> EFLFriendListModel {
        playerId            = data.valueForKey("playerId") as! String
        first_name          = data.valueForKey("firstName") as! String
        last_name           = data.valueForKey("lastName") as! String
        profile_image_url   = data.valueForKey("imageURL") as! String
        signedup_on         = data.valueForKey("isSignedUp") as! Bool

        return self
    }
}
