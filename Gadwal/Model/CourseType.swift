//
//  CourseType.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import Foundation

struct CourseType
{
    var type: String
    var required: Bool
    var maxHours: Float
    var takenHours: Float
    
    var typesDict : NSDictionary
    {
        NSDictionary(objects: [type, required, maxHours, takenHours],
                            forKeys: [Constants.kTYPE as NSCopying, Constants.kREQUIRED as NSCopying,Constants.kMAXHOURS as NSCopying,Constants.kTAKENHOURS as NSCopying])
    }
    
    init(_ dictionary : NSDictionary)
    {
        self.type = dictionary[Constants.kTYPE] as? String ?? ""
        self.required = dictionary[Constants.kREQUIRED] as? Bool ?? false
        self.takenHours = dictionary[Constants.kTAKENHOURS] as? Float ?? 0
        self.maxHours = dictionary[Constants.kMAXHOURS] as? Float ?? 0
    }
}
