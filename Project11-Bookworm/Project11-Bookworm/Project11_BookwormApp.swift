//
//  Project11_BookwormApp.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 29/10/24.
//

import SwiftData
import SwiftUI

@main
struct Project11_BookwormApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
//        .modelContainer(for: Student.self)
        .modelContainer(for: Book.self)
    }
}
