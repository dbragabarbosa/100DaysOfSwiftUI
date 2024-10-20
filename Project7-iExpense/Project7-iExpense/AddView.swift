//
//  AddView.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 10/10/24.
//

import SwiftUI

struct AddView: View
{
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var issueName: String = "Issue name"
    
    @Environment(\.dismiss) var dismiss
    
    let types = ["Business", "Personal"]
    var BusinessExpenses: Expenses
    var personalExpenses: Expenses
    var currencyPreferred: String
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
//                TextField("Name", text: $name)
                
                Picker("Type", selection: $type)
                {
                    ForEach(types, id: \.self)
                    {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: currencyPreferred))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($issueName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                Button("Save")
                {
                    let item = ExpenseItem(name: issueName, type: type, amount: amount)
                    if item.type == "Business"{
                        BusinessExpenses.items.append(item)
                    }
                    else {
                        personalExpenses.items.append(item)
                    }
                    dismiss()
                }
            }
//            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddView(BusinessExpenses: Expenses(), personalExpenses: Expenses(), currencyPreferred: "BRL")
}
