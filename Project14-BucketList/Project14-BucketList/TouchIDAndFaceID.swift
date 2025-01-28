//
//  TouchIDAndFaceID.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 26/12/24.
//

import SwiftUI
import LocalAuthentication

struct TouchIDAndFaceID: View
{
    @State private var isUnlocked = false
    @State private var showErrorAlert = false
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate()
    {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            { success, authenticationError in
                // authentication has now completed
                if success
                {
                    // authenticated successfully
                    isUnlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
}

#Preview
{
    TouchIDAndFaceID()
}
