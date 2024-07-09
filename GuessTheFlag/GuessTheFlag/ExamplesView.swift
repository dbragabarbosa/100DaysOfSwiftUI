//
//  ExamplesView.swift
//  GuessTheFlag
//
//  Created by Daniel Braga Barbosa on 09/07/24.
//

import SwiftUI

struct ExamplesView: View
{
    @State private var showingAlert = false
    
    var body: some View
    {
//        ZStack
//        {
//            VStack
//            {
//                Color.red
//                Color.blue
//            }
//
//            Text("Texto text")
//
//            Button("Delect selection", role: .destructive)
//            {
//                print("deleting..")
//            }
//
////                .foregroundStyle(.secondary)
////                .padding(50)
////                .background(.ultraThinMaterial)
//
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .foregroundStyle(.white)
//                .background(.red.gradient)
//
//        }
//        .ignoresSafeArea()
        
        VStack
        {
            Button("Button 1") {}
                .buttonStyle(.bordered)
            Button("Button 2", role: .destructive) {}
                .buttonStyle(.bordered)
            Button("Button3") {}
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            Button("Button4", role: .destructive) {}
                .buttonStyle(.borderedProminent)
            Button
            {
                print("Button was tapped")
            } label: {
                Text("Tap me!")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.red)
            }
            Button
            {
                print("Edit button was tapped")
            } label:
            {
                Image(systemName: "pencil")
            }
            Button("Edit", systemImage: "pencil")
            {
                print("Edit button was taped")
            }
            Button
            {
                print("Edit button was tapped")
            } label:
            {
                Label("Edit", systemImage: "pencil")
                    .padding()
                    .foregroundStyle(.white)
                    .background()
            }
            
            Button("Show alert")
            {
                showingAlert = true
            }
            .alert("Important message", isPresented: $showingAlert)
            {
                Button("Delete", role: .destructive) {}
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please read this")
            }
        }
    }
}

#Preview {
    ContentView()
}
