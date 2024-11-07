//
//  StateExample.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 25/09/24.
//

import SwiftUI
import Observation
import SwiftData

//struct User
//{
//    var firstName = "Daniel"
//    var lastName = "Braga"
//}

//@Observable
@Model
class User
{
    var firstName = "Daniel"
    var lastName = "Braga"
    
    init(firstName: String = "Daniel", lastName: String = "Braga")
    {
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct StateExample: View
{
    @State private var user = User()
    
    @State private var showingSheet = false
    
    var body: some View
    {
        VStack
        {
            Text("Seu nome é: \(user.firstName) \(user.lastName)")
            
            TextField("Primeiro nome", text: $user.firstName)
            TextField("Segundo nome", text: $user.lastName)
        }
        
        Spacer()
        
        Button("Show Sheet")
        {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet)
        {
            SecondView(name: "Daniel")
        }
    }
    
}

struct SecondView: View
{
    @Environment(\.dismiss) var dismiss
    let name: String
    
    var body: some View
    {
        Spacer()
        Text("Second View")
        Spacer()
        Text("Hello, \(name)!")
        Spacer()
        Button("Dismiss")
        {
            dismiss()
        }
        Spacer()
    }
}

#Preview
{
    StateExample()
}
