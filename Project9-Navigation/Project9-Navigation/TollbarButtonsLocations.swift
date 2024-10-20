//
//  TollbarButtonsLocations.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 19/10/24.
//

import SwiftUI

struct TollbarButtonsLocations: View
{
    var body: some View
    {
        NavigationStack
        {
            Text("Hello, world!")
            
//            .toolbar
//            {
//                ToolbarItem(placement: .topBarLeading)
//                {
//                    Button("Tap Me")
//                    {
//                        // button action here
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarLeading)
//                {
//                    Button("Or tap me")
//                    {
//                        // button action
//                    }
//                }
//            }
            
                .toolbar
                {
                    ToolbarItemGroup(placement: .topBarLeading)
                    {
                        Button("Tap Me")
                        {
                            // button action here
                        }

                        Button("Tap Me 2")
                        {
                            // button action here
                        }
                    }
                }
            
        }
    }
}

#Preview
{
    TollbarButtonsLocations()
}
