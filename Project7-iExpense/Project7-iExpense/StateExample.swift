//
//  StateExample.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 25/09/24.
//

import SwiftUI

//struct User
//{
//    var firstName = "Daniel"
//    var lastName = "Braga"
//}

@Observable
class User
{
    var firstName = "Daniel"
        var lastName = "Braga"
}

struct StateExample: View
{
    @State private var user = User()
    
    var body: some View
    {
        VStack
        {
            Text("Seu nome é: \(user.firstName) \(user.lastName)")
            
            TextField("Primeiro nome", text: $user.firstName)
            TextField("Segundo nome", text: $user.lastName)
        }
    }
    
}

#Preview
{
    StateExample()
}
