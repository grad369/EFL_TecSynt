//
//  EFLCreatePoolResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 05/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCreatePoolResponseModel: BaseMappableObject, Mappable {
    
    var poolroom : EFLCreatePoolRoomModel?
    var current_server_time: String?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        poolroom <- map["poolroom"]
        current_server_time <- map["current_server_time"]
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
