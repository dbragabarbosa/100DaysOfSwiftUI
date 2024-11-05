//
//  Job.swift
//  Project12-SwiftDataProject
//
//  Created by Daniel Braga Barbosa on 05/11/24.
//

import Foundation
import SwiftData

@Model
class Job
{
    var name: String
    var priority: Int
    var owner: User?
    
    init(name: String, priority: Int, owner: User? = nil)
    {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
