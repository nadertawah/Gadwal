//
//  Student.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import Foundation

struct Student
{
    //MARK: - Var(s)
    var id: String
    var name: String
    var department: String
    var email: String
    var credits: Float
    var level: Int16
    var subDepartments: [String]
    var studentCourses: [Course]
    var courseTypeStatus: [CourseType]
    
    var studentDictionary : NSDictionary
    {
        //GET COURSES DICT
        let coursesDict = NSMutableDictionary()
        for course in studentCourses
        {
            coursesDict[course.courseCode] = course.courseDict
        }
        
        // GET COURSES TYPE STATUS DICT
        let coursesTypeDictArr = courseTypeStatus.map { $0.typesDict}
        
        return NSDictionary(objects: [name, department, email, credits, level, subDepartments, coursesDict ,coursesTypeDictArr ],
                            forKeys: [Constants.kNAME as NSCopying, Constants.kDEPARTMENT as NSCopying, Constants.kEMAIL as NSCopying, Constants.kCREDITS as NSCopying, Constants.kLEVEL as NSCopying,Constants.kSUBDEPARTMENTS as NSCopying,Constants.kSTUDENTCOURSES as NSCopying,Constants.kCOURSETYPESTATUS as NSCopying])
    }
    
    init(id: String, name: String, department: String, email: String,subDepartments:[String],studentCourses: [Course],courseTypeStatus: [CourseType])
    {
        self.id = id
        self.name = name
        self.department = department
        self.email = email
        self.subDepartments = subDepartments
        self.studentCourses = studentCourses
        self.courseTypeStatus = courseTypeStatus
        credits = 0
        level = 1
    }
    
    init(_ dictionary : NSDictionary)
    {
        if let id = dictionary.allKeys.first as? String
        {
            self.id = id
        }
        else {self.id = ""}
        
        let studentDict = dictionary[id] as! NSDictionary
        
        self.name = studentDict[Constants.kNAME] as? String ?? ""
        self.credits = studentDict[Constants.kCREDITS] as? Float ?? 0
        self.department = studentDict[Constants.kDEPARTMENT] as? String ?? ""
        self.email = studentDict[Constants.kEMAIL] as? String ?? ""
        self.level = studentDict[Constants.kLEVEL] as? Int16 ?? 1

        self.subDepartments = studentDict[Constants.kSUBDEPARTMENTS] as? [String] ?? []
        
        studentCourses = []
        if let studentCourses = studentDict[Constants.kSTUDENTCOURSES] as? NSDictionary
        {
            for item in studentCourses
            {
                self.studentCourses.append(Course([item.key:item.value]))
            }
        }

        self.courseTypeStatus = []
        if let courseTypeStatus = studentDict[Constants.kCOURSETYPESTATUS] as? [NSDictionary]
        {
            self.courseTypeStatus = courseTypeStatus.map{CourseType($0)}
        }
        
    }
    
    //MARK: - Helper Funcs
    
    mutating func rebuildStats()
    {
        rebuildTypes()
        calculateCredits()
        calculateLevel()
        
    }
    
    mutating func rebuildTypes()
    {
        for index in 0..<courseTypeStatus.count   //reset
        {
            courseTypeStatus[index].takenHours = 0
        }
        
        for CourseIndex in 0..<studentCourses.count
        {
            if(studentCourses[CourseIndex].taken && studentCourses[CourseIndex].passed)
            {
                for typeIndex in 0..<courseTypeStatus.count
                {
                    if(studentCourses[CourseIndex].type == courseTypeStatus[typeIndex].type && studentCourses[CourseIndex].required == courseTypeStatus[typeIndex].required)
                    {
                        courseTypeStatus[typeIndex].takenHours += studentCourses[CourseIndex].credits
                        break
                    }
                }
            }
        }
    }
    
    mutating func calculateCredits()
    {
        credits = 0
        for index in 0..<courseTypeStatus.count
        {
            if(courseTypeStatus[index].type != "متطلبات جامعة" )
            {
                credits += courseTypeStatus[index].takenHours
            }
        }
    }
    
    mutating func calculateLevel()
    {
        if (credits >= 108){ level = 4}
        else if (credits >= 72) {level = 3}
        else if (credits >= 36) {level = 2}
        else {level = 1}
    }
}
