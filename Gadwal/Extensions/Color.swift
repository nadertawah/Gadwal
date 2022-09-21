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
    static let color1 = Color(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161)
    static let color2 = Color(red: 0.5807225108, green: 0.066734083, blue: 0)
    static let color3 = Color(red: 1, green: 0.5781051517, blue: 0)
    static let color4 = Color(red: 0.5738074183, green: 0.5655357838, blue: 0)
    static let color5 = Color(red: 0, green: 0.5628422499, blue: 0.3188166618)
    static let color6 = Color(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764)
    static let color7 = Color(red: 1, green: 0.1857388616, blue: 0.5733950138)
    static let color8 = Color(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951)

    static func getTypeColor(type:String,subDepartmentNumber:Int?,mandatory:Bool) -> Color
    {
        if mandatory
        {
            if(type == "متطلبات جامعة" ) {return .black}
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
