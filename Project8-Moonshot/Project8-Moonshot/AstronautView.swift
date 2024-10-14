//
//  AstronautView.swift
//  Project8-Moonshot
//
//  Created by Daniel Braga Barbosa on 14/10/24.
//

import SwiftUI

struct AstronautView: View
{
    let astronaut: Astronaut
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
