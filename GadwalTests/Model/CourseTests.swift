//
//  CourseTests.swift
//  GadwalTests
//
//  Created by nader said on 02/10/2022.
//

import XCTest
@testable import Gadwal

class CourseTests: XCTestCase
{
    func testCourseInitWithWrongDictionary()
    {
        var course = Course([1:3])
        
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
        
        course = Course(["":""])
        
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
    
    func testCourseInitWithDictionary()
    {
        
        let dict =
        ["code" : [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ]] as NSDictionary
        
        let course = Course(dict)

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
    
    func testCourseToDictionary()
    {
        var course = Course(["":""])
        var dict =
        [
            "courseName" : "","credits" : 0,"passed" : true,"prerequisite" : "","required" : false,"secondPrerequisite" : "","taken" : false,"thirdPrerequisite" : "","type" : ""
        ] as NSDictionary
        XCTAssertEqual(course.courseDict, dict)
        
        
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        XCTAssertEqual(course.courseDict, dict)

        
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "","required" : true,"secondPrerequisite" : "","taken" : true,"thirdPrerequisite" : "","type" : "cType"
        ] as NSDictionary
        course = Course(courseCode: "code", courseName: "cName", type: "cType", credits: 3, required: true, taken: true, passed: true)
        XCTAssertEqual(course.courseDict, dict)

    }
    
    func testGetPreqArr()
    {
        //test 3 preq
        var dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ] as NSDictionary
        var course = Course(["code" : dict])
        var preArr = ["Pre","secPre","thrdPre"]
        XCTAssertEqual(course.getPreqArr(), preArr)
        
        //test 2 preq
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        preArr = ["Pre","secPre"]
        XCTAssertEqual(course.getPreqArr(), preArr)
        
        //test 1 preq
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "","taken" : true,"thirdPrerequisite" : "","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        preArr = ["Pre"]
        XCTAssertEqual(course.getPreqArr(), preArr)
        
        
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        preArr = ["Pre"]
        XCTAssertEqual(course.getPreqArr(), preArr)
        
        
        //test no preq
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "","required" : true,"secondPrerequisite" : "","taken" : true,"thirdPrerequisite" : "","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        preArr = []
        XCTAssertEqual(course.getPreqArr(), preArr)
        
        dict =
        [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ] as NSDictionary
        course = Course(["code" : dict])
        preArr = []
        XCTAssertEqual(course.getPreqArr(), preArr)
    }
}
