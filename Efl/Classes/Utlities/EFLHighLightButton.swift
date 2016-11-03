//
//  EFLHighLightButton.swift
//  Efl
//
//  Created by vishnu vijayan on 17/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class EFLHighLightButton: UIButton {
    var bgColor = UIColor.eflWhiteColor()

    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                backgroundColor = UIColor.eflSurfaceReactionColor()
            }
            else {
                backgroundColor = bgColor
            }
            
            super.highlighted = newValue
            
        }
    }
}
