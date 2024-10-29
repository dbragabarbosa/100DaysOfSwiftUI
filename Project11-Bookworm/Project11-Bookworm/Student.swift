//
//  Student.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 29/10/24.
//

import Foundation
import SwiftData

//@Observable
@Model
class Student
{
    var id: UUID
    var name: String
    
    init(id: UUID, name: String)
    {
        self.id = id
        self.name = name
    }
}
