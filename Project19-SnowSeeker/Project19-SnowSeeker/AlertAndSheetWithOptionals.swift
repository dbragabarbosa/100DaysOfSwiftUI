//
//  AlertAndSheetWithOptionals.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 09/05/25.
//

import SwiftUI

struct SheetWithOptionals: View
{
    @State private var selectedUser: User? = nil
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Button("Tap me")
        {
            selectedUser = User()
        }
        .sheet(item: $selectedUser)
        { user in
            
            Text(user.id)
                .presentationDetents([.medium, .large])
        }
    }
}

struct AlertWithOptionals: View
{
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Button("Tap me")
        {
            isShowingUser = true
        }
        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser)
        { user in
            
            Button(user.id) { }
        }
    }
}


struct User: Identifiable
{
    var id = "Taylor Swift"
}

#Preview
{
    SheetWithOptionals()
}

#Preview
{
    AlertWithOptionals()
}
