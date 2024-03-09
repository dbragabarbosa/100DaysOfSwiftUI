Protocols and extensions


Today you’re going to learn some truly Swifty functionality: protocols, extensions, and protocol extensions.

Protocol extensions allow us to do away with large, complex inheritance hierarchies, and replaces them with much smaller, simpler protocols that can be 
combined together. This really is the fulfillment of something Tony Hoare said many years ago: “inside every large program, there is a small program trying 
to get out.”

You’ll be using protocols from your very first SwiftUI project, and they’ll continue to be invaluable for your entire Swift coding career – it’s worth 
taking the time to get familiar with them.



How to create and use protocols

Protocols are a bit like contracts in Swift: they let us define what kinds of functionality we expect a data type to support, and Swift ensures that the 
rest of our code follows those rules.

Think about how we might write some code to simulate someone commuting from their home to their office. We might create a small Car struct, then write a 
function like this:

func commute(distance: Int, using vehicle: Car) {
    // lots of code here
}
Of course, they might also commute by train, so we’d also write this:

func commute(distance: Int, using vehicle: Train) {
    // lots of code here
}
Or they might travel by bus:

func commute(distance: Int, using vehicle: Bus) {
    // lots of code here
}
Or they might use a bike, an e-scooter, a ride share, or any number of other transport options.

The truth is that at this level we don’t actually care how the underlying trip happens. What we care about is much broader: how long might it take for the 
user to commute using each option, and how to perform the actual act of moving to the new location.

This is where protocols come in: they let us define a series of properties and methods that we want to use. They don’t implement those properties and 
methods – they don’t actually put any code behind it – they just say that the properties and methods must exist, a bit like a blueprint.

For example, we could define a new Vehicle protocol like this:

protocol Vehicle {
    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}
Let’s break that down:

To create a new protocol we write protocol followed by the protocol name. This is a new type, so we need to use camel case starting with an uppercase letter.
Inside the protocol we list all the methods we require in order for this protocol to work the way we expect.
These methods do not contain any code inside – there are no function bodies provided here. Instead, we’re specifying the method names, parameters, and 
return types. You can also mark methods as being throwing or mutating if needed.
So we’ve made a protocol – how has that helped us?

Well, now we can design types that work with that protocol. This means creating new structs, classes, or enums that implement the requirements for that 
protocol, which is a process we call adopting or conforming to the protocol.

The protocol doesn’t specify the full range of functionality that must exist, only a bare minimum. This means when you create new types that conform to the 
protocol you can add all sorts of other properties and methods as needed.

For example, we could make a Car struct that conforms to Vehicle, like this:

struct Car: Vehicle {
    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }

    func travel(distance: Int) {
        print("I'm driving \(distance)km.")
    }

    func openSunroof() {
        print("It's a nice day!")
    }
}

There are a few things I want to draw particular attention to in that code:

We tell Swift that Car conforms to Vehicle by using a colon after the name Car, just like how we mark subclasses.
All the methods we listed in Vehicle must exist exactly in Car. If they have slightly different names, accept different parameters, have different return 
types, etc, then Swift will say we haven’t conformed to the protocol.
The methods in Car provide actual implementations of the methods we defined in the protocol. In this case, that means our struct provides a rough estimate 
for how many minutes it takes to drive a certain distance, and prints a message when travel() is called.
The openSunroof() method doesn’t come from the Vehicle protocol, and doesn’t really make sense there because many vehicle types don’t have a sunroof. 
But that’s okay, because the protocol describes only the minimum functionality conforming types must have, and they can add their own as needed.

So, now we’ve created a protocol, and made a Car struct that conforms to the protocol.

To finish off, let’s update the commute() function from earlier so that it uses the new methods we added to Car:

