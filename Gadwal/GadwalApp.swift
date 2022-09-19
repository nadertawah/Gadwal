//
//  GadwalApp.swift
//  Gadwal
//
//  Created by nader said on 10/09/2022.
//

import SwiftUI
import FirebaseCore

@main
struct GadwalApp: App
{
    init()
    {
        FirebaseApp.configure()
    }
    var body: some Scene
    {
        WindowGroup
        {
            LoginRegisterView()
                .preferredColorScheme(.light)
        }
    }
}
