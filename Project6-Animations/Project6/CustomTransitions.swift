//
//  CustomTransitions.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 03/09/24.
//

import SwiftUI

struct CustomTransitions: View 
{
    @State private var isShowingRed = false
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed
            {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture 
        {
            withAnimation
            {
                isShowingRed.toggle()
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier
{
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition
{
    static var pivot: AnyTransition
    {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

#Preview {
    CustomTransitions()
}
