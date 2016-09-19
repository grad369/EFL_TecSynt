//
//  EFLDictionary.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func unionInPlace(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
    
    func union(dictionary: Dictionary) -> Dictionary {
        var dictionary = dictionary
        dictionary.unionInPlace(self)
        return dictionary
    }
    
}