//
//  StudentTests.swift
//  GadwalTests
//
//  Created by nader said on 05/10/2022.
//

import XCTest
@testable import Gadwal

class StudentTests: XCTestCase
{
    var student : Student!
    
    override func setUp()
    {
        let course = Course(courseCode: "M111", courseName: "cName", type: "cType", credits: 4, required: true, taken: true, passed: true)
        let courseTypeStatus = CourseType(["type" : "cType","required" : true, "maxHours" : 20, "takenHours" : 4] as NSDictionary)
        
        student = Student(id: "stuID", name: "nader", department: "M_CS", email: "nader@icloud.com", subDepartments: ["M","CS"], studentCourses: [course], courseTypeStatus: [courseTypeStatus])
        student.credits = 4
    }
    
    func testStudentInitWithWrongDictionary()
    {
        student = Student([5:""])
        XCTAssertEqual(student.id, "")
        XCTAssertEqual(student.name, "")
        XCTAssertEqual(student.department, "")
        XCTAssertEqual(student.email, "")
        XCTAssertEqual(student.level, 1)
        XCTAssertEqual(student.credits, 0)
        XCTAssertEqual(student.subDepartments.count, 0)
        XCTAssertEqual(student.studentCourses.count, 0)
        XCTAssertEqual(student.courseTypeStatus.count, 0)

        student = Student(["studID":""])
        XCTAssertEqual(student.id, "studID")
        XCTAssertEqual(student.name, "")
        XCTAssertEqual(student.department, "")
        XCTAssertEqual(student.email, "")
        XCTAssertEqual(student.level, 1)
        XCTAssertEqual(student.credits, 0)
        XCTAssertEqual(student.subDepartments.count, 0)
        XCTAssertEqual(student.studentCourses.count, 0)
        XCTAssertEqual(student.courseTypeStatus.count, 0)
    }
    
    func testStudentInitWithDictionary()
    {
        let courseDict =
        ["code" : [
            "courseName" : "cName","credits" : 3,"passed" : true,"prerequisite" : "Pre","required" : true,"secondPrerequisite" : "secPre","taken" : true,"thirdPrerequisite" : "thrdPre","type" : "cType"
        ]] as NSDictionary
        
        let courseTypeStatusdict = ["type" : "myType","required" : true, "maxHours" : 20, "takenHours" : 5] as NSDictionary
        let courseTypeStatusArrDict = NSArray(array: [courseTypeStatusdict])
        
        let studentDict =
        ["stuID" :[
            Constants.kNAME:"nader",Constants.kDEPARTMENT:"M_CS",Constants.kLEVEL: 3,Constants.kEMAIL: "nadertawah@icloud.com", Constants.kCREDITS:90,Constants.kSUBDEPARTMENTS :["M","CS"],Constants.kSTUDENTCOURSES:courseDict,Constants.kCOURSETYPESTATUS:courseTypeStatusArrDict
        ]] as NSDictionary
        
        student = Student(studentDict)
        
        XCTAssertEqual(student.id, "stuID")
        XCTAssertEqual(student.name, "nader")
        XCTAssertEqual(student.department, "M_CS")
        XCTAssertEqual(student.email, "nadertawah@icloud.com")
        XCTAssertEqual(student.level, 3)
        XCTAssertEqual(student.credits, 90)
        XCTAssertEqual(student.subDepartments.count, 2)
        XCTAssertEqual(student.studentCourses.count, 1)
        XCTAssertEqual(student.courseTypeStatus.count, 1)
    }
    
    func testCalculateLevel()
    {
        student.calculateLevel()
        XCTAssertEqual(student.level, 1)
        
        student.credits = 37
        student.calculateLevel()
        XCTAssertEqual(student.level, 2)
        
        student.credits = 75
        student.calculateLevel()
        XCTAssertEqual(student.level, 3)
        
        student.credits = 110
        student.calculateLevel()
        XCTAssertEqual(student.level, 4)
        
        student.credits = 200
        student.calculateLevel()
        XCTAssertEqual(student.level, 4)
    }
    
    func testCalculateCredits()
    {
        XCTAssertEqual(student.credits, 4)
        
        student.courseTypeStatus.append(CourseType(["type" : "cType2","required" : true, "maxHours" : 50, "takenHours" : 35] as NSDictionary))
        student.calculateCredits()
        XCTAssertEqual(student.credits, 39)
        
        student.courseTypeStatus.append(CourseType(["type" : "متطلبات جامعة","required" : true, "maxHours" : 50, "takenHours" : 35] as NSDictionary))
        student.calculateCredits()
        XCTAssertEqual(student.credits, 39)
    }
    
    
    func testRebuildTypes()
    {
        XCTAssertEqual(student.credits, 4)

        student.courseTypeStatus.append(CourseType(["type" : "cType2","required" : false, "maxHours" : 50, "takenHours" : 35] as NSDictionary))
        student.studentCourses.append(Course(courseCode: "M222", courseName: "cName", type: "cType2", credits: 3, required: false, taken: true, passed: true))
        
        student.rebuildStats()
        XCTAssertEqual(student.credits, 7)
        
        
        for i in student.studentCourses.indices
        {
            if student.studentCourses[i].courseCode == "M222"
            {
                student.studentCourses[i].passed = false
                break
            }
        }
        student.rebuildStats()
        XCTAssertEqual(student.credits, 4)
    }
    
    func testStudentToDictionary()
    {
        let courseDict =
        ["M111" : [
            "courseName" : "cName","credits" : 4,"passed" : true,"prerequisite" : "","required" : true,"secondPrerequisite" : "","taken" : true,"thirdPrerequisite" : "","type" : "cType"
        ]] as NSDictionary
        
        let courseTypeStatusdict = ["type" : "cType","required" : true, "maxHours" : 20, "takenHours" : 4] as NSDictionary
        let courseTypeStatusArrDict = NSArray(array: [courseTypeStatusdict])
        
        let studentDict =
        [
            Constants.kNAME:"nader",Constants.kDEPARTMENT:"M_CS",Constants.kLEVEL: 1,Constants.kEMAIL: "nader@icloud.com", Constants.kCREDITS:4,Constants.kSUBDEPARTMENTS :["M","CS"],Constants.kSTUDENTCOURSES:courseDict,Constants.kCOURSETYPESTATUS:courseTypeStatusArrDict
        ] as NSDictionary
        
        XCTAssertEqual(studentDict, student.studentDictionary)
    }
}
