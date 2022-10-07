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
        dbInstance = FireBaseDB()
    }
    var dbInstance : DBProtocol
    
    var body: some Scene
    {
        WindowGroup
        {
            LoginRegisterView(dbInstance: dbInstance)
                .preferredColorScheme(.light)
                
        }
        
    }
}
