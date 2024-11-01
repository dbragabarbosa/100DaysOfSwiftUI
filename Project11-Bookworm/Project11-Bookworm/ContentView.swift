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
    
    @Query(sort: [
        SortDescriptor(\Book.rating, order: .reverse),
        SortDescriptor(\Book.author)
    ]) var books: [Book]
    
    @State private var showingAddScreen = false
    
    var body: some View
    {
        NavigationStack
        {
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
                                if book.rating == 1
                                {
                                    Text(book.title)
                                        .font(.headline)
                                        .background(.red)
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self)
            { book in
                DetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button("Add book", systemImage: "plus")
                    {
                        showingAddScreen.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading)
                {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showingAddScreen)
        {
            AddBookView()
        }
    }
    
    func deleteBooks(at offsets: IndexSet)
    {
        for offset in offsets
        {
            // find the book in the query
            let book = books[offset]
            
            // delete it from the context
            modelContext.delete(book)
        }
    }
    
}

#Preview
{
    ContentView()
}
