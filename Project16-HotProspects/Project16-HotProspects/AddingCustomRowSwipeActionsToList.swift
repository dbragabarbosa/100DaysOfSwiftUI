//
//  AddingCustomRowSwipeActionsToList.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 17/03/25.
//

import SwiftUI

struct AddingCustomRowSwipeActionsToList: View
{
    
    
    var body: some View
    {
        List
        {
            Text("Taylor Swift")
                .swipeActions
                {
                    Button("Send message", systemImage: "message")
                    {
                        print("Hi")
                    }
                }
            
            Text("Taylor Swift")
                .swipeActions
                {
                    Button("Delete", systemImage: "minus.circle", role: .destructive)
                    {
                        print("Deleting")
                    }
                }
                .swipeActions(edge: .leading)
                {
                    Button("Pin", systemImage: "pin")
                    {
                        print("Pinning")
                    }
                    .tint(.orange)
                }
        }
    }
}

#Preview
{
    AddingCustomRowSwipeActionsToList()
}
