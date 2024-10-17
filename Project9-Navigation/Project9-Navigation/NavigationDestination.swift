//
//  NavigationDEstination.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 16/10/24.
//

import SwiftUI

struct NavigationDestination: View
{
    var body: some View
    {
        NavigationStack
        {
            List(0..<100)
            { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self)
            { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

struct Student: Hashable
{
    var id = UUID()
    var name: String
    var age: Int
}

#Preview {
    NavigationDestination()
}
