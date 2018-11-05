//
//  SchoolDetailsViewModel.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

class SchoolDetailsViewModel: NSObject {
    enum Sections: Int {
        case school
        case satResults
        
        var description : String {
            switch self {
            // Use Internationalization, as appropriate.
            case .school: return "School"
            case .satResults: return "SAT Results"
            }
        }
        
        static var count: Int {
            return 2
        }
    }
    
    enum SchoolDetails: Int {
        case name
        case overview
        case address
        case phone
        case website

        var description : String {
            switch self {
            // Use Internationalization, as appropriate.
            case .name: return "Name"
            case .overview: return "Overview"
            case .address: return "Address"
            case .phone: return "Phone"
            case .website: return "Website"
            }
        }

        static var count: Int {
            return 5
        }
    }

    enum SATDetails: Int {
        case takers
        case mathematics
        case reading
        case writing

        var description : String {
            switch self {
            // Use Internationalization, as appropriate.
            case .takers: return "Number of Takers"
            case .mathematics: return "Mathematics Avg Score"
            case .reading: return "Reading Avg Score"
            case .writing: return "Writing Avg Score"
            }
        }

        static var count: Int {
            return 4
        }
    }
    
    // MARK: variables
    private var _school: School?

    // MARK: Initializer
    init(withSchool school: School) {
        _school = school
    }
    
    // MARK: Custom methods
    func name() -> String? {
        return _school!.schoolName
    }
    
    func overview() -> String? {
        return _school!.overviewParagraph
    }
    
    func address() -> String? {
        if let line1 = _school!.primaryAddressLine1,
            let city = _school!.city,
            let state = _school!.stateCode,
            let zip = _school!.zip {
            return "\(line1) \(city), \(state) \(zip)"
        }
        
        return nil
    }
    
    func phone() -> String? {
        return _school!.phoneNumber
    }
    
    func website() -> String? {
        return _school!.website
    }
    
    func numberOfSATTakers() -> String? {
        guard let school = _school,
            let satResult = school.satResult,
            let takers = satResult.numOfSatTestTakers else {
            return nil
        }
        
        return takers
    }
    
    func mathScore() -> String? {
        guard let school = _school,
            let satResult = school.satResult,
            let mathResult = satResult.satMathAvgScore else {
            return nil
        }
        
        return mathResult
    }
    
    func readingScore() -> String? {
        guard let school = _school,
            let satResult = school.satResult,
            let readingResult = satResult.satCriticalReadingAvgScore else {
            return nil
        }
        
        return readingResult
    }
    
    func writingScore() -> String? {
        guard let school = _school,
            let satResult = school.satResult,
            let writingResult = satResult.satWritingAvgScore else {
            return nil
        }
        
        return writingResult
    }
    
    // MARK: UITableView methods
    func numberOfRows(inSection section: Int) -> Int {
        switch section {
        case Sections.school.rawValue:
            return SchoolDetails.count
        case Sections.satResults.rawValue:
            return SATDetails.count
        default:
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        return Sections.count
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        switch section {
        case Sections.school.rawValue:
            return nil
        case Sections.satResults.rawValue:
            return Sections.satResults.description
        default:
            return nil
        }
    }
}
