//
//  School+CoreDataProperties.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 03/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//
//

import Foundation
import CoreData


extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var academicOpportunities1: String?
    @NSManaged public var academicOpportunities2: String?
    @NSManaged public var admissionPriority11: String?
    @NSManaged public var admissionPriority21: String?
    @NSManaged public var admissionPriority31: String?
    @NSManaged public var attendanceRate: Double
    @NSManaged public var bbl: String?
    @NSManaged public var bin: String?
    @NSManaged public var boro: String?
    @NSManaged public var borough: String?
    @NSManaged public var buildingCode: String?
    @NSManaged public var bus: String?
    @NSManaged public var censusTract: String?
    @NSManaged public var city: String?
    @NSManaged public var code1: String?
    @NSManaged public var communityBoard: String?
    @NSManaged public var communityDistrict: String?
    @NSManaged public var directions1: String?
    @NSManaged public var ellPrograms: String?
    @NSManaged public var faxNumber: String?
    @NSManaged public var finalGrades: String?
    @NSManaged public var grade9GEApplicants1: String?
    @NSManaged public var grade9GEApplicantsPerSear1: String?
    @NSManaged public var grade9GEFilledFlag1: Bool
    @NSManaged public var grade9SWDApplicants1: String?
    @NSManaged public var grade9SWDApplicantsPerSeat1: String?
    @NSManaged public var grade9SWDFilledFlag1: Bool
    @NSManaged public var grades2018: String?
    @NSManaged public var latitude: Double
    @NSManaged public var location: String?
    @NSManaged public var longitude: Double
    @NSManaged public var method1: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var neighborhood: String?
    @NSManaged public var nta: String?
    @NSManaged public var offerRate1: String?
    @NSManaged public var overviewParagraph: String?
    @NSManaged public var pctSTUEnoughVariety: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var primaryAddressLine1: String?
    @NSManaged public var program1: String?
    @NSManaged public var requirement11: String?
    @NSManaged public var requirement21: String?
    @NSManaged public var requirement31: String?
    @NSManaged public var requirement41: String?
    @NSManaged public var requirement51: String?
    @NSManaged public var school10thSeats: String?
    @NSManaged public var schoolAccessibilityDescription: String?
    @NSManaged public var schoolEmail: String?
    @NSManaged public var schoolName: String?
    @NSManaged public var schoolSports: String?
    @NSManaged public var seats9GE1: String?
    @NSManaged public var seats9SWD1: String?
    @NSManaged public var seats101: String?
    @NSManaged public var stateCode: String?
    @NSManaged public var subway: String?
    @NSManaged public var totalStudents: String?
    @NSManaged public var website: String?
    @NSManaged public var zip: String?
    @NSManaged public var dbn: String?
    @NSManaged public var satResult: SATResult?

}
