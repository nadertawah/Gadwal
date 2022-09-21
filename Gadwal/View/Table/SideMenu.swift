//
//  SideMenu.swift
//  Gadwal
//
//  Created by nader said on 21/09/2022.
//

import SwiftUI

struct SideMenu: View
{
    @State var isSidebarVisible: Bool = false
    @State var subDepartments : [String] = ["",""]
    var sideMenuWidth = UIScreen.main.bounds.size.width * 0.7

    var body: some View
    {
        ZStack
        {
            GeometryReader
            { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture
            {
                isSidebarVisible.toggle()
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }

    var content: some View
    {
        HStack(alignment: .top)
        {
            Spacer()
            ZStack(alignment: .top)
            {
                Color.GadwalBGColor
                
                MenuChevron
                 
                VStack(spacing: 20)
                {
                    TypesAndColors
                    
                    Rectangle()
                        .frame(width: sideMenuWidth - 10, height: 2, alignment: .center)
                        .foregroundColor(.white)
                    
                    Text(
                        """
                        Avoid leaving courses in 'Neutral' state as much as possible to get fast and specific results
                        instead of generating too many combinations that will lead to excessive process overhead and much longer time.
                        """
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white)
                    .padding()
                }
                .padding(.top)
               
            }
            .frame(width: sideMenuWidth)
            .offset(x: isSidebarVisible ? 0 : sideMenuWidth)
            .animation(.default, value: isSidebarVisible)
        }
    }

    var MenuChevron: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.GadwalBGColor)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSidebarVisible ? -14 : -20)
                .onTapGesture
            {
                isSidebarVisible.toggle()
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
                .rotationEffect(isSidebarVisible ?
                                Angle(degrees: 0) : Angle(degrees: 180))
                .offset(x: isSidebarVisible ? -35 : -38)
                .foregroundColor(.white)
        }
        .animation(.default, value: isSidebarVisible)
        .offset(x: (-sideMenuWidth / 2) + 30, y: 80)
    }
    
    var TypesAndColors : some View
    {
        HStack
        {
            VStack
            {
                Group
                {
                    Circle()
                        .foregroundColor(.black)
                    Circle()
                        .foregroundColor(.color1)
                    Circle()
                        .foregroundColor(.color5)
                    Circle()
                        .foregroundColor(.color2)
                    Circle()
                        .foregroundColor(.color6)
                    Circle()
                        .foregroundColor(.color3)
                    Circle()
                        .foregroundColor(.color7)
                    Circle()
                        .foregroundColor(.color4)
                        .opacity(subDepartments.count > 1 ? 1 : 0)
                    Circle()
                        .foregroundColor(.color8)
                        .opacity(subDepartments.count > 1 ? 1 : 0)
                }
                .frame(width: 20, height: 20, alignment: .center)
            }
            
            VStack
            {
                Group
                {
                    Text("متطلبات جامعة")
                    Text("اختياري تخدم التخصص")
                    Text("اجباري تخدم التخصص")
                    Text("اختياري متطلبات كلية")
                    Text("اجباري متطلبات كلية")
                    Text("اختيارى " + subDepartments[0])
                    Text("اجبارى " + subDepartments[0])
                    Text(subDepartments.count > 1 ? "اختيارى " + subDepartments[1] : "اختيارى ")
                        .opacity(subDepartments.count > 1 ? 1 : 0)
                    Text(subDepartments.count > 1 ? "اجبارى " + subDepartments[1] : "اجبارى ")
                        .opacity(subDepartments.count > 1 ? 1 : 0)
                }
                .foregroundColor(.white)
                .frame(height: 20, alignment: .center)
            }
        }
        .padding(.top, 30)
        .frame(width: sideMenuWidth - 10, alignment: .leading)
        .padding(.leading, 10)
    }
}



struct Side_Previews: PreviewProvider
{
    static var previews: some View
    {
        SideMenu()
    }
}
