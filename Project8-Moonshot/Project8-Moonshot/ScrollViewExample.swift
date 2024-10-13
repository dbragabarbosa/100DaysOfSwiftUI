//
//  ScrollViewExample.swift
//  Project8-Moonshot
//
//  Created by Daniel Braga Barbosa on 12/10/24.
//

import SwiftUI

struct CustomText: View
{
    let text: String
    
    var body: some View
    {
        Text(text)
    }
    
    init(_ text: String)
    {
        print("Creating a new CustomText")
        self.text = text
    }
}


struct ScrollViewExample: View
{
    
    
    var body: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 10)
            {
                ForEach(0..<100)
                {
//                    Text("Item \($0)")
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
        }
    }
}

#Preview
{
    ScrollViewExample()
}
