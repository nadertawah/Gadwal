//
//  TableVM.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import Foundation

class TableVM : ObservableObject
{
    init(student : Student,dbInstance : DBProtocol)
    {
        self.dbInstance = dbInstance
        self.student = student
        getCourses()
    }
    
    //MARK: - Var(s)
    var student : Student!
    @Published var availableCourses = [AvailableCourse]()
    var dbInstance : DBProtocol

    //MARK: - Helper Funcs
    
    func getCourses()
    {
        if !student.department.isEmpty
        {
            dbInstance.getAVCourses(department: student.department)
            {
                [weak self] in
                self?.availableCourses = $0
                self?.filterCourses()
            }
        }
    }
    
    func filterCourses()
    {
        for index in availableCourses.indices.reversed()
        {
            //remove already taken and passed courses
            if let course = student.studentCourses.first(where: {$0.courseCode.uppercased() ==  availableCourses[index].courseCode.uppercased()})
            {
                
                if course.taken && course.passed
                {
                    availableCourses.remove(at: index)
                    continue
                }
                
                //remove -too high level- courses
                if availableCourses[index].courseLevel > student.level + 1
                {
                    availableCourses.remove(at: index)
                    continue
                }
                
                //remove courses which prerequisite hadn't been taken and passed yet
                let preq :[String]  = course.getPreqArr()
                for i in preq.indices
                {
                    let childCourse = student.studentCourses.first {$0.courseCode.uppercased() ==  preq[i].uppercased()}
                    if !childCourse!.taken || !childCourse!.passed
                    {
                        availableCourses.remove(at: index)
                        break
                    }
                }
            }
            else
            {
                availableCourses.remove(at: index)
                break
            }
        }
        
        for item in student.courseTypeStatus  //remove completed types
        {
            if(item.takenHours >= item.maxHours && item.required == false)
            {
                for index in availableCourses.indices.reversed()
                {
                    if(availableCourses[index].type == item.type && availableCourses[index].required == false)
                    {
                        availableCourses.remove(at: index)
                    }
                }
            }
        }
    }
    
      
}
