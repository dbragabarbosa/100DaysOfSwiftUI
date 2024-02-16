import Cocoa

enum ErrosPossiveis: Error
{
    case outOfBounds
    case noRoot
}

func raizQuadrada(_ numero: Int) throws -> Int
{
    if( (numero < 1) || (numero > 10_000) )
    {
        throw ErrosPossiveis.outOfBounds
    }
    
    var raiz: Int = 0
    
    for i in 1...100
    {
        if( (i*i) == numero )
        {
            raiz = i
            break
        }
    }
    
    if(raiz == 0)
    {
        throw ErrosPossiveis.noRoot
    }
    
    return raiz
}


do
{
    var raizDe9 = try raizQuadrada(9)
    print("Raiz de 9: \(raizDe9)")
}
catch ErrosPossiveis.outOfBounds
{
    print("Numero fora dos limites")
}
catch ErrosPossiveis.noRoot
{
    print("Raiz não encontrada")
}
