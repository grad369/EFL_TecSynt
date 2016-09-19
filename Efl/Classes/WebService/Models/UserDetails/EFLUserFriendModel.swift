//
//  EFLUserFriendModel.swift
//  Efl
//
//  Created by vishnu vijayan on 11/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLUserFriendModel: BaseMappableObject, Mappable {
    
    var id                          = 0
    var first_name: String          = EmptyString
    var last_name: String           = EmptyString
    var profile_image_url: String   = EmptyString
    var signedup_on: String         = EmptyString

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        profile_image_url   <- map["profile_image_url"]
        signedup_on         <- map["signedup_on"]
    }
    
    convenience override init(){
        self.init(params: nil)
    }
    
    init(params: AnyObject?){
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
