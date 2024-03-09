import Cocoa

class Animal
{
    var legs: Int
    
    init(legs: Int) 
    {
        self.legs = legs
    }
}

class Dog: Animal
{
    func speak()
    {
        print("Sou um cachorro!")
    }
}

class Cat: Animal
{
    var isTame: Bool
    
    init(isTame: Bool) 
    {
        self.isTame = isTame
        super.init(legs: 4)
    }
    
    func speak()
    {
        print("Sou um gato!")
    }
}

class Corgi: Dog
{
    override func speak() 
    {
        print("Sou um corgi!")
    }
}

class Poodle: Dog
{
    override func speak() 
    {
        print("Sou um poodle!")
    }
}

class Persion: Cat
{
    override func speak() 
    {
        print("Sou um persion!")
    }
}

class Lion: Cat
{
    override func speak() 
    {
        print("Sou um lion!")
    }
}

var dogao = Dog(legs: 4)
dogao.speak()

var gatinho = Persion(isTame: true)
gatinho.speak()
