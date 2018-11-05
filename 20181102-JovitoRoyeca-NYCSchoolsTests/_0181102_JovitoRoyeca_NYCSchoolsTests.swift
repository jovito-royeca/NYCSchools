//
//  _0181102_JovitoRoyeca_NYCSchoolsTests.swift
//  20181102-JovitoRoyeca-NYCSchoolsTests
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import XCTest
import CoreData
import PromiseKit
@testable import _0181102_JovitoRoyeca_NYCSchools

class _0181102_JovitoRoyeca_NYCSchoolsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchAndSaveData() {
        if schoolsCount() <= 0 && satResultsCount() <= 0 {
            let _ = self.expectation(description: "testDaveData")
            let webService = WebServiceAPI()
            
            firstly {
                when(fulfilled: webService.fetchSchools(), webService.fetchSATResults())
            }.done { schools, satResults in
                XCTAssert(schools.count > 0)
                XCTAssert(satResults.count > 0)
                self.saveData(schools: schools, satResults: satResults)
            }.catch { error in
                print("\(error)")
                XCTFail()
            }
            
            self.waitForExpectations(timeout: 10.0, handler: nil)
        }
    }
 
    func saveData(schools: [[String: Any]], satResults: [[String: Any]]) {
        firstly {
            CoreDataAPI.sharedInstance.saveSchools(json: schools)
        }.done {
            CoreDataAPI.sharedInstance.saveSATResults(json: satResults)
            XCTAssert(self.schoolsCount() > 0)
            XCTAssert(self.satResultsCount() > 0)
        }.catch { error in
            print("\(error)")
            XCTFail()
        }
    }
    
    func schoolsCount() -> Int {
        let context = CoreDataAPI.sharedInstance.dataStack!.viewContext
        let request: NSFetchRequest<School> = School.fetchRequest()
        
        return try! context.fetch(request).count
    }
    
    func satResultsCount() -> Int {
        let context = CoreDataAPI.sharedInstance.dataStack!.viewContext
        let request: NSFetchRequest<SATResult> = SATResult.fetchRequest()
        
        return try! context.fetch(request).count
    }
}
