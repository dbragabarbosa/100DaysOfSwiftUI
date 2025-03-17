//
//  AddingSwiftPackageDependencies.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 17/03/25.
//

import SwiftUI
import SamplePackage

struct AddingSwiftPackageDependencies: View
{
    let possibleNumbers = 1...60
    
    var results: String
    {
        let selected = possibleNumbers.random(7).sorted()
        
        let strings = selected.map(String.init)
        
        return strings.formatted()
    }
    
    var body: some View
    {
        Text(results)
    }
}

#Preview
{
    AddingSwiftPackageDependencies()
}
