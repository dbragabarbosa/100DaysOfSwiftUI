//
//  HidingAndGroupingAccessibilityData.swift
//  Project15-AccessibilitySandbox
//
//  Created by Daniel Braga Barbosa on 28/01/25.
//

import SwiftUI

struct HidingAndGroupingAccessibilityData: View
{
    var body: some View
    {
        Image(decorative: "character")
            .accessibilityHidden(true)
        
        VStack
        {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
//        .accessibilityElement(children: .combine)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Your score is 1000")

    }
}

#Preview {
    HidingAndGroupingAccessibilityData()
}
