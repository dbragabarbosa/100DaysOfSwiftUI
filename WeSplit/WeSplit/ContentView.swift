//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Braga Barbosa on 18/06/24.
//

import SwiftUI

struct ContentView: View
{
    @State private var CheckAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double
    {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = CheckAmount / 100 * tipSelection
        let grandTotal = CheckAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalForCheck: Double
    {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = CheckAmount / 100 * tipSelection
        let grandTotal = CheckAmount + tipValue
        
        return grandTotal
    }
    
    var isTipZero: Bool
    {
        return tipPercentage == 0
    }
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section
                {
                    TextField("Amount", value: $CheckAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople)
                    {
                        ForEach(2..<100)
                        {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much tip do you want to leave?")
                {
                    Picker("Tip percentage", selection: $tipPercentage)
                    {
                        ForEach(tipPercentages, id: \.self)
                        {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Amount per person")
                {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Total amout for the check")
                {
                    Text(totalForCheck, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(isTipZero ? .red : .black)
                }
            }
            .navigationTitle("WeSplit")
            .toolbar
            {
                if amountIsFocused
                {
                    Button("Done")
                    {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
    
}

#Preview 
{
    ContentView()
}
