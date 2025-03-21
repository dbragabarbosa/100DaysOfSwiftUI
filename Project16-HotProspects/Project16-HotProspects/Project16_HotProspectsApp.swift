//
//  Project16_HotProspectsApp.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 12/03/25.
//

import SwiftUI
import SwiftData

@main
struct Project16_HotProspectsApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
