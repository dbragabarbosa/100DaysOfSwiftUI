//
//  ComparableForCustomTypes.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 23/12/24.
//

import SwiftUI

struct User: Identifiable, Comparable
{
    let id = UUID()
    var firstName: String
    var lastName: String
    
    static func <(lhs: User, rhs: User) -> Bool
    {
        lhs.lastName < rhs.lastName
    }
}

struct ComparableForCustomTypes: View
{
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister"),
    ].sorted()

    var body: some View
    {
        List(users)
        { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

#Preview
{
    ComparableForCustomTypes()
}
