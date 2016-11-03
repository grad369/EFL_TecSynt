//
//  StringExtension.swift
//  Efl
//
//  Created by vishnu vijayan on 04/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func size(font: UIFont, width: CGFloat = CGFloat.max) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        
        let boundingRect = self.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
                                                      options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                      attributes: fontAttributes,
                                                      context:nil)
        
        
        return boundingRect.size
    }
}
