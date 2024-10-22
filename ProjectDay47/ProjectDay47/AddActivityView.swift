//
//  AddActivityView.swift
//  ProjectDay47
//
//  Created by Daniel Braga Barbosa on 22/10/24.
//

import SwiftUI

struct AddActivityView: View
{
    @State private var name = ""
    @State private var description = ""
    
    @Environment(\.dismiss) var dismiss
    
    var activities: AllActivities

    var body: some View
    {
        NavigationStack
        {
            Form
            {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add new activity")
            .toolbar
            {
                Button("Save")
                {
                    let activity = Activity(name: name, description: description, count: 0)
                    activities.activities.append(activity)
                    dismiss()
                }
            }
        }
    }
}

#Preview
{
    AddActivityView(activities: AllActivities())
}
