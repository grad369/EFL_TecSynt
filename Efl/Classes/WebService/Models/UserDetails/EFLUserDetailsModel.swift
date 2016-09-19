//
//  EFLUserDetailsModel.swift
//  Efl
//
//  Created by vishnu vijayan on 28/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLUserDetailsModel: BaseMappableObject, Mappable {

    var userName            = EmptyString
    var firstName           = EmptyString
    var lastName            = EmptyString
    var profilePictureURL   = EmptyString
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        userName            <- map["user_name"]
        firstName           <- map["first_name "]
        lastName            <- map["last_name"]
        profilePictureURL   <- map["profile_pic"]
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
