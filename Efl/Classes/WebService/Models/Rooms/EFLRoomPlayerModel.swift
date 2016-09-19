//
//  EFLRoomPlayerModel.swift
//  Efl
//
//  Created by Athul Raj on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

class EFLRoomPlayerModel: BaseMappableObject, Mappable {
    var player_id: Int?
    var first_name: String?
    var last_name: String?
    var image: String?
    var room_points:  Float?
    var room_position:  Int?
    var invite_status:  String?
    var status_updated_on: String?
    
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        player_id             <- map["player_id"]
        first_name            <- map["first_name"]
        last_name             <- map["last_name"]
        image                 <- map["image"]
        room_points           <- map["room_points"]
        room_position         <- map["room_position"]
        invite_status         <- map["invite_status"]
        status_updated_on     <- map["status_updated_on"]
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
