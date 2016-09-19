//
//  EFLCompetitionMatchDayModel.swift
//  Efl
//
//  Created by vishnu vijayan on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCompetitionMatchDayModel: BaseMappableObject, Mappable {
    
    var matchday_id         = 0
    var matchday_number     = EmptyString
    var matchday_status     = EmptyString
    var matchday_label      = EmptyString
    var matches             = [EFLCompetitionMatchModel]()

    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        matchday_id         <- map["matchday_id"]
        matchday_number     <- map["matchday_number"]
        matchday_status     <- map["matchday_status"]
        matchday_label      <- map["matchday_label"]
        matches             <- map["matches"]
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
