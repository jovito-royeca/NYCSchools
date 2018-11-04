//
//  SATResult+CoreDataProperties.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 03/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//
//

import Foundation
import CoreData


extension SATResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATResult> {
        return NSFetchRequest<SATResult>(entityName: "SATResult")
    }

    @NSManaged public var numOfSatTestTakers: String?
    @NSManaged public var satCriticalReadingAvgScore: String?
    @NSManaged public var satMathAvgScore: String?
    @NSManaged public var satWritingAvgScore: String?
    @NSManaged public var schoolName: String?
    @NSManaged public var dbn: String?
    @NSManaged public var school: SATResult?

}
