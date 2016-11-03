//
//  EFLDefinitions.swift
//  Efl
//
//  Created by vishnu vijayan on 03/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

internal let APP_DELEGATE   = UIApplication.sharedApplication().delegate as! AppDelegate
internal let SCREEN_WIDTH    = UIScreen.mainScreen().bounds.width
internal let SCREEN_HEIGHT   = UIScreen.mainScreen().bounds.height


public let IS_IPHONE4 = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && SCREEN_HEIGHT == 480
public let IS_IPHONE5 = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && SCREEN_HEIGHT == 568
public let IS_IPHONE6_OR_7 = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && SCREEN_HEIGHT == 667
public let IS_IPHONE6PLUS_OR_7PLUS = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && SCREEN_HEIGHT == 736


public let FONT_REGULAR_10 = UIFont(name: "Roboto-Regular", size: 10)
public let FONT_REGULAR_13 = UIFont(name: "Roboto-Regular", size: 13)
public let FONT_REGULAR_16 = UIFont(name: "Roboto-Regular", size: 16)
public let FONT_REGULAR_19 = UIFont(name: "Roboto-Regular", size: 19)
public let FONT_BOLD_16 = UIFont(name: "Roboto-Bold", size:16)
public let FONT_MEDIUM_16  = UIFont(name: "Roboto-Medium", size: 16)
public let FONT_MEDIUM_19  = UIFont(name: "Roboto-Medium", size: 19)


var CurrentTimestamp: NSTimeInterval {
    return NSDate().timeIntervalSince1970
}

var DeviceLanguagueCode: String {
    return NSLocale.preferredLanguages()[0]
}

var LocalTimeZoneAbbreviation: String {
    return NSTimeZone.localTimeZone().abbreviation!
}
