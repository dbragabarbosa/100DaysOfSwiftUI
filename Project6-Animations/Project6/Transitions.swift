//
//  Transitions.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 03/09/24.
//

import SwiftUI

struct Transitions: View 
{
    @State private var isShowingRed = false
    
    var body: some View
    {
        VStack
        {
            Button("Tap me")
            {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed
            {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
//                    .transition(.scale)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

#Preview {
    Transitions()
}
