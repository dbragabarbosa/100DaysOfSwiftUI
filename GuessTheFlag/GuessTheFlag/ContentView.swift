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
    
    @State private var rotationDegrees = [0.0, 0.0, 0.0]
    @State private var selectedFlag: Int? = nil
    
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
                    .largeBlueTitle()

                VStack(spacing: 15)
                {
                    VStack
                    {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3)
                    { number in
                        Button
                        {
                            // flag was tapped
                            flagTapped(number)
                            
                            withAnimation
                            {
                                rotationDegrees[number] += 360
                                selectedFlag = number
                            }
                        }
                    label:
                        {
//                            Image(countries[number])
//                                .clipShape(.capsule)
//                                .shadow(radius: 5)
                            
                              FlagImage(name: countries[number])
                                  .rotation3DEffect(.degrees(rotationDegrees[number]), axis: (x: 0, y: 1, z: 0))
                          }
                        // Apply opacity: 1 for the selected flag, 0.25 for others
                        .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                        .animation(.easeInOut(duration: 0.5), value: selectedFlag)
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

struct FlagImage: View
{
    var name: String
    
    var body: some View
    {
        Image(name)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct LargeBlueTitle: ViewModifier
{
    func body(content: Content) -> some View 
    {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.blue)
    }
}

extension View
{
    func largeBlueTitle() -> some View
    {
        self.modifier(LargeBlueTitle())
    }
}

#Preview {
    ContentView()
}
