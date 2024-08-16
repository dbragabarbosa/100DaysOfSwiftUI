//
//  ContentViewTests.swift
//  Project5-WordScramble
//
//  Created by Daniel Braga Barbosa on 16/08/24.
//

import SwiftUI

struct ContentViewTests: View 
{
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View
    {
        List
        {
            Section("Section 1")
            {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }
            
            Section("Section 2")
            {
                ForEach(0..<5)
                {
                    Text("Dynamic row \($0)")
                }
            }
            
            Section("Section 3")
            {
                Text("Static row 3")
                Text("Static row 4")
            }
        }
        .listStyle(.grouped)
        
//        List(0..<3)
//        {
//            Text("Dynamic row \($0)")
//        }
        
        List(people, id: \.self) 
        {
            Text($0)
        }
    }
    
//    if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//        // we found the file in our bundle!
//    }
//        
//    if let fileContents = try? String(contentsOf: fileURL) {
//        // we loaded the file into a string!
//    }
    
    
}

#Preview {
    ContentViewTests()
}
