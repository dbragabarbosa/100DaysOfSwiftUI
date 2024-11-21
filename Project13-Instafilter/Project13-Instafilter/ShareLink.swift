//
//  ShareLink.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 21/11/24.
//

import SwiftUI

struct ShareLink: View
{
    let example = Image(.example)
    
    var body: some View
    {
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
        
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
        
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
            Label("Spread the word about Swift", systemImage: "swift")
        }
        
        ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
            Label("Click to share", systemImage: "airplane")
    }
}

#Preview {
    ShareLink()
}
