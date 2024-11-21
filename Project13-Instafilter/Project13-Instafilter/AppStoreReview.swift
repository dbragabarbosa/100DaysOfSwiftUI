//
//  AppStoreReview.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 21/11/24.
//

import SwiftUI
import StoreKit

struct AppStoreReview: View
{
    @Environment(\.requestReview) var requestReview
    
    var body: some View
    {
        Spacer()
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Spacer()
        
        Button("Leave a review")
        {
            requestReview()
        }
        
        Spacer()
    }
}

#Preview
{
    AppStoreReview()
}
