//
//  SideBySideViews.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 08/05/25.
//

import SwiftUI

struct SideBySideViews: View
{
    var body: some View
    {
//        NavigationView
//        {
//            Text("Hello, world!")
//                .navigationTitle("Primary")
//        }
        
        NavigationSplitView
        {
            Text("Primary")
        } detail: {
            Text("Content")
        }
        
        
        NavigationSplitView {
            NavigationLink("Primary") {
                Text("New view")
            }
        } detail: {
            Text("Content")
        }
        
        
//        NavigationSplitView(columnVisibility: .constant(.all)) {
        NavigationSplitView(preferredCompactColumn: .constant(.detail)) {
            NavigationLink("Primary") {
                Text("New view")
            }
        } detail: {
            Text("Content")
                .navigationTitle("Content View")
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview
{
    SideBySideViews()
}
