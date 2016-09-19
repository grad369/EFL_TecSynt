//
//  EFLCompetitionDataManager.swift
//  Efl
//
//  Created by vishnu vijayan on 05/09/16.
//  Copyright © 2016 ZNET. All rights reserved.
//

import UIKit
import CoreData

class EFLCompetitionDataManager: NSObject {
    static let sharedDataManager = EFLCompetitionDataManager()
    
    //MARK: Competition cache methods
    
    //Get competition last updated time stamp from cache
    func getCompetitionLastUpdatedTimeStamp(competitionId: String) -> String? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Competitions")
        let predicate = NSPredicate(format: "competition_id=%@", competitionId)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                if let lastUpdateTimeStamp = result.valueForKey("lastUpdatedServerTime") {
                    return lastUpdateTimeStamp as? String
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //Get competition Ids
    func getCompetitionIds() -> [String]? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Competitions")
        fetchRequest.propertiesToFetch = []
        do {
            let result:NSArray? =
                try privateMOC.executeFetchRequest(fetchRequest)
            if let res = result{
                if res.count > 0 {
                    return res.valueForKeyPath("competition_id") as? [String]
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
    
    //Get competitions
    func getCompetitions() -> [AnyObject]? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Competitions")
        fetchRequest.propertiesToFetch = []
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
    
    //Get competition name
    func getCompetitionName(id: String) -> String? {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Competitions")
        let predicate = NSPredicate(format: "competition_id=%@", id)
        
        fetchRequest.predicate = predicate
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                if let competitionName = result.valueForKey("tiny_display_name") {
                    return competitionName as? String
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //Sync competition details to cache
    func syncCompetitionToCache(competition: EFLCompetitionResponseModel) {
        
        let privateMOC = EFLCoreDataManager.sharedInstance.writerManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Competitions")
        let predicate = NSPredicate(format: "competition_id=%@", String(competition.competition.competition_id))
        
        fetchRequest.predicate = predicate

        do {
            print("competition_id from cache \(competition.competition.competition_id)")
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last as? NSManagedObject {
                
                result.setValue(competition.competition.country, forKey: "country")
                result.setValue(competition.competition.image, forKey: "image")
                result.setValue(competition.competition.is_completed, forKey: "is_completed")
                result.setValue(competition.competition.is_cup, forKey: "is_cup")
                result.setValue(competition.competition.last_updated_on, forKey: "last_updated_on")
                result.setValue(competition.competition.pretty_display_name, forKey: "pretty_display_name")
                result.setValue(competition.competition.tiny_display_name, forKey: "tiny_display_name")
                
                for matchDay in competition.competition.matchdays {
                    self.syncCompetitionMatchDaysToCache(String(competition.competition.competition_id), matchDay: matchDay, privateMOC: privateMOC)
                }
                result.setValue(competition.current_server_time, forKey: "lastUpdatedServerTime")
                
            }
            else {
                let entity =  NSEntityDescription.entityForName("Competitions",
                                                                inManagedObjectContext:privateMOC)
                let competitionEntity = NSManagedObject(entity: entity!,
                                                        insertIntoManagedObjectContext: privateMOC)
                
                competitionEntity.setValue(String(competition.competition.competition_id), forKey: "competition_id")
                competitionEntity.setValue(competition.competition.country, forKey: "country")
                competitionEntity.setValue(competition.competition.image, forKey: "image")
                competitionEntity.setValue(competition.competition.is_completed, forKey: "is_completed")
                competitionEntity.setValue(competition.competition.is_cup, forKey: "is_cup")
                competitionEntity.setValue(competition.competition.last_updated_on, forKey: "last_updated_on")
                competitionEntity.setValue(competition.competition.pretty_display_name, forKey: "pretty_display_name")
                competitionEntity.setValue(competition.competition.tiny_display_name, forKey: "tiny_display_name")
                
                for matchDay in competition.competition.matchdays {
                    self.syncCompetitionMatchDaysToCache(String(competition.competition.competition_id), matchDay: matchDay, privateMOC: privateMOC)
                }
                competitionEntity.setValue(competition.current_server_time, forKey: "lastUpdatedServerTime")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        
//        EFLCoreDataManager.sharedInstance.savePrivateContextWithCompletion { (success, error) in
//            print(success)
//        }
    }
    
    //Sync competition match days to cache
    func syncCompetitionMatchDaysToCache(competitionId: String, matchDay: EFLCompetitionMatchDayModel, privateMOC: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest(entityName: "CompetitionMatchdays")
        let predicate = NSPredicate(format: "matchday_id=%@", String(matchDay.matchday_id))
        
        fetchRequest.predicate = predicate
        
        
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                result.setValue(competitionId, forKey: "competition_id")
                result.setValue(matchDay.matchday_label, forKey: "matchday_label")
                result.setValue(matchDay.matchday_number, forKey: "matchday_number")
                result.setValue(matchDay.matchday_status, forKey: "matchday_status")
                
                for match in matchDay.matches {
                    self.syncCompetitionMatchesToCache(String(matchDay.matchday_id), match: match, privateMOC: privateMOC)
                }
            }
            else {
                let entity =  NSEntityDescription.entityForName("CompetitionMatchdays",
                                                                inManagedObjectContext:privateMOC)
                let matchDayEntity = NSManagedObject(entity: entity!,
                                                     insertIntoManagedObjectContext: privateMOC)
                
                matchDayEntity.setValue(competitionId, forKey: "competition_id")
                matchDayEntity.setValue(String(matchDay.matchday_id), forKey: "matchday_id")
                matchDayEntity.setValue(matchDay.matchday_label, forKey: "matchday_label")
                matchDayEntity.setValue(matchDay.matchday_number, forKey: "matchday_number")
                matchDayEntity.setValue(matchDay.matchday_status, forKey: "matchday_status")
                
                for match in matchDay.matches {
                    self.syncCompetitionMatchesToCache(String(matchDay.matchday_id), match: match, privateMOC: privateMOC)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //Sync competition match day matches to cache
    func syncCompetitionMatchesToCache(matchDayId: String, match: EFLCompetitionMatchModel, privateMOC: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest(entityName: "CompetitionMatches")
        let predicate = NSPredicate(format: "match_id=%@", String(match.match_id))
        
        fetchRequest.predicate = predicate
        
        
        do {
            if let result =
                try privateMOC.executeFetchRequest(fetchRequest).last {
                
                result.setValue(matchDayId, forKey: "matchday_id")
                result.setValue(match.away_team_image, forKey: "away_team_image")
                result.setValue(match.away_team_long_display_name, forKey: "away_team_long_display_name")
                result.setValue(match.home_team_image, forKey: "home_team_image")
                result.setValue(match.home_team_long_display_name, forKey: "home_team_long_display_name")
                result.setValue(match.start_time, forKey: "start_time")
                
            }
            else {
                let entity =  NSEntityDescription.entityForName("CompetitionMatches",
                                                                inManagedObjectContext:privateMOC)
                let matchEntity = NSManagedObject(entity: entity!,
                                                  insertIntoManagedObjectContext: privateMOC)
                
                matchEntity.setValue(matchDayId, forKey: "matchday_id")
                matchEntity.setValue(String(match.match_id), forKey: "match_id")
                matchEntity.setValue(match.away_team_image, forKey: "away_team_image")
                matchEntity.setValue(match.away_team_long_display_name, forKey: "away_team_long_display_name")
                matchEntity.setValue(match.home_team_image, forKey: "home_team_image")
                matchEntity.setValue(match.home_team_long_display_name, forKey: "home_team_long_display_name")
                matchEntity.setValue(match.start_time, forKey: "start_time")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
