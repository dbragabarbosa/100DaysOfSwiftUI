//
//  ImageInterpolation.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 13/03/25.
//

import SwiftUI

struct ImageInterpolation: View
{
    var body: some View
    {
        Image(.example)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .background(.black)
    }
}

#Preview {
    ImageInterpolation()
}
