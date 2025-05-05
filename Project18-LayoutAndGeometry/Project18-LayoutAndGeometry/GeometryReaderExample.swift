//
//  GeometryReaderExample.swift
//  Project18-LayoutAndGeometry
//
//  Created by Daniel Braga Barbosa on 05/05/25.
//

import SwiftUI

struct GeometryReaderExample: View
{
    var body: some View
    {
        HStack
        {
            Text("IMPORTANT")
                .frame(width: 200)
                .background(.blue)

            Image(systemName: "chevron")
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.8
                }
            
            GeometryReader { proxy in
                Image(systemName: "chevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width * 0.8)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

#Preview
{
    GeometryReaderExample()
}
