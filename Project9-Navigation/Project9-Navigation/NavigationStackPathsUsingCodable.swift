//
//  NavigationStackPathsUsingCodable.swift
//  Project9-Navigation
//
//  Created by Daniel Braga Barbosa on 17/10/24.
//

import SwiftUI

@Observable
class PathStoreIntArray
{
    var path: [Int]
    {
        didSet
        {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init()
    {
        if let data = try? Data(contentsOf: savePath)
        {
            if let decoded = try? JSONDecoder().decode([Int].self, from: data)
            {
                path = decoded
                return
            }
        }
        
        //Start with an empty path
        path = []
    }
    
    func save()
    {
        do
        {
            let data = try JSONEncoder().encode(path)
            try data.write(to: savePath)
        }
        catch
        {
            print("Failed to save navigation data")
        }
    }
}


@Observable
class PathStoreNavigationPath
{
    var path: NavigationPath
    {
        didSet
        {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init()
    {
        if let data = try? Data(contentsOf: savePath)
        {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data)
            {
                path = NavigationPath(decoded)
                return
            }
        }
        
        //Start with an empty path
        path = NavigationPath()
    }
    
    func save()
    {
        guard let representation = path.codable else { return }
        
        do
        {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        }
        catch
        {
            print("Failed to save navigation data")
        }
    }
}


struct NewDetailView: View
{
    var number: Int

    var body: some View
    {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}


struct NavigationStackPathsUsingCodable: View
{
//    @State private var pathStore = PathStore()
    @State private var pathStore = PathStoreNavigationPath()

    var body: some View
    {
        NavigationStack(path: $pathStore.path)
        {
            NewDetailView(number: 0)
                .navigationDestination(for: Int.self)
                { i in
                    NewDetailView(number: i)
                }
        }
    }
}

#Preview {
    NavigationStackPathsUsingCodable()
}
