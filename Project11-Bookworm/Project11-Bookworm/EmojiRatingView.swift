//
//  EmojiRatingView.swift
//  Project11-Bookworm
//
//  Created by Daniel Braga Barbosa on 30/10/24.
//

import SwiftUI

struct EmojiRatingView: View
{
    let rating: Int
    
    var body: some View
    {
        switch rating
        {
        case 1:
            Text("")
        case 2:
            Text("2")
        case 3:
            Text("3")
        case 4:
            Text("4")
        default:
            Text("5")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 5)
}
