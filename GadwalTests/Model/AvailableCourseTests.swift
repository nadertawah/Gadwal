//
//  AvailableCourseTests.swift
//  GadwalTests
//
//  Created by nader said on 05/10/2022.
//

import XCTest
@testable import Gadwal

class AvailableCourseTests: XCTestCase
{

    func testAvailableCourseInitWithWrongDictionary()
    {
        var course = AvailableCourse(["":""])
        
        XCTAssertEqual(course.id, 0)
        XCTAssertEqual(course.from, 0)
        XCTAssertEqual(course.to,0)
        XCTAssertEqual(course.day,"")
        XCTAssertEqual(course.prof, "")
        
        XCTAssertEqual(course.type, "")
        XCTAssertEqual(course.courseCode,"")
        XCTAssertEqual(course.courseName,"")
        XCTAssertEqual(course.prerequisite, "")
        XCTAssertEqual(course.secondPrerequisite, "")
        XCTAssertEqual(course.thirdPrerequisite, "")
        
        XCTAssertEqual(course.required, false)
        XCTAssertEqual(course.taken, false)
        XCTAssertEqual(course.passed, true)

        XCTAssertEqual(course.credits, 0)
        
        //test with correct id but wrong course dictioanry
        course = AvailableCourse([10:""])
        XCTAssertEqual(course.id, 10)
        XCTAssertEqual(course.from, 0)
        XCTAssertEqual(course.to,0)
        XCTAssertEqual(course.day,"")
        XCTAssertEqual(course.prof, "")
        
        XCTAssertEqual(course.type, "")
        XCTAssertEqual(course.courseCode,"")
        XCTAssertEqual(course.courseName,"")
        XCTAssertEqual(course.prerequisite, "")
        XCTAssertEqual(course.secondPrerequisite, "")
        XCTAssertEqual(course.thirdPrerequisite, "")
        
        XCTAssertEqual(course.required, false)
        XCTAssertEqual(course.taken, false)
        XCTAssertEqual(course.passed, true)

        XCTAssertEqual(course.credits, 0)
    }
    
    func testAvailableCourseInitWithDictionary()
    {
        let courseDict =
        ["code":[
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType", "from": 13 , "to" : 14, "day" : "sunday", "prof" : "nader"
        ]] as NSDictionary
        
        let dict = [22:courseDict] as NSDictionary
        
        let course = AvailableCourse(dict)
        
        XCTAssertEqual(course.id, 22)
        XCTAssertEqual(course.from, 13)
        XCTAssertEqual(course.to,14)
        XCTAssertEqual(course.day,"sunday")
        XCTAssertEqual(course.prof, "nader")
        
        
        XCTAssertEqual(course.type, "cType")
        XCTAssertEqual(course.courseCode,"code")
        XCTAssertEqual(course.courseName,"cName")
        XCTAssertEqual(course.prerequisite, "Pre")
        XCTAssertEqual(course.secondPrerequisite, "secPre")
        XCTAssertEqual(course.thirdPrerequisite, "thrdPre")

        XCTAssertEqual(course.required, true)
        XCTAssertEqual(course.taken, true)
        XCTAssertEqual(course.passed, true)

        XCTAssertEqual(course.credits, 3)
    }
    
    func testAvailableCourseInit()
    {
        let course = AvailableCourse(id: 22, courseCode: "code", courseName: "cName", credit: 3, from: 15, to: 16, day: "monday", prof: "nader", desiredIndex: 1, type: "cType")
        XCTAssertEqual(course.id, 22)
        XCTAssertEqual(course.from, 15)
        XCTAssertEqual(course.to,16)
        XCTAssertEqual(course.day,"monday")
        XCTAssertEqual(course.prof, "nader")
        
        
        XCTAssertEqual(course.type, "cType")
        XCTAssertEqual(course.courseCode,"code")
        XCTAssertEqual(course.courseName,"cName")
        XCTAssertEqual(course.prerequisite,nil)
        XCTAssertEqual(course.secondPrerequisite, nil)
        XCTAssertEqual(course.thirdPrerequisite, nil)

        XCTAssertEqual(course.required, false)
        XCTAssertEqual(course.taken, false)
        XCTAssertEqual(course.passed, false)

        XCTAssertEqual(course.credits, 3)
    }
    
    func testAvailableCourseLevel()
    {
        let course = AvailableCourse(id: 0, courseCode: "M111", courseName: "", credit: 0, from: 0, to: 0, day: "", prof: "", desiredIndex: 0, type: "")
        XCTAssertEqual(course.courseLevel, 1)

        course.courseCode = "M000"
        XCTAssertEqual(course.courseLevel, 3)

        course.courseCode = "M4000"
        XCTAssertEqual(course.courseLevel, 4)
        
        course.courseCode = "M"
        XCTAssertEqual(course.courseLevel, -1)
        
    }
    
    func testAvailableCourseIsConflicted()
    {
        let course1 = AvailableCourse(id: 0, courseCode: "M000", courseName: "", credit: 0, from: 1, to: 2, day: "", prof: "", desiredIndex: 0, type: "")
        let course2 = AvailableCourse(id: 0, courseCode: "C000", courseName: "", credit: 0, from: 4, to: 5, day: "", prof: "", desiredIndex: 0, type: "")
        XCTAssertTrue(course1.isConflicted(with: course2))
        
        course1.courseCode = "M111"
        course2.courseCode = "M211"

        course1.day = "غير محدد"
        XCTAssertFalse(course1.isConflicted(with: course2))

        course2.day = "غير محدد"
        XCTAssertFalse(course1.isConflicted(with: course2))

        course1.day = "sunday"
        course2.day = "sunday"
        XCTAssertFalse(course1.isConflicted(with: course2))

        course1.from = 4
        course1.to = 5
        course2.from = 4
        course2.to = 6
        XCTAssertTrue(course1.isConflicted(with: course2))

        course1.from = 4
        course1.to = 5
        course2.from = 4.5
        course2.to = 6
        XCTAssertTrue(course1.isConflicted(with: course2))
        
        course1.from = 4.5
        course1.to = 5
        course2.from = 4
        course2.to = 6
        XCTAssertTrue(course1.isConflicted(with: course2))
        
        course1.from = 4
        course1.to = 7
        course2.from = 4.5
        course2.to = 6.5
        XCTAssertTrue(course1.isConflicted(with: course2))
        
        course2.from = 4
        course2.to = 7
        course1.from = 4.5
        course1.to = 6.5
        XCTAssertTrue(course1.isConflicted(with: course2))
    }
}
