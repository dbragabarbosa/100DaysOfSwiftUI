//
//  ContentViewTests.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 26/08/24.
//

import SwiftUI

struct ContentViewTests: View 
{
    @State private var animationAmount = 1.0
    
    var body: some View
    {
        Button("Tap me")
        {
            //
//            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear
        {
            animationAmount = 2
        }
//        .scaleEffect(animationAmount)
//        .blur(radius: (animationAmount - 1) * 3)
//        .animation(.linear, value: animationAmount)
//        .animation(.spring(duration: 1, bounce: 0.9), value: animationAmount)
//        .animation(.easeInOut(duration: 2), value: animationAmount)
//        .animation(
//            .easeInOut(duration: 2)
//                .delay(1),
//            value: animationAmount
//        )        
//        .animation(
//            .easeInOut(duration: 1)
//                .repeatCount(3, autoreverses: true),
//            value: animationAmount
//        )        
//        .animation(
//            .easeInOut(duration: 1)
//                .repeatForever(autoreverses: true),
//            value: animationAmount
//        )
    }
}

#Preview 
{
    ContentViewTests()
}
