//
//  LoginRegisterVM.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//


import FirebaseAuth

class LoginRegisterVM
{
    init(dbInstance : DBProtocol)
    {
        self.dbInstance = dbInstance
    }
    
    //MARK: - Var(s)
    var dbInstance : DBProtocol
    
    
    //MARK: - intent(s)
    func login(_ email: String, _ password:String,completion : @escaping (AuthDataResult?, Error?) -> () )
    {
        DispatchQueue.global(qos: .userInteractive).async
        {
            Auth.auth().signIn(withEmail: email, password: password)
            {
                result, error in
                DispatchQueue.main.async
                {
                    completion(result, error)
                }
            }
        }
    }
    
    func register(name: String ,email: String, password: String,department:String,completion: @escaping (AuthDataResult?, Error?) -> () )
    {
        DispatchQueue.global(qos: .userInteractive).async
        {
            Auth.auth().createUser(withEmail: email, password: password)
            { [weak self]
                result , error  in
                guard let self = self else {return}
                if result != nil
                {
                    let UID = result!.user.uid
                    
                    self.dbInstance.getSubDepartments(department: department)
                    {
                        subDepartmentsArr in
                        
                        self.dbInstance.getDepartmentCourseTypeStatus(department: department)
                        {
                            courseTypeArr in
                            
                            self.dbInstance.getDepartmentCourses(department: department)
                            {
                                departmentCoursesArr in
                                
                                let student = Student(id: UID, name: name, department: department, email: email, subDepartments: subDepartmentsArr, studentCourses: departmentCoursesArr, courseTypeStatus: courseTypeArr)
                                
                                //save to firebase db
                                self.dbInstance.setStudent(student)
                                
                                DispatchQueue.main.async
                                {
                                    completion(result, nil)
                                }
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    
}
