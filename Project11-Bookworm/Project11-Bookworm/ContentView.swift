//
//  ContentView.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 29/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View
{
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    
    @State private var showingAddScreen = false
    
    var body: some View
    {
        NavigationStack
        {
//            Text("Count: \(books.count)")
            
            List
            {
                ForEach(books)
                { book in
                    NavigationLink(value: book)
                    {
                        HStack
                        {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading)
                            {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            
            
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Button("Add book", systemImage: "plus")
                        {
                            showingAddScreen.toggle()
                        }
                    }
                }
        }
        .sheet(isPresented: $showingAddScreen)
        {
            AddBookView()
        }
    }
}

#Preview
{
    ContentView()
}
