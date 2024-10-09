//
//  CodableExample.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 08/10/24.
//

import SwiftUI

struct UserNames: Codable
{
    let firstName: String
    let lastName: String
}

struct CodableExample: View
{
    @State private var user = UserNames(firstName: "Taylor", lastName: "Swift")
    
    var body: some View
    {
        Button("Save user")
        {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user)
            {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

#Preview {
    CodableExample()
}
