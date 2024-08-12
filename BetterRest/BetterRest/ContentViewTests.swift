//
//  ContentViewTests.swift
//  BetterRest
//
//  Created by Daniel Braga Barbosa on 09/08/24.
//

import SwiftUI

struct ContentViewTests: View 
{
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
        
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        
        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .date)
            .labelsHidden()
    }
    
    func exampleDates() 
    {
        // create a second Date instance set to one day in seconds from now
        let tomorrow = Date.now.addingTimeInterval(86400)

        // create a range from those two
        let range = Date.now...tomorrow
    }
}

#Preview 
{
    ContentViewTests()
}
