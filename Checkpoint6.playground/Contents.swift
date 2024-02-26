import Cocoa

struct Car
{
    let model: String
    let numberOfSeats: Int
    private(set) var currentGear: Int
    
    init(model: String, numberOfSeats: Int, currentGear: Int)
    {
        self.model = model
        self.numberOfSeats = numberOfSeats
        self.currentGear = currentGear
    }
    
    mutating func changeGear(up: Bool)
    {
        if up
        {
            if(currentGear < 10)
            {
                currentGear += 1
            }
        }
        else
        {
            if(currentGear > 1)
            {
                currentGear -= 1
            }
        }
    }
    
}



var meuCarro = Car(model: "Tesla", numberOfSeats: 5, currentGear: 1)
print("Marcha atual: \(meuCarro.currentGear)")
meuCarro.changeGear(up: true)
print("Marcha após aumentar: \(meuCarro.currentGear)")
meuCarro.changeGear(up: false)
print("Marcha após diminuir: \(meuCarro.currentGear)")
