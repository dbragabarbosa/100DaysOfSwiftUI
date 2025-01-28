//
//  ReadingTheValueOfControls.swift
//  Project15-AccessibilitySandbox
//
//  Created by Daniel Braga Barbosa on 28/01/25.
//

import SwiftUI

struct ReadingTheValueOfControls: View
{
    @State private var value = 10

    var body: some View
    {
        VStack
        {
            Text("Value: \(value)")

            Button("Increment")
            {
                value += 1
            }

            Button("Decrement")
            {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction
        { direction in
            switch direction
            {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled.")
            }
        }
    }
}

#Preview {
    ReadingTheValueOfControls()
}
