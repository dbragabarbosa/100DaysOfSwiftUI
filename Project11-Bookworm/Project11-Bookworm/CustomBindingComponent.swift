//
//  CustomBindingComponent.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 29/10/24.
//

import SwiftUI

struct PushButtom: View
{
    let title: String
//    @State var isOn: Bool
    @Binding var isOn: Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View
    {
        Button(title)
        {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.white)
        .clipShape(.capsule)
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct CustomBindingComponent: View
{
    @State private var rememberMe = false
    
    var body: some View
    {
        VStack
        {
            PushButtom(title: "Remember me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

#Preview
{
    CustomBindingComponent()
}
