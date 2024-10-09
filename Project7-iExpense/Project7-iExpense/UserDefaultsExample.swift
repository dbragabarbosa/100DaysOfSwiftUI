//
//  UserDefaultsExample.swift
//  Project7-iExpense
//
//  Created by Daniel Braga Barbosa on 08/10/24.
//

import SwiftUI

//struct UserDefaultsExample: View
//{
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
//    
//    var body: some View
//    {
//        Button("Tap count: \(tapCount)")
//        {
//            tapCount += 1
//            UserDefaults.standard.set(tapCount, forKey: "Tap")
//        }
//    }
//}

struct UserDefaultsExample: View
{
    @AppStorage("tapCount") private var tapCount = 0
    
    var body: some View
    {
        Button("Tap count: \(tapCount)")
        {
            tapCount += 1
        }
    }
}
