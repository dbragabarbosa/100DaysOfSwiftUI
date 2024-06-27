//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Braga Barbosa on 24/06/24.
//

import SwiftUI

struct ContentView: View 
{
    var body: some View 
    {
        ZStack
        {
            Color.red
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
            Text("Texto text")
        }
//        .background(.red)
    }
}

#Preview {
    ContentView()
}
