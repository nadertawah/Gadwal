//
//  StudentInfoVMTests.swift
//  GadwalTests
//
//  Created by nader said on 06/10/2022.
//

import XCTest
@testable import Gadwal

class StudentInfoVMTests: XCTestCase
{
    var VM : StudentInfoVM!
    
    override func setUp()
    {
        VM = StudentInfoVM(dbInstance: DBMock())
    }
    
    func testGetStudent()
    {
        VM.getStudent()
        XCTAssertEqual(VM.student.name, "nader")
    }
    
    func testSaveStudent()
    {
        XCTAssertEqual(VM.student.credits, 18)
        VM.student.studentCourses[0].passed = false
        VM.saveStudent()
        XCTAssertEqual(VM.student.credits, 15)

    }
}
