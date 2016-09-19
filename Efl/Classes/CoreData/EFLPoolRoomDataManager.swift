//
//  EFLPoolRoomDataManager.swift
//  Efl
//
//  Created by vishnu vijayan on 06/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLPoolRoomDataManager: NSObject {
    
    static let sharedDataManager = EFLPoolRoomDataManager()
    typealias poolRoomSyncCompletion   = (success: Bool, error: String?) -> Void

    //Get pool rooms from cache
    func getPoolRoomsFromCache() -> [AnyObject]? {
        let managedContext = EFLCoreDataManager.sharedInstance.readerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRooms")
        do {
            let result:NSArray? =
                try managedContext.executeFetchRequest(fetchRequest) as [AnyObject]
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
    
    // Save pool room image
    func savePoolRoomImageToCache(id: String, imageData: NSData) {
        
        let managedContext = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRooms")
        let predicate = NSPredicate(format: "poolroom_id=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try managedContext.executeFetchRequest(fetchRequest).last {
                result.setValue(imageData, forKey: "pool_imageData")
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //Get pool room image
    func getPoolRoomImageFromCache(id: String) -> UIImage? {
        
        let managedContext = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRooms")
        let predicate = NSPredicate(format: "poolroom_id=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try managedContext.executeFetchRequest(fetchRequest).last {
                
                if let imageData = result.valueForKey("pool_imageData") {
                    return UIImage(data:imageData as! NSData,scale:1.0)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //Sync pool room cache
    func syncPoolRoomToCache(poolRoom: EFLPoolRoomModel) {
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRooms")
        
        let predicate = NSPredicate(format: "poolroom_id=%@", String(poolRoom.poolroom_id))
        fetchRequest.predicate = predicate

        
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last as? NSManagedObject {
                result.setValue(poolRoom.last_updated_on, forKey: "last_updated_on")
                result.setValue(poolRoom.message, forKey: "message")
                result.setValue(poolRoom.pool_image, forKey: "pool_image")
                result.setValue(poolRoom.pool_name, forKey: "pool_name")
                result.setValue(String(poolRoom.competition_id), forKey: "competition_id")
                
                result.setValue(nil, forKey: "pool_imageData")
                
                for player in poolRoom.players {
                    self.syncPoolRoomPlayersToCache(String(poolRoom.poolroom_id), player: player, privateMOC: privateMOC)
                }
            }
            else {
                let entity =  NSEntityDescription.entityForName("PoolRooms",
                                                                inManagedObjectContext:privateMOC)
                let poolRoomEntity = NSManagedObject(entity: entity!,
                                                     insertIntoManagedObjectContext: privateMOC)
                

                poolRoomEntity.setValue(poolRoom.last_updated_on, forKey: "last_updated_on")
                poolRoomEntity.setValue(poolRoom.message, forKey: "message")
                poolRoomEntity.setValue(poolRoom.pool_image, forKey: "pool_image")
                poolRoomEntity.setValue(poolRoom.pool_name, forKey: "pool_name")
                poolRoomEntity.setValue(String(poolRoom.poolroom_id), forKey: "poolroom_id")
                poolRoomEntity.setValue(String(poolRoom.competition_id), forKey: "competition_id")

                poolRoomEntity.setValue(nil, forKey: "pool_imageData")
                for player in poolRoom.players {
                    self.syncPoolRoomPlayersToCache(String(poolRoom.poolroom_id), player: player, privateMOC: privateMOC)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
//        EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
//            print(success)
//        }
    }
    
    //Syn new pool room created to cache
    func syncCreatedPoolRoomToCache(poolRoom: EFLCreatePoolRoomModel, and completion:poolRoomSyncCompletion) {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRooms")
        let predicate = NSPredicate(format: "poolroom_id=%@", String(poolRoom.poolroom_id))
        
        fetchRequest.predicate = predicate
        
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                result.setValue(poolRoom.last_updated_on, forKey: "last_updated_on")
                result.setValue(poolRoom.message, forKey: "message")
                result.setValue(poolRoom.pool_image, forKey: "pool_image")
                result.setValue(poolRoom.pool_name, forKey: "pool_name")
                result.setValue(String(poolRoom.competition_id), forKey: "competition_id")

                result.setValue(nil, forKey: "pool_imageData")
                
                for player in poolRoom.players {
                    self.syncPoolRoomPlayersToCache(String(poolRoom.poolroom_id), player: player, privateMOC: privateMOC)
                }
                
            }
            else {
                let entity =  NSEntityDescription.entityForName("PoolRooms",
                                                                inManagedObjectContext:privateMOC)
                let poolRoomEntity = NSManagedObject(entity: entity!,
                                                     insertIntoManagedObjectContext: privateMOC)
                poolRoomEntity.setValue(poolRoom.last_updated_on, forKey: "last_updated_on")
                poolRoomEntity.setValue(poolRoom.message, forKey: "message")
                poolRoomEntity.setValue(poolRoom.pool_image, forKey: "pool_image")
                poolRoomEntity.setValue(poolRoom.pool_name, forKey: "pool_name")
                poolRoomEntity.setValue(String(poolRoom.poolroom_id), forKey: "poolroom_id")
                poolRoomEntity.setValue(String(poolRoom.competition_id), forKey: "competition_id")

                poolRoomEntity.setValue(nil, forKey: "pool_imageData")
                
                for player in poolRoom.players {
                    self.syncPoolRoomPlayersToCache(String(poolRoom.poolroom_id), player: player, privateMOC: privateMOC)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
                completion(success: success, error: error)
            print(success)
        }
    }
    
    //Syn remove declined pool room from cache
    func removeDeclinedPoolRoomFromCache(poolRoom: NSManagedObject, and completion:poolRoomSyncCompletion) {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.readerManagedObjectContext
        if let playerList = EFLPoolRoomDataManager.sharedDataManager.getPoolRoomPlayersFromContext(poolRoom.valueForKey("poolroom_id") as! String, privateMOC: privateMOC)
        {
            for player in playerList {
                if let playerObject = player as? NSManagedObject {
                    privateMOC.deleteObject(playerObject)
                }
            }
        }
        privateMOC.deleteObject(poolRoom)
        EFLCoreDataManager.sharedInstance.saveReaderContextWithCompletion { (success, error) in
            completion(success: success, error: error)
            print(success)
        }
    }

    //Get pool room players from cache
    func getPoolRoomPlayersFromContext(poolroomId: String, privateMOC: NSManagedObjectContext) -> [AnyObject]? {

        let fetchRequest = NSFetchRequest(entityName: "PoolRoomPlayers")
        let predicate = NSPredicate(format: "poolroom_id=%@", poolroomId)
        fetchRequest.predicate = predicate
        
        do {
            let result:NSArray? =
                try privateMOC.executeFetchRequest(fetchRequest) as [AnyObject]
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

    
    
    //Get pool room players from cache
    func getPoolRoomPlayersFromCache(poolroomId: String) -> [AnyObject]? {
        let managedContext = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRoomPlayers")
        let predicate = NSPredicate(format: "poolroom_id=%@", poolroomId)
        fetchRequest.predicate = predicate

        do {
            let result:NSArray? =
                try managedContext.executeFetchRequest(fetchRequest) as [AnyObject]
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
    
    // Save pool room player image to cache
    func savePoolRoomPlayerImageToCache(id: String, imageData: NSData) {
        
        let managedContext = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PoolRoomPlayers")
        let predicate = NSPredicate(format: "player_id=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try managedContext.executeFetchRequest(fetchRequest).last {
                result.setValue(imageData, forKey: "imageData")
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }


    //Sync pool room players to cache
    func syncPoolRoomPlayersToCache(poolRoomId: String, player: EFLRoomPlayerModel, privateMOC: NSManagedObjectContext) {

        let fetchRequest = NSFetchRequest(entityName: "PoolRoomPlayers")
       
        let predicate1 = NSPredicate(format: "poolroom_id=%@", poolRoomId)
        let predicate2 = NSPredicate(format: "player_id=%@", String(player.player_id!))

        let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = compoundPredicate

        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                result.setValue(player.first_name, forKey: "first_name")
                result.setValue(player.last_name, forKey: "last_name")
                result.setValue(player.image, forKey: "image")
                result.setValue(nil, forKey: "imageData")

                result.setValue(player.invite_status, forKey: "invite_status")
                result.setValue(player.room_points, forKey: "room_points")
                result.setValue(player.room_position, forKey: "room_position")
                result.setValue(player.status_updated_on, forKey: "status_updated_on")
            }
            else {
                let entity =  NSEntityDescription.entityForName("PoolRoomPlayers",
                                                                inManagedObjectContext:privateMOC)
                let playerEntity = NSManagedObject(entity: entity!,
                                                  insertIntoManagedObjectContext: privateMOC)
                
                playerEntity.setValue(poolRoomId, forKey: "poolroom_id")
                playerEntity.setValue(player.first_name, forKey: "first_name")
                playerEntity.setValue(player.last_name, forKey: "last_name")
                playerEntity.setValue(player.image, forKey: "image")
                playerEntity.setValue(nil, forKey: "imageData")

                playerEntity.setValue(String(player.player_id!), forKey: "player_id")
                playerEntity.setValue(player.invite_status, forKey: "invite_status")
                playerEntity.setValue(player.room_points, forKey: "room_points")
                playerEntity.setValue(player.room_position, forKey: "room_position")
                playerEntity.setValue(player.status_updated_on, forKey: "status_updated_on")
                playerEntity.setValue(player.status_updated_on, forKey: "status_updated_on")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
