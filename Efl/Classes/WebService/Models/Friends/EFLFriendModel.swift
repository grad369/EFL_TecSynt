//
//  EFLFriendModel.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLFriendModel: BaseMappableObject, Mappable
{
    
    var player_id               = 0
    var first_name:     String  = EmptyString
    var last_name:      String  = EmptyString
    var image:          String  = EmptyString
    var signedup_on:    String  = EmptyString
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        player_id       <- map["player_id"]
        first_name      <- map["first_name"]
        last_name       <- map["last_name"]
        image           <- map["image"]
        signedup_on     <- map["signedup_on"]
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
