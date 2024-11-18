//
//  PropertyWrappersIntoStructs.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 18/11/24.
//

import SwiftUI

//struct PropertyWrappersIntoStructs: View
//{
//    @State private var blurAmount = 0.0
//
//    var body: some View
//    {
//        VStack
//        {
//            Text("Hello, World!")
//                .blur(radius: blurAmount)
//
//            Slider(value: $blurAmount, in: 0...20)
//
//            Button("Random Blur") {
//                blurAmount = Double.random(in: 0...20)
//            }
//        }
//    }
//}


struct PropertyWrappersIntoStructs: View
{
    @State private var blurAmount = 0.0

    var body: some View
    {
        VStack
        {
            Text("Hello, World!")
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value is \(newValue)")
                }
        }
    }
}


#Preview
{
    PropertyWrappersIntoStructs()
}
