//
//  EFLColor.swift
//  Efl
//
//  Created by vishnu vijayan on 27/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

//Solid Colors
let EflWhiteColorCode           : Int = 0xFFFFFF
let EflBlackColorCode           : Int = 0x000000
let EflDarkGreyColorCode        : Int = 0x757575
let EflMidGreyColorCode         : Int = 0x9E9E9E
let EfllighterGreyColorCode     : Int = 0xC7C7C7
let EflLightGreycolorCode       : Int = 0xF5F5F5
let EflGreenColorCode           : Int = 0x558B2F
let EflRedColorCode             : Int = 0xD0021B
let EflOrangeColorCode          : Int = 0xF7631B
let EflBlueColorCode            : Int = 0x1976D2
let EflFaceBookBlueColorCode    : Int = 0x4267B2
let EflSurfaceReactionColorCode : Int = 0xD9D9D9

//Gradient Colors
let EflGreenUpperGradientColorCode  : Int = 0xB4EC51
let EflGreenLowerGradientColorCode  : Int = 0x429321
let EflGoldUpperGradientColorCode   : Int = 0xD6BD4C
let EflGoldLowerGradientColorCode   : Int = 0x7F6F23
let EflSilverUpperGradientColorCode : Int = 0xBABDD2
let EflSilverLowerGradientColorCode : Int = 0x525464
let EflBronzeUpperGradientColorCode : Int = 0xD1AB6A
let EflBronzeLowerGradientColorCode : Int = 0x665537

func UIColorFromRGB(rgbValue: Int) -> UIColor {
    
    return UIColor.init(red: CGFloat(((rgbValue & 0xFF0000) >> 16))/255.0, green: CGFloat(((rgbValue & 0x00FF00) >> 8))/255.0, blue: CGFloat(((rgbValue & 0x0000FF) >> 0))/255.0, alpha: 1.0)
}

public extension UIColor{
    
    static func eflWhiteColor() -> UIColor {
        return UIColorFromRGB(EflWhiteColorCode)
    }
    
    static func eflBlackColor() -> UIColor {
        return UIColorFromRGB(EflBlackColorCode)
    }
    
    static func eflDarkGreyColor() -> UIColor {
        return UIColorFromRGB(EflDarkGreyColorCode)
    }
    
    static func eflMidGreyColor() -> UIColor {
        return UIColorFromRGB(EflMidGreyColorCode)
    }
    
    static func efllighterGreyColor() -> UIColor{
        return UIColorFromRGB(EfllighterGreyColorCode)
    }
    
    static func eflLightGreycolor() -> UIColor {
        return UIColorFromRGB(EflLightGreycolorCode)
    }
    
    static func eflGreenColor() -> UIColor {
        return UIColorFromRGB(EflGreenColorCode)
    }
    
    static func eflRedColor() -> UIColor {
        return UIColorFromRGB(EflRedColorCode)
    }

    static func eflOrangeColor() -> UIColor {
        return UIColorFromRGB(EflOrangeColorCode)
    }

    static func eflBlueColor() -> UIColor {
        return UIColorFromRGB(EflBlueColorCode)
    }

    static func eflFaceBookBlueColor() -> UIColor {
        return UIColorFromRGB(EflFaceBookBlueColorCode)
    }

    static func eflSurfaceReactionColor() -> UIColor {
        return UIColorFromRGB(EflSurfaceReactionColorCode)
    }

    static func eflGreenUpperGradientColor() -> UIColor {
        return UIColorFromRGB(EflGreenUpperGradientColorCode)
    }

    static func eflGreenLowerGradientColor() -> UIColor {
        return UIColorFromRGB(EflGreenLowerGradientColorCode)
    }

    static func eflGoldUpperGradientColor() -> UIColor {
        return UIColorFromRGB(EflGoldUpperGradientColorCode)
    }

    static func eflGoldLowerGradientColor() -> UIColor {
        return UIColorFromRGB(EflGoldLowerGradientColorCode)
    }

    static func eflSilverUpperGradientColor() -> UIColor {
        return UIColorFromRGB(EflSilverUpperGradientColorCode)
    }

    static func eflSilverLowerGradientColor() -> UIColor {
        return UIColorFromRGB(EflSilverLowerGradientColorCode)
    }

    static func eflBronzeUpperGradientColor() -> UIColor {
        return UIColorFromRGB(EflBronzeUpperGradientColorCode)
    }

    static func eflBronzeLowerGradientColor() -> UIColor {
        return UIColorFromRGB(EflBronzeLowerGradientColorCode)
    }

}
