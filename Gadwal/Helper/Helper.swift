//
//  Helper.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import FirebaseAuth

struct Helper
{
    //Auth
    static func getCurrentUserID() -> String
    {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    static func getTimeLabelStr(from : Float , to : Float) -> String
    {
        var time = "\(toNormalTime(time: from))"
        
        if(toNormalTime(time: from) != 0)
        {
            if(from > 8 && from < 12)
            {
                time += "AM:\(toNormalTime(time: to))"
                if(to > 8 && to < 12)
                {
                    time += "AM"
                }
                else{time += "PM"}
            }else
            {
                time += "PM:\(toNormalTime(time: to))PM"
                
            }
        }
        else
        {
            time = "Not specified"
        }
        return time
    }

    static private func toNormalTime(time : Float) -> Float
    {
        if (time >= 8 && time < 13) || time == 0
        {
            return time
        }
        else
        {
            return time - 12
        }
    }
    
}
