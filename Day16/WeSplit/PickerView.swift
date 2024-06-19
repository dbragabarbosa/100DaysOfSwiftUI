//
//  PickerView.swift
//  WeSplit
//
//  Created by Daniel Braga Barbosa on 19/06/24.
//

import SwiftUI

struct PickerView: View 
{
    let students = ["Daniel", "Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Picker("Select your student", selection: $selectedStudent)
                {
                    ForEach(students, id: \.self)
                    {
                        Text($0)
                    }
                }
            }
        }
    }
}

#Preview 
{
    PickerView()
}
