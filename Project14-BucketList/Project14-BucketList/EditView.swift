//
//  EditView.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 27/12/24.
//

import SwiftUI

struct EditView: View
{
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var description: String
    
    var location: Location
    
    var onSave: (Location) -> Void
    
    init(location: Location, onSave: @escaping (Location) -> Void)
    {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section
                {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar
            {
                Button("Save")
                {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)

                    dismiss()
                }
            }
        }
    }
}

#Preview
{
    EditView(location: .example) { _ in}
}
