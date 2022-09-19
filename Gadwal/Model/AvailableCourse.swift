//
//  AvailableCourse.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import Foundation

class AvailableCourse : Course
{
    //MARK: - Var(s)

    var from : Float
    var to : Float
    var day : String
    var prof : String
    var desiredIndex : Int = 0
    var id : Int
    var courseLevel : Int
    {
        var level = -1
        for char in self.courseCode
        {
            if let lvl = Int(String(char))
            {
                level = lvl
                break
            }
        }
        if(level == 0){return 3}
        else {return level}
    }
    
    init(id : Int,courseCode: String,courseName:String,credit:Float ,from : Float, to : Float, day : String, prof : String, desiredIndex : Int)
    {
        self.from = from
        self.to = to
        self.day = day
        self.prof = prof
        self.desiredIndex = desiredIndex
        self.id = id
        super.init(courseCode: courseCode, courseName: courseName,credits: credit)
    }
    
    override init(_ dictionary : NSDictionary)
    {
        self.id = dictionary.allKeys.first as? Int ?? 0

        let courseDict = dictionary[id] as! NSDictionary
        
        let courseCode = courseDict.allKeys.first as? String ?? ""

        let courseDictValue = courseDict[courseCode] as! NSDictionary
        
        
        self.from = courseDictValue[Constants.kFROM] as? Float ?? 0
        
        self.to = courseDictValue[Constants.kTO] as? Float ?? 0
        
        self.day = courseDictValue[Constants.kDAY] as? String ?? ""
        
        self.prof = courseDictValue[Constants.kPROF] as? String ?? ""

        super.init(courseDict)
    }
    
    
    //MARK: - Helper Funcs
    func isConflicted(with second :AvailableCourse) -> Bool
    {
        if(self.courseCode.contains("000") && second.courseCode.contains("000"))
        {
            return true
        }
        if (self.day == second.day && self.day != "غير محدد")
        {
            if (self.from == second.from ||
                self.from > second.from && self.from < second.to ||
                second.from > self.from && second.from < self.to) {return true}
        }
        return false
    }
}