func commute(distance: Int, using vehicle: Car) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("That's too slow! I'll try a different vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}

let car = Car()
commute(distance: 100, using: car)

That code all works, but here the protocol isn’t actually adding any value. Yes, it made us implement two very specific methods inside Car, but we could 
have done that without adding the protocol, so why bother?

Here comes the clever part: Swift knows that any type conforming to Vehicle must implement both the estimateTime() and travel() methods, and so it actually 
lets us use Vehicle as the type of our parameter rather than Car. We can rewrite the function to this:

func commute(distance: Int, using vehicle: Vehicle) {
Now we’re saying this function can be called with any type of data, as long as that type conforms to the Vehicle protocol. The body of the function 
doesn’t need to change, because Swift knows for sure that the estimateTime() and travel() methods exist.

If you’re still wondering why this is useful, consider the following struct:

struct Bicycle: Vehicle {
    func estimateTime(for distance: Int) -> Int {
        distance / 10
    }

    func travel(distance: Int) {
        print("I'm cycling \(distance)km.")
    }
}

let bike = Bicycle()
commute(distance: 50, using: bike)

Now we have a second struct that also conforms to Vehicle, and this is where the power of protocols becomes apparent: we can now either pass a Car or a 
Bicycle into the commute() function. Internally the function can have all the logic it wants, and when it calls estimateTime() or travel() Swift will 
automatically use the appropriate one – if we pass in a car it will say “I’m driving”, but if we pass in a bike it will say “I’m cycling”.

So, protocols let us talk about the kind of functionality we want to work with, rather than the exact types. Rather than saying “this parameter must be a 
car”, we can instead say “this parameter can be anything at all, as long as it’s able to estimate travel time and move to a new location.”

As well as methods, you can also write protocols to describe properties that must exist on conforming types. To do this, write var, then a property name, 
then list whether it should be readable and/or writeable.

For example, we could specify that all types that conform Vehicle must specify how many seats they have and how many passengers they currently have, like 
this:

protocol Vehicle {
    var name: String { get }
    var currentPassengers: Int { get set }
    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}

That adds two properties:

A string called name, which must be readable. That might mean it’s a constant, but it might also be a computed property with a getter.
An integer called currentPassengers, which must be read-write. That might mean it’s a variable, but it might also be a computed property with a getter and 
setter.
Type annotation is required for both of them, because we can’t provide a default value in a protocol, just like how protocols can’t provide implementations 
for methods.

With those two extra requirements in place, Swift will warn us that both Car and Bicycle no longer conform to the protocol because they are missing the 
properties. To fix that, we could add the following properties to Car:

let name = "Car"
var currentPassengers = 1
And these to Bicycle:

let name = "Bicycle"
var currentPassengers = 1

Again, though, you could replace those with computed properties as long as you obey the rules – if you use { get set } then you can’t conform to the 
protocol using a constant property.

So now our protocol requires two methods and two properties, meaning that all conforming types must implement those four things in order for our code to 
work. This in turn means Swift knows for sure that functionality is present, so we can write code relying on it.

For example, we could write a method that accepts an array of vehicles and uses it to calculate estimates across a range of options:

func getTravelEstimates(using vehicles: [Vehicle], distance: Int) {
    for vehicle in vehicles {
        let estimate = vehicle.estimateTime(for: distance)
        print("\(vehicle.name): \(estimate) hours to travel \(distance)km")
    }
}

I hope that shows you the real power of protocols – we accept a whole array of the Vehicle protocol, which means we can pass in a Car, a Bicycle, or any 
other struct that conforms to Vehicle, and it will automatically work:

getTravelEstimates(using: [car, bike], distance: 150)

As well as accepting protocols as parameters, you can also return protocols from a function if needed.

Tip: You can conform to as many protocols as you need, just by listing them one by one separated with a comma. If you ever need to subclass something and 
conform to a protocol, you should put the parent class name first, then write your protocols afterwards.



How to use opaque return types

Swift provides one really obscure, really complex, but really important feature called opaque return types, which let us remove complexity in our code. 
Honestly I wouldn’t cover it in a beginners course if it weren’t for one very important fact: you will see it immediately as soon as you create your very 
first SwiftUI project.

Important: You don’t need to understand in detail how opaque return types work, only that they exist and do a very specific job. As you’re following along 
here you might start to wonder why this feature is useful, but trust me: it is important, and it is useful, so try to power through!

Let’s implement two simple functions:

func getRandomNumber() -> Int {
    Int.random(in: 1...6)
}

func getRandomBool() -> Bool {
    Bool.random()
}

Tip: Bool.random() returns either true or false. Unlike random integers and decimals, we don’t need to specify any parameters because there are no 
customization options.

So, getRandomNumber() returns a random integer, and getRandomBool() returns a random Boolean.

Both Int and Bool conform to a common Swift protocol called Equatable, which means “can be compared for equality.” The Equatable protocol is what allows us 
to use ==, like this:

print(getRandomNumber() == getRandomNumber())

Because both of these types conform to Equatable, we could try amending our function to return an Equatable value, like this:

func getRandomNumber() -> Equatable {
    Int.random(in: 1...6)
}

func getRandomBool() -> Equatable {
    Bool.random()
}

However, that code won’t work, and Swift will throw up an error message that is unlikely to be helpful at this point in your Swift career: “protocol 
'Equatable' can only be used as a generic constraint because it has Self or associated type requirements”. What Swift’s error means is that returning 

Equatable doesn’t make sense, and understanding why it doesn’t make sense is the key to understanding opaque return types.
First up: yes, you can return protocols from functions, and often it’s a really helpful thing to do. For example, you might have a function that finds car 
rentals for users: it accepts the number of passengers that it needs to carry, along with how much luggage they want, but it might send back one of several 
structs: Compact, ‌SUV, Minivan, and so on.

We can handle this by returning a Vehicle protocol that is adopted by all those structs, and so whoever calls the function will get back some kind of car 
matching their request without us having to write 10 different functions to handle all car varieties. Each of those car types will implement all the methods 
and properties of Vehicle, which means they are interchangeable – from a coding perspective we don’t care which of the options we get back.

Now think about sending back an Int or a Bool. Yes, both conform to Equatable, but they aren’t interchangeable – we can’t use == to compare an Int and a 
Bool, because Swift won’t let us regardless of what protocols they conform to.

Returning a protocol from a function is useful because it lets us hide information: rather than stating the exact type that is being returned, we get to 
focus on the functionality that is returned. In the case of a Vehicle protocol, that might mean reporting back the number of seats, the approximate fuel 
usage, and a price. This means we can change our code later without breaking things: we could return a RaceCar, or a PickUpTruck, etc, as long as they 
implement the properties and methods required by Vehicle.

Hiding information in this way is really useful, but it just isn’t possible with Equatable because it isn’t possible to compare two different Equatable 
things. Even if we call getRandomNumber() twice to get two integers, we can’t compare them because we’ve hidden their exact data type – we’ve hidden the 
fact that they are two integers that actually could be compared.

This is where opaque return types come in: they let us hide information in our code, but not from the Swift compiler. This means we reserve the right to 
make our code flexible internally so that we can return different things in the future, but Swift always understands the actual data type being returned 
and will check it appropriately.

To upgrade our two functions to opaque return types, add the keyword some before their return type, like this:

func getRandomNumber() -> some Equatable {
    Int.random(in: 1...6)
}

func getRandomBool() -> some Equatable {
    Bool.random()
}

And now we can call getRandomNumber() twice and compare the results using ==. From our perspective we still only have some Equatable data, but Swift knows 
that behind the scenes they are actually two integers.

Returning an opaque return type means we still get to focus on the functionality we want to return rather than the specific type, which in turn allows us 
to change our mind in the future without breaking the rest of our code. For example, getRandomNumber() could switch to using Double.random(in:) and the 
code would still work great.

But the advantage here is that Swift always knows the real underlying data type. It’s a subtle distinction, but returning Vehicle means "any sort of 
Vehicle type but we don't know what", whereas returning some Vehicle means "a specific sort of Vehicle type but we don't want to say which one."

At this point I expect your head is spinning, so let me give you a real example of why this matters in SwiftUI. SwiftUI needs to know exactly what kind of 
layout you want to show on the screen, and so we write code to describe it.

In English, we might say something like this: “there’s a screen with a toolbar at the top, a tab bar at the bottom, and in the middle is a scrolling grid 
of color icons, each of which has a label below saying what the icon means written in a bold font, and when you tap an icon a message appears.”

When SwiftUI asks for our layout, that description – the whole thing – becomes the return type for the layout. We need to be explicit about every single 
thing we want to show on the screen, including positions, colors, font sizes, and more. Can you imagine typing that as your return type? It would be a mile 
long! And every time you changed the code to generate your layout, you’d need to change the return type to match.

This is where opaque return types come to the rescue: we can return the type some View, which means that some kind of view screen will be returned but we 
don’t want to have to write out its mile-long type. At the same time, Swift knows the real underlying type because that’s how opaque return types work: 
Swift always knows the exact type of data being sent back, and SwiftUI will use that to create its layouts.

Like I said at the beginning, opaque return types are a really obscure, really complex, but really important feature, and I wouldn’t cover them in a 
beginners course if it weren’t for the fact that they are used extensively in SwiftUI.

So, when you see some View in your SwiftUI code, it’s effectively us telling Swift “this is going to send back some kind of view to lay out, but I don’t 
want to write out the exact thing – you figure it out for yourself.”



