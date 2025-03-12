//
//  CreatingTabsWithTabViewAndTabItem.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 12/03/25.
//

import SwiftUI

struct CreatingTabsWithTabViewAndTabItem: View
{
    @State private var selectedTab = "One"
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        TabView(selection: $selectedTab)
        {
//            Text("Tab 1")
            Button("Show tab 2")
            {
                selectedTab = "Two"
            }
                .tabItem
                {
                    Label("One", systemImage: "star")
                }
                .tag("One")
            
            Text("Tab 2")
//            Button("Show tab 2")
//            {
//                selectedTab = "Two"
//            }
                .tabItem
                {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}

#Preview
{
    CreatingTabsWithTabViewAndTabItem()
}
