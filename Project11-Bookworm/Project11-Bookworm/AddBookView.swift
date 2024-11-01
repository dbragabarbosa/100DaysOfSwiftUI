//
//  AddBookView.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 30/10/24.
//

import SwiftUI

struct AddBookView: View
{
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section
                {
                    TextField("Name of the book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre)
                    {
                        ForEach(genres, id: \.self)
                        {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review")
                {
                    TextEditor(text: $review)
                    
//                    Picker("Rating", selection: $rating)
//                    {
//                        ForEach(0..<6)
//                        {
//                            Text(String($0))
//                        }
//                    }
                    
                    RatingView(rating: $rating)
                }
                
                Section
                {
                    Button("Save")
                    {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: Date.now)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || author.isEmpty || genre.isEmpty)
            }
            .navigationTitle("Add book")
        }
    }
}

#Preview {
    AddBookView()
}
