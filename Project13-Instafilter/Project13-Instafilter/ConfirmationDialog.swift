//
//  ConfirmationDialog.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 18/11/24.
//

import SwiftUI

struct ConfirmationDialog: View
{
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white

    var body: some View
    {
        Button("Hello, World!")
        {
            showingConfirmation = true
        }
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .confirmationDialog("Change background", isPresented: $showingConfirmation)
        {
            Button("Red") { backgroundColor = .red }
            Button("Green") { backgroundColor = .green }
            Button("Blue") { backgroundColor = .blue }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select a new color")
        }
    }
}

#Preview {
    ConfirmationDialog()
}
