//
//  DBMock.swift
//  GadwalTests
//
//  Created by nader said on 06/10/2022.
//
import Foundation
@testable import Gadwal

class DBMock : DBProtocol
{
    func getSubDepartments(department:String, completion : @escaping ([String])->())
    {
        completion(["M","CS"])
    }
    
    func getDepartmentCourses(department:String, completion : @escaping ([Course])->())
    {
        let courses : [Course] =
        [
            .init(courseCode: "code1", courseName: "cName", type: "cType", credits: 3, required: true, taken: false, passed: true),
            .init(courseCode: "code2", courseName: "cName2", type: "cType2", credits: 4, required: false, taken: false, passed: true),
            .init(courseCode: "code3", courseName: "cName3", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code12", courseName: "cName3", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code14", courseName: "cName14", type: "cType2", credits: 15, required: false, taken: false, passed: true),
            .init(courseCode: "code13", courseName: "cName13", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code15", courseName: "cName15", type: "cType2", credits: 10, required: false, taken: false, passed: true),
            .init(courseCode: "code111", courseName: "cName111", type: "cType", credits: 5, required: false, taken: false, passed: true),
        ]
        
        
        completion(courses)
    }
    
    func getDepartmentCourseTypeStatus(department:String, completion : @escaping ([CourseType])->())
    {
        let dict = ["type" : "cType","required" : true, "maxHours" : 10, "takenHours" : 3] as NSDictionary
        let dict2 = ["type" : "cType2","required" : false, "maxHours" : 15, "takenHours" : 4] as NSDictionary
        completion([CourseType(dict),CourseType(dict2)])
    }
    
    func getStudent(completion : @escaping (Student)->())
    {
        let courses : [Course] =
        [
            .init(courseCode: "code1", courseName: "cName", type: "cType", credits: 3, required: true, taken: true, passed: true),
            .init(courseCode: "code2", courseName: "cName2", type: "cType2", credits: 4, required: false, taken: true, passed: false),
            .init(courseCode: "code3", courseName: "cName3", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code12", courseName: "cName12", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code14", courseName: "cName14", type: "cType2", credits: 15, required: false, taken: true, passed: true),
            .init(courseCode: "code13", courseName: "cName13", type: "cType2", credits: 1, required: false, taken: false, passed: true),
            .init(courseCode: "code15", courseName: "cName15", type: "cType", credits: 10, required: false, taken: false, passed: true),
            .init(courseCode: "code111", courseName: "cName111", type: "cType", credits: 5, required: true, taken: false, passed: true),

        ]
        courses[3].prerequisite = "code2"
        courses[5].prerequisite = "code1"

        let dict = ["type" : "cType","required" : true, "maxHours" : 10, "takenHours" : 3] as NSDictionary
        let dict2 = ["type" : "cType2","required" : false, "maxHours" : 15, "takenHours" : 4] as NSDictionary
        
        var student = Student(id: "stuID", name: "nader", department: "M_CS", email: "nadertawah@icloud.com", subDepartments: ["M","CS"], studentCourses: courses, courseTypeStatus: [CourseType(dict),CourseType(dict2)])
        
        student.rebuildStats()
        
        completion(student)
    }
    
    func setStudent(_ student:Student)
    {
        
    }
    
    func getAVCourses(department : String,completion : @escaping ([AvailableCourse]) -> ())
    {
        let courses : [AvailableCourse] =
        [
            .init(id: 0, courseCode: "code99", courseName: "cName99", credit: 3, from: 15, to: 16, day: "mon", prof: "nader", desiredIndex: 1, type: "cType"),
            .init(id: 4, courseCode: "code15", courseName: "cName15", credit: 10, from: 15, to: 16, day: "sunday", prof: "nader", desiredIndex: 1, type: "cType2"),
            .init(id: 1, courseCode: "code1", courseName: "cName", credit: 3, from: 15, to: 16, day: "mon", prof: "nader", desiredIndex: 1, type: "cType"),
            .init(id: 2, courseCode: "code2", courseName: "cName2", credit: 4, from: 15, to: 16, day: "sun", prof: "nader", desiredIndex: 1, type: "cType2"),
            .init(id: 3, courseCode: "code3", courseName: "cName3", credit: 1, from: 15, to: 16, day: "sat", prof: "nader", desiredIndex: 1, type: "cType2"),
            .init(id: 5, courseCode: "code12", courseName: "cName12", credit: 1, from: 17, to: 18, day: "sunday", prof: "nader", desiredIndex: 1, type: "cType2"),
            .init(id: 6, courseCode: "code13", courseName: "cName13", credit: 1, from: 15, to: 16, day: "thu", prof: "nader", desiredIndex: 1, type: "cType2"),
            .init(id: 7, courseCode: "code111", courseName: "cName111", credit: 5, from: 10, to: 11, day: "mon", prof: "nader", desiredIndex: 1, type: "cType"),
        ]
        
        completion(courses)
    }
    
}

