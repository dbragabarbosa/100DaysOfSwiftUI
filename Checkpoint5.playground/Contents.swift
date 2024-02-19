import Cocoa

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let evenNumbers = luckyNumbers.filter { !($0.isMultiple(of: 2)) }
//print(evenNumbers)

let sortedNumbers = evenNumbers.sorted()
//print(sortedNumbers)

let stringNumbers = sortedNumbers.map { "\($0) is a lucky number" }
//print(stringNumbers)

for item in stringNumbers
{
    print(item)
}
