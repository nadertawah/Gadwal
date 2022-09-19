//
//  LazyNavigationLink.swift
//  Gadwal
//
//  Created by Nader Said on 16/09/2022.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View
{
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content)
    {
        self.build = build
    }
    var body: Content
    {
        build()
    }
}
