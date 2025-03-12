//
//  SelectItemsInAList.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 12/03/25.
//

import SwiftUI

struct SelectItemsInAList: View
{
    @State private var selection = Set<String>()
    
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    
    var body: some View
    {
        EditButton()
        
        List(users, id: \.self, selection: $selection)
        { user in
            
            Text(user)
        }
        
        if selection.isEmpty == false
        {
            Text("You selected: \(selection.formatted())")
        }
    }
}

#Preview
{
    SelectItemsInAList()
}
