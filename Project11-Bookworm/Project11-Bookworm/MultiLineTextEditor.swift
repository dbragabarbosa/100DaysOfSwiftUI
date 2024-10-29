//
//  MultiLineTextEditor.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 29/10/24.
//

import SwiftUI

struct MultiLineTextEditor: View
{
    @AppStorage("notes") private var notes = ""
    
    var body: some View
    {
        NavigationStack
        {
//            TextEditor(text: $notes)
//                .navigationTitle("Notes")
//                .padding()
//            Form
//            {
                TextField("Enter your text", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .navigationTitle("Notes")
                    .padding()
//            }
        }
    }
}

#Preview {
    MultiLineTextEditor()
}
