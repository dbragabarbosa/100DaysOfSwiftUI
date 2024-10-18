//
//  NavigationStackReturnRootProgrammatically.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 17/10/24.
//

import SwiftUI

struct NavigationStackReturnRootProgrammatically: View
{
    @State private var path = [Int]()
    
    var body: some View
    {
        NavigationStack(path: $path)
        {
            DetailSecondView(path: $path, number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailSecondView(path: $path, number: i)
                }
        }
    }
}

struct DetailSecondView: View
{
    @Binding var path: [Int]
    var number: Int
    
    var body: some View
    {
        NavigationLink("Go to random number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .toolbar
            {
                Button("Home")
                {
                    path.removeAll()
//                    path = NavigationPath()
                }
            }
    }
}

#Preview {
    NavigationStackReturnRootProgrammatically()
}
