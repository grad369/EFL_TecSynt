//
//  EFLPoolCardModel.swift
//  Efl
//
//  Created by Athul Raj on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

class EFLPoolCardModel: BaseMappableObject, Mappable {
    
    var poolcard_id: Int?
    var last_updated_on:  String?
    var matchday_status:  String?
    var matchday_number:  Int?
    var matchday_label: String?
    var is_matchday_drawn:  String?
    var matches: [EFLPoolCardMatchModel] = []
    var players: [EFLPoolCardPlayerModel] = []
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        poolcard_id             <- map["poolcard_id"]
        last_updated_on         <- map["last_updated_on"]
        matchday_status         <- map["matchday_status"]
        matchday_number         <- map["matchday_number"]
        matchday_label          <- map["matchday_label"]
        is_matchday_drawn       <- map["is_matchday_drawn"]
        matches                 <- map["matches"]
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



class EFLPoolCardMatchModel: BaseMappableObject, Mappable {

    var match_id: Int?
    var home_team_long_display_name:  String?
    var away_team_long_display_name:  String?
    var home_team_image:  String?
    var away_team_image:  String?
    var home_team_score:  Int?
    var away_team_score:  Int?
    var start_time: String?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        match_id                       <- map["match_id"]
        home_team_long_display_name    <- map["home_team_long_display_name"]
        away_team_long_display_name    <- map["away_team_long_display_name"]
        home_team_image                <- map["home_team_image"]
        away_team_image                <- map["away_team_image"]
        home_team_score                <- map["home_team_score"]
        away_team_score                <- map["away_team_score"]
        start_time                     <- map["start_time"]
        
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


class EFLPoolCardPlayerModel: BaseMappableObject, Mappable{
    
    var player_id: Int?
    var card_points:  Float?
    var card_position:  Int?
    var picks: [EFLPoolPlayerPickModel] = []
    
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        player_id                       <- map["player_id"]
        card_points                     <- map["card_points"]
        card_position                   <- map["card_position"]
        picks                           <- map["picks"]
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


class EFLPoolPlayerPickModel: BaseMappableObject, Mappable {
    
    var match_id: Int?
    var home_team_pick:  Int?
    var away_team_pick:  Int?
    var match_points:  Float?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        match_id                       <- map["match_id"]
        home_team_pick                 <- map["home_team_pick"]
        away_team_pick                 <- map["away_team_pick"]
        match_points                   <- map["match_points"]
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


