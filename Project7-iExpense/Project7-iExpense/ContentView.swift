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
    @State private var expenses = Expenses()
    @State private var showingAddExpense: Bool = false
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(expenses.items)
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
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar
            {
                Button("Add Expense", systemImage: "plus")
                {
//                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                    expenses.items.append(expense)
                    showingAddExpense = true
                }
            }
        }
        .sheet(isPresented: $showingAddExpense)
        {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet)
    {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
