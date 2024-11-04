//
//  User.swift
//  Project12-SwiftDataProject
//
//  Created by Daniel Braga Barbosa on 04/11/24.
//

import Foundation
import SwiftData

@Model
class User
{
    var name: String
    var city: String
    var joinDate: Date
    
    init(name: String, city: String, joinDate: Date)
    {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
