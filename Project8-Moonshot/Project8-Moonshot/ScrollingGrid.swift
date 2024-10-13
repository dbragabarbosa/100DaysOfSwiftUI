//
//  ScrollingGrid.swift
//  Project8-Moonshot
//
//  Created by Daniel Braga Barbosa on 12/10/24.
//

import SwiftUI

struct ScrollingGrid: View
{
    
    var body: some View
    {
        let layout = [
            GridItem(.fixed(80)),
            GridItem(.fixed(80)),
            GridItem(.fixed(80))
        ]
        
        let layout2 = [
            GridItem(.adaptive(minimum: 80)),
        ]
        
        let layout3 = [
            GridItem(.adaptive(minimum: 80, maximum: 120)),
        ]
        
        ScrollView
        {
            LazyVGrid(columns: layout3)
            {
                ForEach(0..<1000)
                {
                    Text("Item \($0)")
                }
            }
        }
        
        ScrollView(.horizontal)
        {
            LazyHGrid(rows: layout3)
            {
                ForEach(0..<1000)
                {
                    Text("Item \($0)")
                }
            }
        }
    }
}

#Preview {
    ScrollingGrid()
}
