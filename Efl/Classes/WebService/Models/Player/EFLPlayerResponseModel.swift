//
//  EFLPlayerResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPlayerResponseModel: BaseMappableObject, Mappable {
    
    var current_server_time: String?
    var player_id: Int?
    var jwt_token:  String?
    var facebook_token:  String?
    var facebook_id:  String?
    var first_name: String?
    var last_name:  String?
    var image:  String?
    var last_updated_on:  String?
    
    var notification_received_invite:   Bool?
    var notification_received_response: Bool?
    var notification_picks_reminder:    Bool?
    var notification_received_result:   Bool?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        current_server_time             <- map["current_server_time"]
        player_id                       <- map["player_id"]
        first_name                      <- map["first_name"]
        last_name                       <- map["last_name"]
        image                           <- map["image"]
        
        facebook_token                  <- map["facebook_token"]
        facebook_id                     <- map["facebook_id"]
        jwt_token                       <- map["jwt_token"]
        last_updated_on                 <- map["last_updated_on"]

        notification_received_invite    <- map["notification_received_invite"]
        notification_received_response  <- map["notification_received_response"]
        notification_picks_reminder     <- map["notification_picks_reminder"]
        notification_received_result    <- map["notification_received_result"]
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
