//
//  EFLCreatePoolRoomModel.swift
//  Efl
//
//  Created by vishnu vijayan on 05/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCreatePoolRoomModel: BaseMappableObject, Mappable {
    
    var poolroom_id = 0
    var competition_id  = 0
    var pool_name: String?
    var pool_image: String?
    var room_status: String?
    var last_updated_on: String?
    var message: String?
    var poolcards: [EFLPoolCardModel] = []
    var players: [EFLRoomPlayerModel] = []
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        poolroom_id <- map["poolroom_id"]
        competition_id <- map["competition_id"]
        pool_name <- map["pool_name"]
        pool_image <- map["pool_image"]
        room_status <- map["room_status"]
        last_updated_on <- map["last_updated_on"]
        message <- map["message"]
        poolcards <- map["poolcards"]
        players <- map["players"]
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
