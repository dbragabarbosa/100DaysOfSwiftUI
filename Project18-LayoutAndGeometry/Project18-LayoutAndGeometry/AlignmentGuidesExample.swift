//
//  AlignmentGuidesExample.swift
//  Project18-LayoutAndGeometry
//
//  Created by Daniel Braga Barbosa on 25/04/25.
//

import SwiftUI

struct AlignmentGuidesExample: View
{
    var body: some View
    {
        Text("Live long and prosper")
            .frame(width: 300, height: 300, alignment: .topLeading)
        
        HStack(alignment: .lastTextBaseline)
        {
            Text("Live")
                .font(.caption)
            Text("long")
            Text("and")
                .font(.title)
            Text("prosper")
                .font(.largeTitle)
        }
    }
}

#Preview
{
    AlignmentGuidesExample()
}

struct individualAlignment: View
{
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text("Hello, world!")
                .alignmentGuide(.leading) { d in d[.trailing] }
            Text("This is a longer line of text")
        }
        .background(.red)
        .frame(width: 400, height: 400)
        .background(.blue)
        
        
        VStack(alignment: .leading)
        {
            ForEach(0..<10)
            { position in
                
                Text("Number \(position)")
                    .alignmentGuide(.leading) { _ in Double(position) * -10 }
            }
        }
        .background(.red)
        .frame(width: 400, height: 400)
        .background(.blue)
        
    }
}

#Preview
{
    individualAlignment()
}
