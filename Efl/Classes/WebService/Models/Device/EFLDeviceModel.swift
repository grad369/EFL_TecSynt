//
//  EFLDeviceModel.swift
//  Efl
//
//  Created by Athul Raj on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

class EFLDeviceModel: BaseMappableObject, Mappable  {
    
    var device_id: Int?
    var device_token:  String?
    var device_type:  String?
    var device_language:  String?
    var device_utc_offset:  String?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        device_id                       <- map["device_id"]
        device_token                    <- map["device_token"]
        device_type                     <- map["device_type"]
        device_language                 <- map["device_language"]
        device_utc_offset               <- map["device_utc_offset"]
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