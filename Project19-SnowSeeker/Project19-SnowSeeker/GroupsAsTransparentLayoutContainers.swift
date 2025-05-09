//
//  GroupsAsTransparentLayoutContainers.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 09/05/25.
//

import SwiftUI

struct GroupsAsTransparentLayoutContainers: View
{
    @State private var layoutVertically = false
    
    var body: some View
    {
        Button
        {
            layoutVertically.toggle()
        }
        label:
        {
            if layoutVertically
            {
                VStack
                {
                    UserView()
                }
            }
            else
            {
                HStack
                {
                    UserView()
                }
            }
        }
    }
}

struct UsingSizeClass: View
{
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View
    {
        if horizontalSizeClass == .compact
        {
            VStack(content: UserView.init)
        }
        else
        {
            HStack(content: UserView.init)
        }
    }
}

struct UsingViewThatFits: View
{
    var body: some View
    {
        ViewThatFits
        {
            Rectangle()
                .frame(width: 500, height: 200)
            
            Circle()
                .frame(width: 200, height: 200)
        }
    }
}

struct UserView: View
{
    var body: some View
    {
        Group
        {
            Text("Name: Paul")
            Text("Country: England")
            Text("Pets: Luna and Arya")
        }
        .font(.title)
    }
}

#Preview
{
    GroupsAsTransparentLayoutContainers()
}

#Preview
{
    UsingSizeClass()
}

#Preview
{
    UsingViewThatFits()
}
