//
//  OnDeleteExample.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 08/10/24.
//

import SwiftUI

struct OnDeleteExampleView: View
{
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(numbers, id: \.self)
                {
                    Text("Row \($0)")
                }
                .onDelete(perform: removeRows)
            }
            
            Button("Add number")
            {
                numbers.append(currentNumber)
                currentNumber += 1
            }
        }
    }
    
    
    func removeRows(at offsets: IndexSet)
    {
        numbers.remove(atOffsets: offsets)
    }
    
}
