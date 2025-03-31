//
//  GesturesInSwiftUI.swift
//  Project17-Flashzilla
//
//  Created by Daniel Braga Barbosa on 31/03/25.
//

import SwiftUI

struct GesturesInSwiftUI: View
{
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    @State private var currentAmountAngle = Angle.zero
    @State private var finalAmountAngle = Angle.zero
    
    var body: some View
    {
        Text("Hello, World!")
            .onTapGesture(count: 2) {
                print("Double tapped!")
            }
        
        Text("Hello, World!")
            .onLongPressGesture {
                print("Long pressed!")
            }
        
        Text("Hello, World!")
            .onLongPressGesture(minimumDuration: 2) {
                print("Long pressed!")
            }
        
        Text("Hello, World!")
            .onLongPressGesture(minimumDuration: 1) {
                print("Long pressed!")
            } onPressingChanged: { inProgress in
                print("In progress: \(inProgress)!")
            }
        
        Text("Hello, World!")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification - 1
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
        
        Text("Hello, World!")
            .rotationEffect(currentAmountAngle + finalAmountAngle)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        currentAmountAngle = value.rotation
                    }
                    .onEnded { value in
                        finalAmountAngle += currentAmountAngle
                        currentAmountAngle = .zero
                    }
            )
        
        
        VStack
        {
            Text("Hello, World!")
                .onTapGesture
                {
                    print("Text tapped")
                }
        }
        .onTapGesture
        {
            print("VStack tapped")
        }
        
        
        VStack
        {
            Text("Hello, World!")
                .onTapGesture
                {
                    print("Text tapped")
                }
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded
                {
                    print("VStack tapped")
                }
        )
        
        
        VStack
        {
            Text("Hello, World!")
                .onTapGesture
                {
                    print("Text tapped")
                }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded
                {
                    print("VStack tapped")
                }
        )
        
    }
}

struct gestureSequencing: View
{
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View
    {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation
                {
                    isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}

#Preview
{
    GesturesInSwiftUI()
}

#Preview
{
    gestureSequencing()
}
