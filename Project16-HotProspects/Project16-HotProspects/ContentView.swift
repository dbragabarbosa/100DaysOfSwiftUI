//
//  ContentView.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 12/03/25.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        TabView
        {
            ProspectsView(filter: .none)
                .tabItem
                {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem
                {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem
                {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem
                {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
    }
}

#Preview
{
    ContentView()
}
