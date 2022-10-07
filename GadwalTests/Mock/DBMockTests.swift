//
//  DBMockTests.swift
//  GadwalTests
//
//  Created by nader said on 07/10/2022.
//

import XCTest
@testable import Gadwal
class DBMockTests: XCTestCase
{

    var db = DBMock()
    
    func testGetSubDepartments()
    {
        db.getSubDepartments(department: "")
        {
            XCTAssertEqual($0, ["M","CS"])
        }
    }
    

    func testGetDepartmentCourses()
    {
        db.getDepartmentCourses(department: "")
        {
            XCTAssertEqual($0.count, 8)
        }
    }
    
    func testGetDepartmentCourseTypeStatus()
    {
        db.getDepartmentCourseTypeStatus(department: "")
        {
            XCTAssertEqual($0.count, 2)
        }
    }
    
    func testGetStudent()
    {
        db.getStudent
        {
            student in
            XCTAssertEqual(student.studentCourses.count, 8)
            XCTAssertEqual(student.courseTypeStatus.count, 2)
            XCTAssertEqual(student.id, "stuID")
            XCTAssertEqual(student.name, "nader")
        }
    }
    
    func testGetAVCourses()
    {
        db.getAVCourses(department: "")
        {
            XCTAssertEqual($0.count, 8)
        }
    }
}
