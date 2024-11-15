//
//  ProjectDay60App.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 09/11/24.
//

import SwiftUI
import SwiftData

@main
struct ProjectDay60App: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: UserInfo.self)
        .modelContainer(for: FriendInfo.self)
    }
}
