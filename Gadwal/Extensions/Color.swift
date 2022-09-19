//
//  Color.swift
//  Gadwal
//
//  Created by nader said on 15/09/2022.
//

import SwiftUI

extension Color
{
    static let GadwalBGColor = Color(.displayP3, red: 20/255, green: 40/255, blue: 49/255)
    static let color1 = Color(red: 0, green: 0.9810667634, blue: 0.5736914277)
    static let color2 = Color(red: 0.4620226622, green: 0.8382837176, blue: 1)
    static let color3 = Color(red: 1, green: 0.5409764051, blue: 0.8473142982)
    static let color4 = Color(red: 1, green: 0.8323456645, blue: 0.4732058644)
    static let color5 = Color(red: 0, green: 0.5628422499, blue: 0.3188166618)
    static let color6 = Color(red: 0, green: 0.3285208941, blue: 0.5748849511)
    static let color7 = Color(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188)
    static let color8 = Color(red: 0.5738074183, green: 0.5655357838, blue: 0)
    
    static func getTypeColor(type:String,subDepartmentNumber:Int?,mandatory:Bool) -> Color
    {
        if mandatory
        {
            if(type == "متطلبات جامعة" ) {return .gray}
            else if subDepartmentNumber == 0 {return .color7}
            else if subDepartmentNumber == 1 {return .color8}
            else if (type == "تخدم التخصص") {return .color5}
            else if (type == "متطلبات كلية") {return .color6}
        }
        else
        {
            if subDepartmentNumber == 0 {return .color3}
            else if subDepartmentNumber == 1 {return .color4}
            else if (type == "تخدم التخصص") {return .color1}
            else if (type == "متطلبات كلية") {return .color2}
        }
        
        return .black
    }
}
