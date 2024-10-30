//
//  Book.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 30/10/24.
//

import Foundation
import SwiftData

@Model
class Book
{
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    
    init(title: String, author: String, genre: String, review: String, rating: Int)
    {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
