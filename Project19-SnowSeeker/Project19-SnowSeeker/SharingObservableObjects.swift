//
//  SharingObservableObjects.swift
//  Project19-SnowSeeker
//
//  Created by Daniel Braga Barbosa on 09/05/25.
//

import SwiftUI

@Observable
class Player
{
    var name = "Anonymous"
    var highScore = 0
}

struct HighScoreView: View
{
//    var player: Player
    
    @Environment(Player.self) var player
    
    var body: some View
    {
        Text("Your high score: \(player.highScore)")
        
        @Bindable var player = player
        
        Stepper("High score: \(player.highScore)", value: $player.highScore)
    }
}

struct SharingObservableObjects: View
{
    @State private var player = Player()
    
    var body: some View
    {
        VStack
        {
            Text("Welcome")
            
//            HighScoreView(player: player)
            HighScoreView()
        }
        .environment(player)
    }
}

#Preview
{
    SharingObservableObjects()
}
