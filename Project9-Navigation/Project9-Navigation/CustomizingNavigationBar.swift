//
//  CustomizingNavigationBar.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 19/10/24.
//

import SwiftUI

struct CustomizingNavigationBar: View
{
    var body: some View
    {
        NavigationStack
        {
            List(0..<100)
            { i in
                Text("Row \(i)")
            }
            .navigationTitle("Title goes here")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.blue)
            .toolbarColorScheme(.dark)
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
}

#Preview
{
    CustomizingNavigationBar()
}
