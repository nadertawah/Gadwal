//
//  FireBaseExt.swift
//  Gadwal
//
//  Created by nader said on 12/09/2022.
//

import Foundation

extension FireBaseDB
{
    func getSubDepartments(department:String, completion : @escaping ([String])->())
    {
        FireBaseDB.sharedInstance.DBref.child(Constants.kDEPARTMENTS).child(department).child(Constants.kSUBDEPARTMENTS)
            .observeSingleEvent(of: .value)
        {
            DataSnapshot in
            if let strArr = DataSnapshot.value as? [String]
            {
                completion(strArr)
            }
            else
            {
                completion([])
            }
        }
    }
    
    func getDepartmentCourses(department:String, completion : @escaping ([Course])->())
    {
        FireBaseDB.sharedInstance.DBref.child(Constants.kDEPARTMENTS).child(department).child(Constants.kCOURSES)
            .observeSingleEvent(of: .value)
        {
            DataSnapshot in
            
            guard let coursesDict = DataSnapshot.value as? NSDictionary else{return}
            
            var courses = [Course]()
            
            for (key,value) in coursesDict
            {
                courses.append(Course([key:value]))
            }
            completion(courses)
            
        }
    }
    
    
    func getDepartmentCourseTypeStatus(department:String, completion : @escaping ([CourseType])->())
    {
        FireBaseDB.sharedInstance.DBref.child(Constants.kDEPARTMENTS).child(department).child(Constants.kCOURSETYPESTATUS)
            .observeSingleEvent(of: .value)
        {
            DataSnapshot in
            guard let coursesTypesDictArr = DataSnapshot.value as? NSArray else{return}
            
            var courseTypes = [CourseType]()
            
            for item in coursesTypesDictArr
            {
                courseTypes.append(CourseType(item as! NSDictionary))
            }
            completion(courseTypes)
        }
    }
    
    
    func getStudent(completion : @escaping (Student)->())
    {
        FireBaseDB.sharedInstance.DBref.child(Constants.kSTUDENTS).child(Helper.getCurrentUserID())
            .observeSingleEvent(of: .value)
        {
            DataSnapshot in
            guard let studentDict = DataSnapshot.value as? NSDictionary else{return}
            completion(Student([DataSnapshot.key: studentDict]))
        }
    }
    
    func setStudent(_ student:Student)
    {
        FireBaseDB.sharedInstance.DBref.child(Constants.kSTUDENTS).child(student.id).setValue(student.studentDictionary)
    }
    
    func getAVCourses(department : String,completion : @escaping ([AvailableCourse]) -> ())
    {
        
        FireBaseDB.sharedInstance.DBref.child(Constants.kDEPARTMENTS).child(department).child(Constants.kAVAILABLECOURSES)
            .observeSingleEvent(of: .value)
        {
            DataSnapshot in
            
            guard let coursesDict = DataSnapshot.value as? [NSDictionary] else{return}
            
            var courses = [AvailableCourse]()
            
            var count = 0
            for item in coursesDict
            {
                let code  = item.allKeys.first as? String ?? ""
                
                courses.append(AvailableCourse([ count : [ code: item[code] ] ]))
                count += 1
            }
            completion(courses)
            
        }
    }
    
}
