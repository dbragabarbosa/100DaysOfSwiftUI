//
//  ContentView.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 25/09/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable
{
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses
{
    var items: [ExpenseItem] = []
    {
        didSet
        {
            if let encoded = try? JSONEncoder().encode(items)
            {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init()
    {
        if let savedItems = UserDefaults.standard.data(forKey: "Items")
        {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)
            {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View
{
    @State private var bussinessExpenses = Expenses()
    @State private var personalExpenses = Expenses()
    @State private var showingAddExpense: Bool = false
    
    var currencyPreferred = Locale.current.currency?.identifier
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(bussinessExpenses.items)
                { item in
                    
                    HStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        showAmount(item: item)
                    }
                }
                .onDelete(perform: removeItemsBussiness)
            }
            .navigationTitle("iExpense")
            .toolbar
            {
                Button("Add Expense", systemImage: "plus")
                {
                    showingAddExpense = true
                }
            }
        }
        .sheet(isPresented: $showingAddExpense)
        {
            AddView(BusinessExpenses: bussinessExpenses, personalExpenses: personalExpenses, currencyPreferred: currencyPreferred ?? "USD")
        }
    }
    
    func removeItemsBussiness(at offsets: IndexSet)
    {
        bussinessExpenses.items.remove(atOffsets: offsets)
    }
    
    func showAmount(item: ExpenseItem) -> Text
    {
        if item.amount > 100 {
            return Text(item.amount, format: .currency(code: currencyPreferred ?? "USD"))
                .fontWeight(.bold)
        }
        
        if item.amount > 10 {
            return Text(item.amount, format: .currency(code: currencyPreferred ?? "USD"))
                .fontWeight(.semibold)
        }
        
        return Text(item.amount, format: .currency(code: currencyPreferred ?? "USD"))
            .fontWeight(.medium)
    }
}

#Preview {
    ContentView()
}
