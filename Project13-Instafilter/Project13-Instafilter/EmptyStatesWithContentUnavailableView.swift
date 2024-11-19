//
//  EmptyStatesWithContentUnavailableView.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 19/11/24.
//

import SwiftUI

struct EmptyStatesWithContentUnavailableView: View
{
    var body: some View
    {
//        ContentUnavailableView("No snippets", systemImage: "swift")
//        
//        ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))

        ContentUnavailableView
        {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet.")
        } actions: {
            Button("Create Snippet")
            {
                // create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview
{
    EmptyStatesWithContentUnavailableView()
}
