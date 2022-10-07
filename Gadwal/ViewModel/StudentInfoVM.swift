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
    init(dbInstance : DBProtocol)
    {
        self.dbInstance = dbInstance
        getStudent()
    }
    
    //MARK: - Var(s)
    @Published var student = Student(id: "", name: "", department: "", email: "", subDepartments: [], studentCourses: [], courseTypeStatus: [])
    var dbInstance : DBProtocol

    //MARK: - intent(s)
    func saveStudent()
    {
        student.rebuildStats()
        dbInstance.setStudent(student)
    }
    
    //MARK: - Helper Funcs
    func getStudent()
    {
        dbInstance.getStudent
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
