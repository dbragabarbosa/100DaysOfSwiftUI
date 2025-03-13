//
//  CreatingContextMenus.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 13/03/25.
//

import SwiftUI

struct CreatingContextMenus: View
{
    @State private var backgroundColor = Color.red
    
    var body: some View
    {
        VStack
        {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)
            
            Text("Change Color")
                .padding()
                .contextMenu
                {
                    Button("Red", systemImage: "checkmark.circle.fill", role: .destructive)
                    {
                        backgroundColor = .red
                    }
                    Button("Green", systemImage: "checkmark.circle.fill")
                    {
                        backgroundColor = .green
                    }
                    Button("Blue")
                    {
                        backgroundColor = .blue
                    }
                }
        }
    }
}

#Preview
{
    CreatingContextMenus()
}
