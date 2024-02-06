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
