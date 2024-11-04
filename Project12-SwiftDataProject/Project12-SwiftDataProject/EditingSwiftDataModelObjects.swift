//
//  EditingSwiftDataModelObjects.swift
//  Project12-SwiftDataProject
//
//  Created by Daniel Braga Barbosa on 04/11/24.
//

import SwiftUI
import SwiftData

struct EditingSwiftDataModelObjects: View
{
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) var users: [User]
    @State private var path = [User]()
    
    var body: some View
    {
        NavigationStack(path: $path)
        {
            List(users)
            { user in
                NavigationLink(value: user)
                {
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: User.self)
            { user in
                EditUserView(user: user)
            }
            .toolbar
            {
                Button("Add User", systemImage: "plus")
                {
                    let user = User(name: "", city: "", joinDate: .now)
                    modelContext.insert(user)
                    path = [user]
                }
            }
        }
    }
}

#Preview
{
    EditingSwiftDataModelObjects()
}
