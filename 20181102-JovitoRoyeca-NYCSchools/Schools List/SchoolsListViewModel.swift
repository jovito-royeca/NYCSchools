//
//  SchoolsListViewModel.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import CoreData
import PromiseKit

class SchoolsListViewModel: NSObject {
    // MARK: variables
    var queryString = ""
    var searchCancelled = false
    
    private var _sectionIndexTitles = [String]()
    private var _sectionTitles = [String]()
    private var _fetchedResultsController: NSFetchedResultsController<School>?
    private var _sortDescriptors = [NSSortDescriptor(key: "schoolName", ascending: true)]
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func numberOfSections() -> Int {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        
        return sections.count
    }
    
    func sectionIndexTitles() -> [String]? {
        return _sectionIndexTitles
    }
    
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int {
        var sectionIndex = 0
        
        for i in 0..._sectionTitles.count - 1 {
            if _sectionTitles[i].hasPrefix(title) {
                sectionIndex = i
                break
            }
        }
        
        return sectionIndex
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        guard let fetchedResultsController = _fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return nil
        }
        
        return sections[section].name
    }
    
    // MARK: Custom methods
    func object(forRowAt indexPath: IndexPath) -> School {
        guard let fetchedResultsController = _fetchedResultsController else {
            fatalError("fetchedResultsController is nil")
        }
        return fetchedResultsController.object(at: indexPath)
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
        
        updateSections()
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
    
    private func updateSections() {
        guard let fetchedResultsController = _fetchedResultsController,
            let schools = fetchedResultsController.fetchedObjects,
            let sections = fetchedResultsController.sections else {
                return
        }
        
        _sectionIndexTitles = [String]()
        _sectionTitles = [String]()
        
        
        for school in schools {
            if let nameSection = school.nameSection {
                if !_sectionIndexTitles.contains(nameSection) {
                    _sectionIndexTitles.append(nameSection)
                }
            }
        }
        
        let count = sections.count
        if count > 0 {
            for i in 0...count - 1 {
                if let sectionTitle = sections[i].indexTitle {
                    _sectionTitles.append(sectionTitle)
                }
            }
        }
        
        _sectionIndexTitles.sort()
        _sectionTitles.sort()
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SchoolsListViewModel : NSFetchedResultsControllerDelegate {
    
}
