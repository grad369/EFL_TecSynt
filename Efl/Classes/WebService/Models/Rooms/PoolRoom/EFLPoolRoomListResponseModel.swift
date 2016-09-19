//
//  EFLPoolRoomListResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPoolRoomListResponseModel:BaseMappableObject, Mappable {
    
    var current_server_time     = EmptyString
    var poolrooms               = [Int]()
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        current_server_time     <- map["current_server_time"]
        poolrooms               <- map["poolrooms"]
        
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