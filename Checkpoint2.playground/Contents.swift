import Cocoa

var nomes = Array<String>()
nomes.append("Daniel")
nomes.append("Julia")
nomes.append("Caio")
nomes.append("Daniel")

var nomesUnicos = Set<String>()
nomesUnicos = Set(nomes)

var tamanhoArray: Int = nomes.count
var tamanhoSet: Int = nomesUnicos.count

print("Numero de itens: \(tamanhoArray)")
print("Numero de itens unicos: \(tamanhoSet)")


enum TransportOption {
    case airplane, helicopter, bicycle, car, scooter
}

let transport = TransportOption.airplane
let transporte : TransportOption = .car

print(transporte)

if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("I hope there's a bike path…")
} else if transport == .car {
    print("Time to get stuck in traffic.")
} else {
    print("I'm going to hire a scooter now!")
}
