//
//  ContentView.swift
//  ProjectDay47
//
//  Created by Daniel Braga Barbosa on 21/10/24.
//

import SwiftUI

struct Activity: Identifiable
{
    let id = UUID()
    let name: String
    let description: String
    let count: Int
}

@Observable
class AllActivities
{
    var activities = [Activity]()
}

struct ContentView: View
{
    @State private var allActivities = AllActivities()
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(allActivities.activities)
                { activity in
                    Text(activity.name)
                }
                .onDelete(perform: removeActivity)
            }
            .toolbar
            {
                Button("Add activity", systemImage: "plus")
                {
                    let activity = Activity(name: "Test", description: "Teste", count: 3)
                    allActivities.activities.append(activity)
                }
            }
            .navigationTitle("Habit Tracking")
        }
    }
    
    func removeActivity(at offsets: IndexSet)
    {
        allActivities.activities.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
