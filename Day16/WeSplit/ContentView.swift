//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Braga Barbosa on 18/06/24.
//

import SwiftUI

struct ContentView: View
{
    @State private var tapCount = 0
    @State private var name = ""
    
    var body: some View
    {
        VStack
        {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            NavigationStack
            {
                Form
                {
                    TextField("Enter your name", text: $name)
                    Text("Your name is: \(name)")
                    
                    ForEach(0..<100)
                    {
                        Text("Linha \($0)")
                    }
                }
                .navigationTitle("Tell me your name")
                .navigationBarTitleDisplayMode(.inline)
            }
            Button("Tap Count: \(tapCount)")
            {
                tapCount += 1
            }

        }
        .padding()
    }
}

#Preview 
{
    ContentView()
}
