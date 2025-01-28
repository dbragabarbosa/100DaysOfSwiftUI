//
//  IdentifyindViewsWithUsefulLabelsWithButton.swift
//  Project15-AccessibilitySandbox
//
//  Created by Daniel Braga Barbosa on 28/01/25.
//

import SwiftUI

struct IdentifyindViewsWithUsefulLabelsWithButton: View
{
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View
    {
        Button {
            selectedPicture = Int.random(in: 0...3)
        } label: {
            Image(pictures[selectedPicture])
                .resizable()
                .scaledToFit()
        }
        .accessibilityLabel(labels[selectedPicture])
    }
}

#Preview {
    IdentifyindViewsWithUsefulLabelsWithButton()
}
