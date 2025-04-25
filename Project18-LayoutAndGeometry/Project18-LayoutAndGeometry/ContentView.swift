//
//  ContentView.swift
//  Project18-LayoutAndGeometry
//
//  Created by Daniel Braga Barbosa on 25/04/25.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        VStack
        {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview
{
    ContentView()
}
