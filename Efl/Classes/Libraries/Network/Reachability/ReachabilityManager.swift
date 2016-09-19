//
//  ReachabilityManager.swift
//  BaseProjectStructure
//
//  Created by Amruthaprasad on 25/01/16.
//  Copyright © 2016 Amruthaprasad. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    
    var reachability : Reachability?

    //MARK: Default Manager
    class var sharedManager: ReachabilityManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ReachabilityManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ReachabilityManager()
        }
        return Static.instance!
    }
    
    //MARK: Class Methods
    static func isReachable() -> Bool{
    return ReachabilityManager.sharedManager.reachability!.isReachable()
    }
    
    static func isUnreachable() -> Bool {
    return !(ReachabilityManager.sharedManager.reachability!.isReachable())
    }
    
    static func isReachableViaWWAN() -> Bool{
    return ReachabilityManager.sharedManager.reachability!.isReachableViaWWAN()
    }
    
    static func isReachableViaWiFi() ->Bool{
    return ReachabilityManager.sharedManager.reachability!.isReachableViaWiFi()
    }

    //MARK: Private Initialization
    override init() {
        do {
            // Initialize Reachability
            self.reachability = try Reachability.reachabilityForInternetConnection()
            
            // Start Monitoring
            try self.reachability?.startNotifier()
            
        } catch {
            print("Unable to create Reachability")
            return
        }

    }
}

