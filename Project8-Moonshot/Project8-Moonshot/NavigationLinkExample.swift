//
//  NavigationLinkExample.swift
//  Project8-Moonshot
//
//  Created by Daniel Braga Barbosa on 12/10/24.
//

import SwiftUI

struct NavigationLinkExample: View
{
    var body: some View
    {
        NavigationStack
        {
//            NavigationLink("Tap me")
//            {
//                Text("Detail view")
//            }
//                .navigationTitle("SwiftUI")
            
//            NavigationLink {
//                Text("Detail view")
//            } label: {
//                VStack
//                {
//                    Text("This is the label")
//                    Text("So is this")
//                    Image(systemName: "face.smiling")
//                }
//                .font(.largeTitle)
//            }
//            .navigationTitle("SwiftUI")
            
            List(0..<100) { row in
                NavigationLink("Row \(row)")
                {
                    Text("Detail \(row)")
                }
            }
            .navigationTitle("SwiftUI")
        }
    }
}

#Preview {
    NavigationLinkExample()
}
