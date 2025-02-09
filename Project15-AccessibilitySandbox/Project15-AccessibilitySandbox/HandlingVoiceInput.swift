//
//  HandlingVoiceInput.swift
//  Project15-AccessibilitySandbox
//
//  Created by Daniel Braga Barbosa on 03/02/25.
//

import SwiftUI

struct HandlingVoiceInput: View
{
    var body: some View
    {
        Button("John Fitzgerald Kennedy")
        {
            print("Button tapped")
        }
        .accessibilityInputLabels(["John Fitzgerald Kennedy", "Kennedy", "JFK"])
    }
}

#Preview
{
    HandlingVoiceInput()
}
