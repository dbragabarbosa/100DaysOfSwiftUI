//
//  MakingViewSearchable.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 09/05/25.
//

import SwiftUI

struct MakingViewSearchable: View
{
    @State private var searchText = ""
    
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]

    var filteredNames: [String]
    {
        if searchText.isEmpty
        {
            allNames
        }
        else
        {
            allNames.filter { $0.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            List(filteredNames, id: \.self)
            { name in
                
                Text(name)
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }
}

#Preview
{
    MakingViewSearchable()
}
