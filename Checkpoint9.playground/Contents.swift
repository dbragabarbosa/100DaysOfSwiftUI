import Cocoa


func acceptOptArrayInts(arrayOfInts: [Int]?) -> Int
{
    if let arrayOfInts = arrayOfInts
    {
        return arrayOfInts.randomElement() ?? Int.random(in: 1...100)
    }
    else
    {
        return Int.random(in: 1...100)
    }
}


func acceptOptArrayIntsInOneLine(arrayOfInts: [Int]?) -> Int
{
    return (arrayOfInts?.randomElement() ?? Int.random(in: 1...100))
}
