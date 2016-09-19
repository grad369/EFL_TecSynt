//
//  EFLPoolRoomModel.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPoolRoomModel: BaseMappableObject, Mappable {
    
    var poolroom_id         = 0
    var competition_id      = 0
    var pool_image          = EmptyString
    var pool_name           = EmptyString
    var room_status         = EmptyString
    var last_updated_on     = EmptyString
    var message             = EmptyString
    
    var players             = [EFLRoomPlayerModel]()
    var poolcards           = [Int]() // Get pool card ids

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        poolroom_id         <- map["poolroom_id"]
        competition_id      <- map["competition_id"]
        pool_image          <- map["pool_image"]
        pool_name           <- map["pool_name"]
        room_status         <- map["room_status"]
        last_updated_on     <- map["last_updated_on"]
        message             <- map["message"]
        players             <- map["players"]
        poolcards           <- map["poolcards"]
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






