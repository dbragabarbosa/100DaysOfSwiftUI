//
//  ContentView.swift
//  ChallengeDay25
//
//  Created by Daniel Braga Barbosa on 08/08/24.
//

import SwiftUI

struct ContentView: View 
{
    let jogadasPossiveis = ["Pedra", "Papel", "Tesoura"]
    
    @State var jogadaDoApp: String = "Pedra"
    @State var deveVencer: Bool = true
    @State var numJogadas = 0
    @State var score = 0
    
    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            Text("Numero de jogadas: \(numJogadas)")
            
            Spacer()
            
            Text("Seu score é: \(score)")
            
            Spacer()
            
            Text("Jogada do app: \(jogadaDoApp)")
                .bold()
            
            Spacer()
            
            if deveVencer
            {
                Text("Você deve vencer!")
                    .bold()
            }
            else
            {
                Text("Você deve perder!")
                    .bold()
            }
            
            Spacer()
            
            HStack
            {
                Button("🪨      ")
                {
                    if ((jogadaDoApp == "Tesoura") && (deveVencer == true))
                    {
                        score += 1
                    }
                    else if (((jogadaDoApp == "Pedra") || (jogadaDoApp == "Papel")) && (deveVencer == false))
                    {
                       score += 1
                    }
                    else
                    {
                        score -= 1
                    }
                    
                    setup()
                }
                Button("        🧻      ")
                {
                    if ((jogadaDoApp == "Pedra") && (deveVencer == true))
                    {
                        score += 1
                    }
                    else if (((jogadaDoApp == "Tesoura") || (jogadaDoApp == "Papel")) && (deveVencer == false))
                    {
                       score += 1
                    }
                    else
                    {
                        score -= 1
                    }
                    
                    setup()
                }
                Button("        ✂️")
                {
                    if ((jogadaDoApp == "Papel") && (deveVencer == true))
                    {
                        score += 1
                    }
                    else if (((jogadaDoApp == "Pedra") || (jogadaDoApp == "Tesoura")) && (deveVencer == false))
                    {
                       score += 1
                    }
                    else
                    {
                        score -= 1
                    }
                    
                    setup()
                }
            }
            
            Spacer()
            
        }
        .padding()
    }
    
    
    func setup()
    {
        self.numJogadas += 1
        deveVencer = Bool.random()
        jogadaDoApp = jogadasPossiveis[Int.random(in: 0...2)]
    }
}

#Preview 
{
    ContentView()
}
