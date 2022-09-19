//
//  LoginRegisterVM.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//


import FirebaseAuth

class LoginRegisterVM
{
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
            {
                result , error  in
                if result != nil
                {
                    let UID = result!.user.uid
                    
                    FireBaseDB.sharedInstance.getSubDepartments(department: department)
                    {
                        subDepartmentsArr in
                        
                        FireBaseDB.sharedInstance.getDepartmentCourseTypeStatus(department: department)
                        {
                            courseTypeArr in
                            
                            FireBaseDB.sharedInstance.getDepartmentCourses(department: department)
                            {
                                departmentCoursesArr in
                                
                                let student = Student(id: UID, name: name, department: department, email: email, subDepartments: subDepartmentsArr, studentCourses: departmentCoursesArr, courseTypeStatus: courseTypeArr)
                                
                                //save to firebase db
                                FireBaseDB.sharedInstance.setStudent(student)
                                
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
