//
//  AbsolutePositioningExample.swift
//  Project18-LayoutAndGeometry
//
//  Created by Daniel Braga Barbosa on 25/04/25.
//

import SwiftUI

struct AbsolutePositioningExample: View
{
    var body: some View
    {
//        Text("Hello, world!")
//            .position(x: 100, y: 100)
        
//        Text("Hello, world!")
//            .background(.red)
//            .position(x: 100, y: 100)
        
        Text("Hello, world!")
            .position(x: 100, y: 100)
            .background(.red)
    }
}

#Preview
{
    AbsolutePositioningExample()
}

struct offsetExample: View
{
    var body: some View
    {
        Text("Hello, world!")
            .offset(x: 100, y: 100)
            .background(.red)
        
        Text("Hello, world!")
            .background(.red)
            .offset(x: 100, y: 100)
    }
}

#Preview
{
    offsetExample()
}
