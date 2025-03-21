//
//  Prospect.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 21/03/25.
//

import SwiftData

@Model
class Prospect
{
    var name: String
    var emailAddress: String
    var isContacted: Bool
    
    init(name: String, emailAddress: String, isContacted: Bool)
    {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
