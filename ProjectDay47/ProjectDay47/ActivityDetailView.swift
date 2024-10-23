//
//  ActivityDetailView.swift
//  ProjectDay47
//
//  Created by Daniel Braga Barbosa on 23/10/24.
//

import SwiftUI

struct ActivityDetailView: View
{
    var activity: Activity
    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            Text(activity.name)
                .font(.headline)
                .foregroundStyle(.black)
            
            Text(activity.description)
                .font(.caption)
                .padding()
                .foregroundStyle(.black.opacity(0.5))
            
            Spacer()
        }
        .navigationTitle(activity.name)
    }
}

#Preview
{
    let exampleActivity = Activity(name: "Teste", description: "Teste descrição", count: 5)
    ActivityDetailView(activity: exampleActivity)
}
