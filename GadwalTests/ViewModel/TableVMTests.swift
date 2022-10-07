//
//  TableVMTests.swift
//  GadwalTests
//
//  Created by nader said on 07/10/2022.
//

import XCTest
@testable import Gadwal

class TableVMTests: XCTestCase
{

    var VM : TableVM!
    
    override func setUp()
    {
        let db = DBMock()
        db.getStudent
        {[weak self]
            student in
            self?.VM = TableVM(student: student , dbInstance: db)
        }
    }

    func testGetCourses()
    {
        VM.availableCourses.removeAll()
        XCTAssertEqual(VM.availableCourses.count, 0)
        VM.getCourses()
        XCTAssertEqual(VM.availableCourses.count, 1)

    }
}
