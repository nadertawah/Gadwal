//
//  FireBaseDBProtocol.swift
//  Gadwal
//
//  Created by nader said on 06/10/2022.
//

import FirebaseDatabase

protocol DBProtocol
{
    func getSubDepartments(department:String, completion : @escaping ([String])->())
    func getDepartmentCourses(department:String, completion : @escaping ([Course])->())
    func getDepartmentCourseTypeStatus(department:String, completion : @escaping ([CourseType])->())
    func getStudent(completion : @escaping (Student)->())
    func setStudent(_ student:Student)
    func getAVCourses(department : String,completion : @escaping ([AvailableCourse]) -> ())
}
