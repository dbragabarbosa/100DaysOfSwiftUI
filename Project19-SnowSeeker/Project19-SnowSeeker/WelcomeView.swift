//
//  WelcomeView.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 14/05/25.
//

import SwiftUI

struct WelcomeView: View
{
    var body: some View
    {
        VStack
        {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview
{
    WelcomeView()
}
