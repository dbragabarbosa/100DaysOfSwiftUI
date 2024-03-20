import Cocoa

protocol Building
{
    var rooms: Int { get set }
    var cost: Int { get set }
    var estateAgent: String { get set }
    
    func printSalesSummary()
}

struct House: Building
{
    var rooms: Int
    var cost: Int
    var estateAgent: String
    
    func printSalesSummary() 
    {
        print("Sales summary!")
    }
}

struct Office: Building
{
    var rooms: Int
    var cost: Int
    var estateAgent: String
    
    func printSalesSummary()
    {
        print("Sales summary!")
    }
}
