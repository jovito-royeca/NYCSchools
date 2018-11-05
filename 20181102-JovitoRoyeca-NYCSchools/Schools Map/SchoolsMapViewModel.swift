//
//  SchoolsMapViewModel.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import CoreData

class SchoolsMapViewModel: NSObject {
    // MARK: variables
    var queryString = ""
    
    private var _fetchedResultsController: NSFetchedResultsController<School>?
    private var _sortDescriptors = [NSSortDescriptor(key: "schoolName", ascending: true)]
    
    // MARK: Custom methods
    func object(forName name: String, latitude: Double, lontitude: Double) -> School? {
        let context = CoreDataAPI.sharedInstance.dataStack!.viewContext
        let request: NSFetchRequest<School> = School.fetchRequest()
        
        request.predicate = NSPredicate(format: "schoolName = %@ AND latitude = %lf AND longitude = %lf", name, latitude, lontitude)
        request.sortDescriptors = _sortDescriptors
        return try! context.fetch(request).first
    }
    
    func allObjects() -> [School]? {
        guard let fetchedResultsController = _fetchedResultsController else {
            return nil
        }
        return fetchedResultsController.fetchedObjects
    }
    
    func isEmpty() -> Bool {
        guard let objects = allObjects() else {
            return false
        }
        return objects.count == 0
    }
    
    /*
     * Fetches data from SQLite. Note that queryString matches data to fetch
     */
    func fetchData() {
        let request: NSFetchRequest<School> = School.fetchRequest()
        let count = queryString.count
        
        if count > 0 {
            if count == 1 {
                request.predicate = NSPredicate(format: "schoolName BEGINSWITH[cd] %@", queryString, queryString)
            } else {
                request.predicate = NSPredicate(format: "schoolName CONTAINS[cd] %@", queryString, queryString)
            }
        }
        request.sortDescriptors = _sortDescriptors
        _fetchedResultsController = getFetchedResultsController(with: request)
    }
    
    // MARK: Private methods
    private func getFetchedResultsController(with fetchRequest: NSFetchRequest<School>?) -> NSFetchedResultsController<School> {
        let context = CoreDataAPI.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<School>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = School.fetchRequest()
            request!.sortDescriptors = _sortDescriptors
        }
        
        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "nameSection",
                                             cacheName: nil)
        
        // Configure Fetched Results Controller
        frc.delegate = self
        
        // perform fetch
        do {
            try frc.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return frc
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SchoolsMapViewModel : NSFetchedResultsControllerDelegate {
    
}
