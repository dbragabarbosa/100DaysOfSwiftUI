//
//  ContentView.swift
//  ProjectDay47
//
//  Created by Daniel Braga Barbosa on 21/10/24.
//

import SwiftUI

struct Activity: Identifiable, Codable
{
    var id = UUID()
    let name: String
    let description: String
    let count: Int
}

@Observable
class AllActivities
{
    var activities = [Activity]()
    {
        didSet
        {
            if let encoded = try? JSONEncoder().encode(activities)
            {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init()
    {
        if let savedActivities = UserDefaults.standard.data(forKey: "Activities")
        {
            if let decodedActivities = try? JSONDecoder().decode([Activity].self, from: savedActivities)
            {
                activities = decodedActivities
                return
            }
        }
        
        activities = []
    }
}

struct ContentView: View
{
    @State private var allActivities = AllActivities()
    @State private var showingAddActivity = false
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(allActivities.activities)
                { activity in
//                    NavigationLink(destination: ActivityDetailView(activity: activity))
                    NavigationLink(activity.name)
                    {
                        ActivityDetailView(activity: activity)
                        
//                        HStack
//                        {
//                            VStack(alignment: .leading)
//                            {
//                                Text(activity.name)
//                                    .font(.headline)
//                                Text(activity.description)
//                            }
//                        }
                    }
                }
                .onDelete(perform: removeActivity)
            }
            .navigationTitle("Habit Tracking")
            .toolbar
            {
                Button("Add activity", systemImage: "plus")
                {
                    showingAddActivity = true
                }
            }
            .sheet(isPresented: $showingAddActivity)
            {
                AddActivityView(activities: allActivities)
            }
        }
    }
    
    func removeActivity(at offsets: IndexSet)
    {
        allActivities.activities.remove(atOffsets: offsets)
    }
}

#Preview
{
    ContentView()
}
