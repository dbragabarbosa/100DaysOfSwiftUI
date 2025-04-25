//
//  CustomAlignmentGuideExample.swift
//  Project18-LayoutAndGeometry
//
//  Created by Daniel Braga Barbosa on 25/04/25.
//

import SwiftUI

struct CustomAlignmentGuideExample: View
{
    var body: some View
    {
        HStack(alignment: .midAccountAndName)
        {
            VStack
            {
                Text("@twostraws")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                
                Image(systemName: "chevron")
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack
            {
                Text("Full name:")
                
                Text("PAUL HUDSON")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                    .font(.largeTitle)
            }
        }
    }
}

extension VerticalAlignment
{
//    struct MidAccountAndName: AlignmentID
    enum MidAccountAndName: AlignmentID
    {
        static func defaultValue(in context: ViewDimensions) -> CGFloat
        {
            context[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

#Preview
{
    CustomAlignmentGuideExample()
}
