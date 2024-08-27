//
//  AnimatingBindings.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 27/08/24.
//

import SwiftUI

struct AnimatingBindings: View 
{
    @State private var animationAmout = 1.0
    
    var body: some View
    {
        print(animationAmout)
        
        return VStack
        {
            Stepper("Scale amount", value: $animationAmout.animation(
                .easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap me")
            {
                animationAmout += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmout)
        }
    }
}

#Preview {
    AnimatingBindings()
}
