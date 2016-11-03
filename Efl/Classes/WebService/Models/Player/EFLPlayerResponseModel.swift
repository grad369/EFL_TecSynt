//
//  EFLPlayerResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPlayerResponseModel: BaseMappableObject, Mappable {
    
    var player_id: Int?
    
    var first_name: String?
    var last_name:  String?
    var image:      String?
    
    var jwt_token:  String?
    var last_updated_on:  String?
    
    var email: String?
    var phone: String?
    var gender: String?
    var birthday: String?
    
    var notification_received_invite:   Bool?
    var notification_received_response: Bool?
    var notification_picks_reminder:    Bool?
    var notification_received_result:   Bool?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        player_id                       <- map["id"]
        first_name                      <- map["first_name"]
        last_name                       <- map["last_name"]
        image                           <- map["image"]
        
        jwt_token                       <- map["jwt_token"]
        last_updated_on                 <- map["last_updated_on"]
        
        email                           <- map["email"]
        phone                           <- map["phone"]
        gender                          <- map["gender"]
        birthday                        <- map["birthday"]

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


class EFLPlayerOverResponseModel: BaseMappableObject, Mappable {
    
    var current_server_time: String?
    var player: EFLPlayerResponseModel?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        current_server_time <- map["current_server_time"]
        player <- map["player"]
    }
}
