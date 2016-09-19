//
//  StringExtension.swift
//  Efl
//
//  Created by vishnu vijayan on 04/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}