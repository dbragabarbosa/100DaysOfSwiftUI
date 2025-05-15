//
//  ContentView.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 08/05/25.
//

import SwiftUI

struct ContentView: View
{
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    
    @State private var favorites = Favorites()
    
    var filteredResort: [Resort]
    {
        if searchText.isEmpty
        {
            resorts
        }
        else
        {
            resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View
    {
        NavigationSplitView
        {
            List(filteredResort)
            { resort in
                
                NavigationLink(value: resort)
                {
                    HStack
                    {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading)
                        {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort)
                        {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self)
            { resort in
                
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
        }
        detail:
        {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview
{
    ContentView()
}
