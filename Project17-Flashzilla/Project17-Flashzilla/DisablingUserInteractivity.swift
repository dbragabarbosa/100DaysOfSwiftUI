//
//  DisablingUserInteractivity.swift
//  Project17-Flashzilla
//
//  Created by Daniel Braga Barbosa on 31/03/25.
//

import SwiftUI

struct DisablingUserInteractivity: View
{
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture
                {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .contentShape(.rect)
                .onTapGesture
                {
                    print("Circle tapped!")
                }
                .allowsHitTesting(false)
        }
        
        
        VStack
        {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .onTapGesture
        {
            print("VStack tapped!")
        }
        
        
        VStack
        {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(.rect)
        .onTapGesture
        {
            print("VStack tapped!")
        }
        
    }
}

#Preview
{
    DisablingUserInteractivity()
}
