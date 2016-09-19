//
//  EFLCompetitionMatchModel.swift
//  Efl
//
//  Created by vishnu vijayan on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCompetitionMatchModel: BaseMappableObject, Mappable {
    
    var match_id                        = 0
    var start_time                      = EmptyString
    var home_team_long_display_name     = EmptyString
    var away_team_long_display_name     = EmptyString
    var home_team_image                 = EmptyString
    var away_team_image                 = EmptyString

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        match_id                        <- map["match_id"]
        start_time                      <- map["start_time"]
        home_team_long_display_name     <- map["home_team_long_display_name"]
        away_team_long_display_name     <- map["away_team_long_display_name"]
        home_team_image                 <- map["home_team_image"]
        away_team_image                 <- map["away_team_image"]
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
