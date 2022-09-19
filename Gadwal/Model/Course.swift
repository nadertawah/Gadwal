//
//  Course.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import Foundation

class Course
{
    var courseName: String
    var courseCode: String
    var type: String
    var credits: Float
    var required: Bool
    var taken: Bool
    var passed: Bool
    var prerequisite: String?
    var secondPrerequisite: String?
    var thirdPrerequisite: String?
    
    var courseDict : NSDictionary
    {
        NSDictionary(objects: [courseName, type, credits, required, taken, passed ,prerequisite ?? "",secondPrerequisite ?? "",thirdPrerequisite ?? ""],
                            forKeys: [Constants.kCOURSENAME as NSCopying, Constants.kTYPE as NSCopying, Constants.kCREDITS as NSCopying, Constants.kREQUIRED as NSCopying,Constants.kTAKEN as NSCopying,Constants.kPASSED as NSCopying,Constants.kPREREQUISITE as NSCopying,Constants.kSECONDPREREQUISITE as NSCopying,Constants.kTHIRDPREREQUISITE as NSCopying])
    }
    
    init(courseCode: String = "", courseName : String = "" , type: String = "" , credits: Float = 0, required:Bool = false ,taken:Bool = false, passed:Bool = false)
    {
        self.courseName = courseName
        self.type = type
        self.credits = credits
        self.required = required
        self.taken = taken
        self.passed = passed
        self.courseCode = courseCode
    }
    
    init(_ dictionary : NSDictionary)
    {
        if let code = dictionary.allKeys.first as? String
        {
            courseCode = code
        }
        else {courseCode = ""}
        
        let courseDict = dictionary[courseCode] as! NSDictionary
        
        self.courseName = courseDict[Constants.kCOURSENAME] as? String ?? ""
        self.credits = courseDict[Constants.kCREDITS] as? Float ?? 0
        self.passed = courseDict[Constants.kPASSED] as? Bool ?? true
        self.required = courseDict[Constants.kREQUIRED] as? Bool ?? false
        self.taken = courseDict[Constants.kTAKEN] as? Bool ?? false
        self.type = courseDict[Constants.kTYPE] as? String ?? ""
        
        self.prerequisite = courseDict[Constants.kPREREQUISITE] as? String ?? ""
        self.secondPrerequisite = courseDict[Constants.kSECONDPREREQUISITE] as? String ?? ""
        self.thirdPrerequisite = courseDict[Constants.kTHIRDPREREQUISITE] as? String ?? ""

    }
    
    //MARK: - Helper Funcs
    func getPreqArr()->[String]
    {
        var children = [String]()
        if(self.prerequisite != "" && self.prerequisite != nil )
        {
            children.append(self.prerequisite!)
            if(self.secondPrerequisite != "" && self.secondPrerequisite != nil )
            {
                children.append(self.secondPrerequisite!)
                if(self.thirdPrerequisite != "" && self.thirdPrerequisite != nil )
                {
                    children.append(self.thirdPrerequisite!)
                }
            }
        }
        return children
    }
}
