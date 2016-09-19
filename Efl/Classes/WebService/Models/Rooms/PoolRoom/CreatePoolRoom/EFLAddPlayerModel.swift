//
//  EFLAddPlayerModel.swift
//  Efl
//
//  Created by vishnu vijayan on 31/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLAddPlayerModel: BaseMappableObject, Mappable {
    
    var player_id = 0
    var invite_status = EmptyString
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        player_id <- map ["player_id"]
        invite_status <- map ["invite_status"]
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
