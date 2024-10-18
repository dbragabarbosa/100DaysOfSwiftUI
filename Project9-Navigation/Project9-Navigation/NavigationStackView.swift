//
//  ContentView.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 16/10/24.
//

import SwiftUI

struct NavigationStackView: View
{
    @State private var path = [Int]()
    
    var body: some View
    {
        NavigationStack(path: $path)
        {
            VStack
            {
                Button("Show 32")
                {
                    path = [32]
                }
                
                Button("Show 64")
                {
                    path.append(64)
                }
                
                Button("Show 32 than 64")
                {
                    path = [32, 64]
                }
            }
            .navigationDestination(for: Int.self)
            { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

#Preview {
    NavigationStackView()
}
