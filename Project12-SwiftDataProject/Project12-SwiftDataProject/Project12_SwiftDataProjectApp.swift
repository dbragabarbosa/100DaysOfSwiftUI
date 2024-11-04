//
//  Project12_SwiftDataProjectApp.swift
//  Project12-SwiftDataProject
//
//  Created by Daniel Braga Barbosa on 03/11/24.
//

import SwiftUI
import SwiftData

@main
struct Project12_SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
