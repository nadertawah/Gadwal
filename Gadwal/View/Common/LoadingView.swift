//
//  LoadingView.swift
//  Gadwal
//
//  Created by Nader Said on 19/09/2022.
//

import SwiftUI

struct LoadingView: View
{
    @State private var isLoading: Bool = false

    var body: some View
    {
        ZStack
        {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.GadwalBGColor, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: isLoading)
                .onAppear()
                {
                    isLoading.toggle()
                }
        }
    }
}
