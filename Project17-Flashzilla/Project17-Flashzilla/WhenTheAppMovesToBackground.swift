//
//  WhenTheAppMovesToBackground.swift
//  Project17-Flashzilla
//
//  Created by Daniel Braga Barbosa on 02/04/25.
//

import SwiftUI

struct WhenTheAppMovesToBackground: View
{
    @Environment(\.scenePhase) var scenePhase

    var body: some View
    {
        Text("Hello, world!")
            .onChange(of: scenePhase)
            { oldPhase, newPhase in
                
                if newPhase == .active
                {
                    print("Active")
                }
                else if newPhase == .inactive
                {
                    print("Inactive")
                }
                else if newPhase == .background
                {
                    print("Background")
                }
            }
    }
}

#Preview
{
    WhenTheAppMovesToBackground()
}
