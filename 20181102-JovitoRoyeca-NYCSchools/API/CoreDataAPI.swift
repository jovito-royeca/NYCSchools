//
//  CoreDataAPI.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 03.11.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import Sync
import PromiseKit

/*
 * Singleton class to handle Core Data operations
 */
class CoreDataAPI: NSObject {
    // MARK: - Shared Instance
    static let sharedInstance = CoreDataAPI()
    
    // MARK: Variables
    /*
     * Uses SyncDB to simplify mapping JSON to Core Data.
     * This is the main context of Core Data and is used for saving and retrieving data.
     */
    fileprivate var _dataStack:DataStack?
    var dataStack:DataStack? {
        get {
            if _dataStack == nil {
                _dataStack = DataStack(modelName: "Model")
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }
    
    /*
     * Save pending updates, if there is any.
     */
    func saveContext() {
        guard let dataStack = dataStack else {
            return
        }
        
        if dataStack.mainContext.hasChanges {
            do {
                try dataStack.mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*
     * Save JSON to Core Data
     */
    func saveSchools(json: [[String: Any]]) -> Promise<Void> {
        return Promise { seal  in
            let notifName = NSNotification.Name.NSManagedObjectContextObjectsDidChange
            var modSchools = [[String: Any]]()
            
            // add nameSection as the initial letter
            let letters = CharacterSet.letters
            for school in json {
                var t = [String: Any]()
                
                for (k,v) in school {
                    if k == "school_name" {
                        if let vName = v as? String {
                            var prefix = String(vName.prefix(1))
                            if prefix.rangeOfCharacter(from: letters) == nil {
                                prefix = "#"
                            }
                            t["nameSection"] = prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
                            t[k] = v
                        }
                    } else if k == "latitude" {
                        if let latitude = v as? Double {
                            t[k] = latitude
                        }
                    } else if k == "longitude" {
                        if let longitude = v as? Double {
                            t[k] = longitude
                        }
                    } else {
                        t[k] = v
                    }
                }
                
                modSchools.append(t)
            }
            
            let completion = {(backgroundContext: NSManagedObjectContext) in
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.changeNotification(_:)),
                                                       name: notifName,
                                                       object: backgroundContext)
                Sync.changes(modSchools,
                             inEntityNamed: "School",
                             predicate: nil,
                             parent: nil,
                             parentRelationship: nil,
                             inContext: backgroundContext,
                             operations: .all,
                             completion:  { error in
                                NotificationCenter.default.removeObserver(self, name:notifName,
                                                                          object: nil)
                                if let error = error {
                                    seal.reject(error)
                                } else {
                                    seal.fulfill(())
                                }
                            })
            }
            
            self.dataStack?.performInNewBackgroundContext(completion)
        }
    }
    
    /*
     * Save JSON to Core Data
     */
    func saveSATResults(json: [[String: Any]]) {
//        return Promise { seal  in
            let context = dataStack!.mainContext
            let request: NSFetchRequest<School> = School.fetchRequest()
            
            for satResult in json {
                if let dbn = satResult["dbn"] as? String,
                    let numOfSatTestTakers = satResult["num_of_sat_test_takers"] as? String,
                    let satCriticalReadingAvgScore = satResult["sat_critical_reading_avg_score"] as? String,
                    let satMathAvgScore = satResult["sat_math_avg_score"] as? String,
                    let satWritingAvgScore = satResult["sat_writing_avg_score"] as? String,
                    let schoolName = satResult["school_name"] as? String {
                
                    if let desc = NSEntityDescription.entity(forEntityName: "SATResult", in: context),
                        let s = NSManagedObject(entity: desc, insertInto: context) as? SATResult {
                        s.dbn = dbn
                        s.numOfSatTestTakers = numOfSatTestTakers
                        s.satCriticalReadingAvgScore = satCriticalReadingAvgScore
                        s.satMathAvgScore = satMathAvgScore
                        s.satWritingAvgScore = satWritingAvgScore
                        s.schoolName = schoolName
                        
                        // add school relationship
                        request.predicate = NSPredicate(format: "dbn = %@", dbn)
                        if let school = try! context.fetch(request).first {
                            s.school = school
                        }
                    }
                }
            }
            
            try! context.save()
//            seal.fulfill(())
//        }
    }

    /*
     * Listeners
     */
    @objc func changeNotification(_ notification: Notification) {
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] {
            if let set = updatedObjects as? NSSet {
                print("updatedObjects: \(set.count)")
            }
        }
        
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] {
            if let set = deletedObjects as? NSSet {
                print("deletedObjects: \(set.count)")
            }
        }
        
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] {
            if let set = insertedObjects as? NSSet {
                print("insertedObjects: \(set.count)")
            }
        }
    }
}
