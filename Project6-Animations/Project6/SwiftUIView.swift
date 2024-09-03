//
//  SwiftUIView.swift
//  Project6
//
//  Created by Daniel Braga Barbosa on 03/09/24.
//

import SwiftUI

struct SwiftUIView: View 
{
    @State private var enabled = false
    
    var body: some View
    {
        Button("Tap me")
        {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(duration: 1, bounce: 0.6), value: enabled)
    }
}

#Preview {
    SwiftUIView()
}
