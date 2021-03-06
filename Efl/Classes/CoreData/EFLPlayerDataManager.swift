//
//  EFLPlayerDataManager.swift
//  Efl
//
//  Created by vishnu vijayan on 06/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLPlayerDataManager: NSObject {

    static let sharedDataManager = EFLPlayerDataManager()
    
    //MARK: Friends cache methods
    //Sync friends to cache
    func syncFriends(values:EFLFriendsResponseModel) {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Friends")
            
            for friendModel in values.friends {
                let predicate = NSPredicate(format: "playerId=%@", String(friendModel.player_id))
                fetchRequest.predicate = predicate
                
                do {
                    if let result =
                        try privateMOC.executeFetchRequest(fetchRequest).last {
                        
                        result.setValue(friendModel.first_name, forKey: FriendsFirstNameKey)
                        result.setValue(friendModel.last_name, forKey: FriendsLastNameKey)
                        result.setValue(friendModel.image, forKey: FriendsImageUrlKey)
                        result.setValue(nil, forKey: FriendsImageKey)
                        if friendModel.signedup_on.isEmpty {
                            result.setValue(false, forKey: FriendsIsSignedUpKey)
                        }
                        else {
                            result.setValue(true, forKey: FriendsIsSignedUpKey)
                        }
                    }
                    else {
                        let entity =  NSEntityDescription.entityForName("Friends",
                            inManagedObjectContext:privateMOC)
                        let friend = NSManagedObject(entity: entity!,
                            insertIntoManagedObjectContext: privateMOC)
                        
                        friend.setValue(String(friendModel.player_id), forKey: FriendsIdKey)
                        friend.setValue(friendModel.first_name, forKey: FriendsFirstNameKey)
                        friend.setValue(friendModel.last_name, forKey: FriendsLastNameKey)
                        friend.setValue(friendModel.image, forKey: FriendsImageUrlKey)
                        friend.setValue(nil, forKey: FriendsImageKey)
                        
                        if friendModel.signedup_on.isEmpty {
                            friend.setValue(false, forKey: FriendsIsSignedUpKey)
                        }
                        else {
                            friend.setValue(true, forKey: FriendsIsSignedUpKey)
                        }
                    }
                    
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }
        
        EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
            print(success)
        }
    }
    
    
    //Get friends from cache
    func getFriendsFromCache() -> [AnyObject]? {
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Friends")
        do {
            let result:NSArray? =
                try privateMOC.executeFetchRequest(fetchRequest)
            if let res = result{
                if res.count > 0 {
                    return res as [AnyObject];
                }
                else {
                    return nil
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    // Save friend profile picture
    func saveUserFriendProfilePicture(id: String, imageData: NSData) {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Friends")
        let predicate = NSPredicate(format: "playerId=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                result.setValue(imageData, forKey: FriendsImageKey)
                do {
                    try privateMOC.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // Get friend details
    func getUserFriendDetails(id: String) -> AnyObject? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Friends")
        let predicate = NSPredicate(format: "playerId=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                return result
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //Get friend profile picture
    func getUserFriendProfilePicture(id: String) -> UIImage? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Friends")
        let predicate = NSPredicate(format: "playerId=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                if let imageData = result.valueForKey(FriendsImageKey) {
                    return UIImage(data:imageData as! NSData,scale:1.0)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
    //MARK : Truncate tables on log out
    func truncateDataBase() {
        
        let persistentStoreCoordinator = EFLCoreDataManager.sharedInstance.persistentStoreCoordinator
        let persistentStore = persistentStoreCoordinator.persistentStores[0]
        
        let storeURL = persistentStore.URL
        do {
            try persistentStoreCoordinator.removePersistentStore(persistentStore)
        } catch let error as NSError {
            print("failed", error.localizedDescription)
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath((storeURL?.path)!)
        } catch let error as NSError {
            print("failed", error.localizedDescription)
        }
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch let error as NSError {
            print("failed", error.localizedDescription)
        }
    }
}
