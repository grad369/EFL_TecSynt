//
//  EFLCompetitionModel.swift
//  Efl
//
//  Created by vishnu vijayan on 25/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCompetitionModel: BaseMappableObject, Mappable {

    var competition_id          = 0
    var last_updated_on         = EmptyString
    var pretty_display_name     = EmptyString
    var tiny_display_name       = EmptyString
    var image                   = EmptyString
    var country                 = EmptyString
    
    var is_cup                  = false
    var is_completed            = false
    
    var matchdays               = [EFLCompetitionMatchDayModel]()

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        competition_id          <- map["competition_id"]
        last_updated_on         <- map["last_updated_on"]
        pretty_display_name     <- map["pretty_display_name"]
        tiny_display_name       <- map["tiny_display_name"]
        image                   <- map["image"]
        country                 <- map["country"]
        is_cup                  <- map["is_cup"]
        is_completed            <- map["is_completed"]
        matchdays               <- map["matchdays"]
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
