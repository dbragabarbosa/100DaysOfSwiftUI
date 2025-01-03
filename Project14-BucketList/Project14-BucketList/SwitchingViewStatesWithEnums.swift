//
//  SwitchingViewStatesWithEnums.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 23/12/24.
//

import SwiftUI

enum LoadingStateExample
{
    case loading, success, failed
}

struct LoadingView: View
{
    var body: some View
    {
        Text("Loading...")
    }
}

struct SuccessView: View
{
    var body: some View
    {
        Text("Success!")
    }
}

struct FailedView: View
{
    var body: some View
    {
        Text("Failed.")
    }
}

struct SwitchingViewStatesWithEnums: View
{
    @State private var loadingStateExample = LoadingStateExample.loading
    
    var body: some View
    {
        switch loadingStateExample
        {
            case .loading:
                LoadingView()
            case .success:
                SuccessView()
            case .failed:
                FailedView()
        }
    }
}

#Preview
{
    SwitchingViewStatesWithEnums()
}
