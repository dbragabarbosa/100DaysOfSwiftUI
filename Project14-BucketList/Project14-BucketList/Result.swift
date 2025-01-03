//
//  Result.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 03/01/25.
//

import Foundation

struct Result: Decodable
{
    let query: Query
}

struct Query: Codable
{
    let pages: [Int: Page]
}

struct Page: Codable, Comparable
{
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String
    {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool
    {
        lhs.title < rhs.title
    }
}
