//
//  ContentView.swift
//  Day19
//
//  Created by Daniel Braga Barbosa on 20/06/24.
//

import SwiftUI

struct ContentView: View 
{
    @State private var inputNumber: Double = 0
    @State private var inputUnit: String = "Segundos"
    @State private var outputUnit: String = "Minutos"
    
    let unitsArray = ["Segundos", "Minutos", "Horas"]
        
    var valorConvertido: Double
    {
        var valorEmSegundos = 0.0
        
        if(inputUnit == "Segundos")
        {
            valorEmSegundos = inputNumber
        }
        else if(inputUnit == "Minutos")
        {
            valorEmSegundos = inputNumber*60
        }
        else if(inputUnit == "Horas")
        {
            valorEmSegundos = inputNumber*60*60
        }
        
        if(outputUnit == "Segundos")
        {
            return valorEmSegundos
        }
        else if(outputUnit == "Minutos")
        {
            return valorEmSegundos/60
        }
        else if(outputUnit == "Horas")
        {
            return valorEmSegundos/60/60
        }
        else
        {
            return 0.0
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section("Digite o valor que você deseja converter")
                {
                    TextField("Valor", value: $inputNumber, format: .number)
                    
                }
                
                Section("De qual unidade")
                {
                    Picker("Input number", selection: $inputUnit)
                    {
                        ForEach(unitsArray, id: \.self)
                        {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Para qual unidade")
                {
                    Picker("Output number", selection: $outputUnit)
                    {
                        ForEach(unitsArray, id: \.self)
                        {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Valor convertido")
                {
                    Text(valorConvertido, format: .number)
                }
            }
//            .navigationTitle("Conversor de tempo")
        }
    }
}

#Preview {
    ContentView()
}
