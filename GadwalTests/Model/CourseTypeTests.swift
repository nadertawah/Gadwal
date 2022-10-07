//
//  CourseTypeTests.swift
//  GadwalTests
//
//  Created by nader said on 02/10/2022.
//

import XCTest
@testable import Gadwal

class CourseTypeTests: XCTestCase
{
    func testCourseTypeInitWithWrongDictionary()
    {
        let type = CourseType(["":""])
        XCTAssertEqual(type.type, "")
        XCTAssertEqual(type.required, false)
        XCTAssertEqual(type.takenHours,0)
        XCTAssertEqual(type.maxHours, 0)
    }
    
    func testCourseTypeInitWithDictionary()
    {
        let dict = ["type" : "myType","required" : true, "maxHours" : 20, "takenHours" : 5] as NSDictionary
        let type = CourseType(dict)
        
        XCTAssertEqual(type.type, "myType")
        XCTAssertEqual(type.required, true)
        XCTAssertEqual(type.takenHours,5)
        XCTAssertEqual(type.maxHours, 20)
    }
    
    func testCourseTypeToDictionary()
    {
        var type = CourseType(["":""])
        var dict = ["type" : "","required" : false, "maxHours" : 0, "takenHours" : 0] as NSDictionary
        
        XCTAssertEqual(type.typesDict, dict)
        
        
        dict = ["type" : "myType","required" : true, "maxHours" : 20, "takenHours" : 5] as NSDictionary
        type = CourseType(dict)

        XCTAssertEqual(type.typesDict, dict)
    }
}
