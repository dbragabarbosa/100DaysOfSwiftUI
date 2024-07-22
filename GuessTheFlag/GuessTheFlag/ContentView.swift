//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Braga Barbosa on 24/06/24.
//

import SwiftUI

/// Description
struct ContentView: View
{
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score: Int = 0
    @State private var countPlays: Int = 0
    
    var body: some View
    {
        ZStack
        {
//            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack
            {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                VStack(spacing: 15)
                {
                    VStack
                    {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
//                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3)
                    { number in
                        Button
                        {
                            // flag was tapped
                            flagTapped(number)
                        }
                    label:
                        {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore)
        {
            Button("Continue", action: askQuestion)
        }
        message:
        {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int)
    {
        countPlays += 1
        if number == correctAnswer
        {
            scoreTitle = "Correct"
            score += 1
        }
        else
        {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
        }
        
        showingScore = true
    }
    
    func askQuestion()
    {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

#Preview {
    ContentView()
}
