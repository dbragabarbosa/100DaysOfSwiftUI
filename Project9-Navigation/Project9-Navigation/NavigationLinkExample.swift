//
//  NavigationLinkExample.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 16/10/24.
//

import SwiftUI

struct NavigationLinkExample: View
{
    var body: some View
    {
        NavigationStack
        {
            NavigationLink("Tap me")
            {
                DetailView(number: 556)
            }
        }
    }
}

struct DetailView: View
{
    var number: Int
    
    var body: some View
    {
        Text("Detail View \(number)")
    }
    
    init(number: Int)
    {
        self.number = number
        print("Creating detail view \(number)")
    }
}

#Preview
{
    NavigationLinkExample()
}
