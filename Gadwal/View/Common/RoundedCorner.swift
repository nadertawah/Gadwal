//
//  RoundedCorner.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import SwiftUI

struct RoundedCorner: Shape
{
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path
    {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
