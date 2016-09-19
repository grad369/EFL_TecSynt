//
//  BaseMappableObject.swift
//  Efl
//
//  Created by vishnu vijayan on 26/07/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit

class BaseMappableObject: NSObject {
    
    func toDictionary() -> [String:AnyObject] {
        
        var dictionary = [String:AnyObject]()
        let mirrored_object = Mirror(reflecting: self)
        dictionary = getParamsAsDictionaryFrom(mirrored_object)!
        return dictionary
    }
    
    func toMultiPartDictionary() -> [String:AnyObject] {
        
        var dictionary = [String:AnyObject]()
        let mirrored_object = Mirror(reflecting: self)
        dictionary = getParamsAsMultipartDictionaryFrom(mirrored_object)!
        return dictionary
    }
    
//    func toJSONDict() -> [String:AnyObject] {
//        let requestModel = Mirror(reflecting: self)
//        let JSONString = Mapper().toJSONString(requestModel, prettyPrint: true)
//        
//        let JSONDict = NSJSONSerialization.JSONObjectWithData(JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), options: NSJSONReadingOptions.MutableContainers, error: nil)
//        return JSONDict
//    }
    
    func getParamsAsDictionaryFrom(mirrored_object: Mirror) -> [String: AnyObject]? {
        
        var dictionary = [String:AnyObject]()
        for child in mirrored_object.children {
            
            if let key = child.label {
                
                if (self.valueForKey(key) != nil) {
                    
                    if self.valueForKey(key)!.isKindOfClass(BaseMappableObject){
                        dictionary[key] = (self.valueForKey(key)! as! BaseMappableObject).toDictionary()
                    }else if self.valueForKey(key)!.isKindOfClass(NSArray){
                        
                        if self.valueForKey(key)![0] .isKindOfClass(BaseMappableObject) {
                            let objArray = (self.valueForKey(key)! as! [BaseMappableObject])
                            var dictArray : [NSDictionary] = []
                            for playerObj in objArray {
                                dictArray.append(playerObj.toDictionary())
                            }
                            dictionary[key] = dictArray
                        }else{
                            dictionary[key] = self.valueForKey(key)!
                        }
                    }else{
                        dictionary[key] = self.valueForKey(key)!
                    }
                }
            }
        }
        
        if let parent = mirrored_object.superclassMirror(){
            let temporaryDictionary = getParamsAsDictionaryFrom(parent)!
            
            for (key, value) in temporaryDictionary {
                if dictionary[key] == nil {
                    dictionary[key] = value
                }
            }
        }
        
        return dictionary
    }
    
    func getParamsAsMultipartDictionaryFrom(mirrored_object: Mirror) -> [String: AnyObject]? {
        
        var dictionary = [String:AnyObject]()
        for child in mirrored_object.children {
            
            if let key = child.label {
                
                
                if (self.valueForKey(key) != nil) {
                    
                    if self.valueForKey(key)!.isKindOfClass(BaseMappableObject){
                        
                        dictionary = dictionary.union((self.valueForKey(key)! as! BaseMappableObject).toMultiPartDictionary())
                    }else{
                        dictionary[key] = self.valueForKey(key)!
                    }
                }
                
            }
        }
        
        if let parent = mirrored_object.superclassMirror(){
            let temporaryDictionary = getParamsAsMultipartDictionaryFrom(parent)!
            
            for (key, value) in temporaryDictionary {
                if dictionary[key] == nil {
                    dictionary[key] = value
                }
            }
        }
        
        return dictionary
    }
    
}
