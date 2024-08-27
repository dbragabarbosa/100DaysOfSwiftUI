//
//  ExplicitAnimations.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 27/08/24.
//

import SwiftUI

struct ExplicitAnimations: View 
{
    @State private var animationAmout = 0.0
    
    var body: some View
    {
        Button("Tap me")
        {
            //
//            withAnimation
//            {
//                animationAmout += 360
//            }            
            withAnimation(.spring(duration: 2, bounce: 0.5))
            {
                animationAmout += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .rotation3DEffect(
            .degrees(animationAmout), axis: (x: 0, y: 1, z: 0)
        )
    }
}

#Preview {
    ExplicitAnimations()
}
