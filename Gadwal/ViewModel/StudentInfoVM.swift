//
//  StudentInfoVM.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import Foundation
import FirebaseAuth

class StudentInfoVM : ObservableObject
{
    init()
    {
        getStudent()
    }
    
    //MARK: - Var(s)
    ///@Published var courses : [Course] = []
    @Published var student = Student(id: "", name: "", department: "", email: "", subDepartments: [], studentCourses: [], courseTypeStatus: [])
    
    //MARK: - intent(s)
    func saveStudent()
    {
        student.rebuildStats()
        FireBaseDB.sharedInstance.setStudent(student)
    }
    
    //MARK: - Helper Funcs
    func getStudent()
    {
        FireBaseDB.sharedInstance.getStudent
        {
            [weak self] in
            self?.student = $0
            self?.student.studentCourses.sort(by: { $0.courseCode < $1.courseCode})
        }
    }
    
    func logout(completion : @escaping ()->())
    {
        DispatchQueue.global(qos: .userInteractive).async
        {
            do
            {
                try Auth.auth().signOut()
                DispatchQueue.main.async
                {
                    completion()
                }
            }
            catch { print("already logged out") }
        }
    }
}
