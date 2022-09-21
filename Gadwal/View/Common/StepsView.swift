//
//  StepsView.swift
//  Gadwal
//
//  Created by nader said on 21/09/2022.
//

import SwiftUI

struct StepsView: View
{
    @State var stepsCount :Int = 3
    @State var currentStepIndex :Int = 5
    
    var body: some View
    {
        ZStack
        {
            GeometryReader
            {
                geometry in
                
                let diamondWidth = (geometry.size.width - ((CGFloat(stepsCount) - 1) * 20)) / CGFloat(stepsCount)
                let diamondHeight = geometry.size.height
                
                Group
                {
                    HStack(spacing: 0)
                    {
                        ForEach(0..<stepsCount, id:\.self)
                        {
                            i in
                            
                            Diamond()
                                .foregroundColor(Color.GadwalBGColor)
                                .frame(width: diamondWidth , height: diamondHeight, alignment: .center)
                            
                            if i != stepsCount - 1
                            {
                                Rectangle()
                                    .fill(Color.GadwalBGColor)
                                    .frame(width: 20, height: 2, alignment: .center)
                            }
                        }
                    }
                    
                    HStack(spacing: 0)
                    {
                        
                        ForEach(0..<stepsCount, id:\.self)
                        {
                            i in

                            Diamond()
                                .foregroundColor(currentStepIndex >= i ? .white : .GadwalBGColor)
                                .frame(width: diamondWidth - 10  , height: diamondHeight - 10 , alignment: .center)

                            if i != stepsCount - 1
                            {
                                   Rectangle()
                                    .fill(currentStepIndex > i ? .white : .GadwalBGColor)
                                    .frame(width: 30, height: 2, alignment: .center)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width , height: geometry.size.height, alignment: .center)
            }
        }
    }
}
//((geometry.size.width - ((CGFloat(stepsCount) - 1) * 30)) / CGFloat(stepsCount)) - 10
struct StepsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        StepsView()
    }
}
