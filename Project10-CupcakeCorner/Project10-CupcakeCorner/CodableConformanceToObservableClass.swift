//
//  CodableConformanceToObservableClass.swift
//  Project10-CupcakeCorner
//
//  Created by Daniel Braga Barbosa on 26/10/24.
//

import SwiftUI

@Observable
class User: Codable
{
    enum CodingKeys: String, CodingKey
    {
        case _name = "name"
    }
    
    var name = "Taylor"
}

struct CodableConformanceToObservableClass: View
{
    var body: some View
    {
        Button("Encode Taylor", action: encodeTaylor)
    }
    
    func encodeTaylor()
    {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}

#Preview
{
    CodableConformanceToObservableClass()
}
