//
//  EFLPoolCardResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 03/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLPoolCardResponseModel: BaseMappableObject, Mappable {
    
    var current_server_time     = EmptyString
    var poolcard                = EFLPoolCardModel()
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        current_server_time     <- map["current_server_time"]
        poolcard                <- map["poolcard"]
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
