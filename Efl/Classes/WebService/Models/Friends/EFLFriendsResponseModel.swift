//
//  EFLFriendsResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 01/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLFriendsResponseModel:  BaseMappableObject, Mappable {
    
    var current_server_time = EmptyString
    var friends             = [EFLFriendModel]()

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        current_server_time     <- map["current_server_time"]
        friends                 <- map["friends"]
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