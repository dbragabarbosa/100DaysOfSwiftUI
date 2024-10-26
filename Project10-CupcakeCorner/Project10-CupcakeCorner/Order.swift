//
//  Order.swift
//  Project10-CupcakeCorner
//
//  Created by Daniel Braga Barbosa on 26/10/24.
//

import SwiftUI

@Observable
class Order
{
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false
    {
        didSet
        {
            if specialRequestEnabled == false
            {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
}
