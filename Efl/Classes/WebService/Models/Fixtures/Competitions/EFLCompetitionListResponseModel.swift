//
//  EFLCompetitionListResponseModel.swift
//  Efl
//
//  Created by vishnu vijayan on 02/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLCompetitionListResponseModel: BaseMappableObject, Mappable {
    
    var current_server_time     = EmptyString
    var competitions            = [Int]()
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        current_server_time     <- map["current_server_time"]
        competitions            <- map["competitions"]

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