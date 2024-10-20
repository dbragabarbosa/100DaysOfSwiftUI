//
//  NavigationTitle.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 19/10/24.
//

import SwiftUI

struct NavigationTitle: View
{
    @State private var title = "SwiftUI"
    
    var body: some View
    {
        NavigationStack
        {
            Text("Hello, world!")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview
{
    NavigationTitle()
}
