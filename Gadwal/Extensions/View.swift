//
//  View.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import SwiftUI

extension View
{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View
    {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
