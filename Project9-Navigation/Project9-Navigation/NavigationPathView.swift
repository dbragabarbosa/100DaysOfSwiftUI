//
//  NavigationPath.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 17/10/24.
//

import SwiftUI

struct NavigationPathView: View
{
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(0..<5)
                { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }
                
                ForEach(0..<5)
                { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .navigationDestination(for: Int.self)
            { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self)
            { selection in
                Text("You selected the string \(selection)")
            }
        }
    }
}

struct ProgrammaticNavigationView: View
{
    @State private var path = NavigationPath()
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(0..<5)
                { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }
                
                ForEach(0..<5)
                { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .toolbar
            {
                Button("Push 556")
                {
                    path.append(556)
                }
                
                Button("Push Hello")
                {
                    path.append("Hello")
                }
            }
            .navigationDestination(for: Int.self)
            { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self)
            { selection in
                Text("You selected the string \(selection)")
            }
        }
    }
}

#Preview {
    ProgrammaticNavigationView()
}
