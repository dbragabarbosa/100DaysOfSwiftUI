//
//  EditView.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 27/12/24.
//

import SwiftUI

enum LoadingState
{
    case loading
    case loaded
    case failed
}

struct EditView: View
{
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState: LoadingState = .loading
    @State private var pages = [Page]()
    
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
                
                Section("Nearby...")
                {
                    switch loadingState
                    {
                        case .loaded:
                            ForEach(pages, id: \.pageid)
                            { page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                    .italic()
                            }
                        case .loading:
                            Text("Loading...")
                        case .failed:
                            Text("Please try again later.")
                    }
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
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    func fetchNearbyPlaces() async
    {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)

            let items = try JSONDecoder().decode(Result.self, from: data)

            pages = items.query.pages.values.sorted() { $0.title < $1.title }
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}

#Preview
{
    EditView(location: .example) { _ in}
}
