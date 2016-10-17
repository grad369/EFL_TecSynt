//
//  EFLCoreDataManager.swift
//  Efl
//
//  Created by vishnu vijayan on 12/08/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLCoreDataManager {

    static let sharedInstance       = EFLCoreDataManager()
    typealias operationCompletion   = (success: Bool, error: String?) -> Void
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Efl", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator     = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url             = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason   = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict                        = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    
    
    /**
     Root NSManagedObjectContext. Interact directly with persistent store coordinator.
     Listens and catches changes made in the child ManagedObjectContexts and writes into persistent store.
     */
    lazy var writerManagedObjectContext: NSManagedObjectContext = {
        var managedObjectContext                        = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var readerManagedObjectContext: NSManagedObjectContext = {
        var managedObjectContext                        = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()



//    /**
//     Child mainqueue NSManagedObjectContext.For facilitiating UI updates.
//     */
//    lazy var mainThreadManagedObjectContext: NSManagedObjectContext = {
//        var managedObjectContext                        = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.parentContext              = self.writerManagedObjectContext
//        return managedObjectContext
//    }()
//    
//    
//    /**
//     Child mainqueue NSManagedObjectContext.For running long operations
//     */
//    lazy var privateManagedObjectContext: NSManagedObjectContext = {
//        var managedObjectContext                        = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        managedObjectContext.parentContext              = self.mainThreadManagedObjectContext
//        return managedObjectContext
//    }()
    
    
    
    
//    @objc func contextDidSavePrivateQueueContext(notification:NSNotification) {
//        objc_sync_enter(self)
//        self.mainThreadManagedObjectContext.performBlock({
//            self.mainThreadManagedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
//            do {
//                try self.mainThreadManagedObjectContext.save()
//            }
//            catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        })
//        objc_sync_exit(self)
//    }
//    
//    
//    
//    @objc func contextDidSaveMainQueueContext(notification:NSNotification) {
//        objc_sync_enter(self)
//        self.writerManagedObjectContext.performBlock({
//            self.writerManagedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
//            do {
//                try self.writerManagedObjectContext.save()
//            }
//            catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        })
//        objc_sync_exit(self)
//        
//    }
    
    
    
//    func savePrivateContextWithCompletion(completion:operationCompletion?) {
//        self.privateManagedObjectContext.performBlock {
//            if self.privateManagedObjectContext.hasChanges {
//                do {
//                    try self.privateManagedObjectContext.save()
//                    if (completion != nil) {
//                        completion!(success: true, error: nil)
//                        return
//                    }
//                }
//                catch let error as NSError {
//                    print(error.localizedDescription)
//                    if (completion != nil) {
//                        completion!(success: false, error: "\(error)")
//                        return
//                    }
//                }
//            }
//            else {
//                if (completion != nil) {
//                    completion!(success: true, error: nil)
//                    return
//                }
//            }
//        }
//    }
//    
//    
//    func saveMainThreadContextWithCompletion(completion:operationCompletion?) {
//        self.mainThreadManagedObjectContext.performBlock {
//            if self.mainThreadManagedObjectContext.hasChanges {
//                do {
//                    try self.mainThreadManagedObjectContext.save()
//                    if (completion != nil) {
//                        completion!(success: true, error: nil)
//                        return
//                    }
//                }
//                catch let error as NSError {
//                    print(error.localizedDescription)
//                    if (completion != nil) {
//                        completion!(success: false, error: "\(error)")
//                        return
//                    }
//                }
//            }
//            else {
//                if (completion != nil) {
//                    completion!(success: true, error: nil)
//                    return
//                }
//            }
//        }
//    }
    
    
    
    func savePrivateContextWithCompletion(completion:operationCompletion?) {
        self.writerManagedObjectContext.performBlock {
            if self.writerManagedObjectContext.hasChanges {
                do {
                    try self.writerManagedObjectContext.save()
                    if (completion != nil) {
                        completion!(success: true, error: nil)
                        return
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                    if (completion != nil) {
                        completion!(success: false, error: "\(error)")
                        return
                    }
                }
            }
            else {
                if (completion != nil) {
                    completion!(success: true, error: nil)
                    return
                }
            }
        }
    }
    
    func saveReaderContextWithCompletion(completion:operationCompletion?) {
        self.readerManagedObjectContext.performBlock {
            if self.readerManagedObjectContext.hasChanges {
                do {
                    try self.readerManagedObjectContext.save()
                    if (completion != nil) {
                        completion!(success: true, error: nil)
                        return
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                    if (completion != nil) {
                        completion!(success: false, error: "\(error)")
                        return
                    }
                }
            }
            else {
                if (completion != nil) {
                    completion!(success: true, error: nil)
                    return
                }
            }
        }
    }
}
