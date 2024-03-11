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



How to create and use extensions

Extensions let us add functionality to any type, whether we created it or someone else created it – even one of Apple’s own types.

To demonstrate this, I want to introduce you to a useful method on strings, called trimmingCharacters(in:). This removes certain kinds of characters from 
the start or end of a string, such as alphanumeric letters, decimal digits, or, most commonly, whitespace and new lines.

Whitespace is the general term of the space character, the tab character, and a variety of other variants on those two. New lines are line breaks in text, 
which might sound simple but in practice of course there is no single one way of making them, so when we ask to trim new lines it will automatically take 
care of all the variants for us.

For example, here’s a string that has whitespace on either side:

var quote = "   The truth is rarely pure and never simple   "

If we wanted to trim the whitespace and newlines on either side, we could do so like this:

let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)

The .whitespacesAndNewlines value comes from Apple’s Foundation API, and actually so does trimmingCharacters(in:) – like I said way back at the beginning 
of this course, Foundation is really packed with useful code!

Having to call trimmingCharacters(in:) every time is a bit wordy, so let’s write an extension to make it shorter:

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

Let’s break that down…

We start with the extension keyword, which tells Swift we want to add functionality to an existing type.
Which type? Well, that comes next: we want to add functionality to String.
Now we open a brace, and all the code until the final closing brace is there to be added to strings.
We’re adding a new method called trimmed(), which returns a new string.
Inside there we call the same method as before: trimmingCharacters(in:), sending back its result.
Notice how we can use self here – that automatically refers to the current string. This is possible because we’re currently in a string extension.

And now everywhere we want to remove whitespace and newlines we can just write the following:

let trimmed = quote.trimmed()

Much easier!

That’s saved some typing, but is it that much better than a regular function?

Well, the truth is that we could have written a function like this:

func trim(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespacesAndNewlines)
}

Then used it like this:

let trimmed2 = trim(quote)

That’s less code than using an extension, both in terms of making the function and using it. This kind of function is called a global function, because 
it’s available everywhere in our project.

However, the extension has a number of benefits over the global function, including:

When you type quote. Xcode brings up a list of methods on the string, including all the ones we add in extensions. This makes our extra functionality easy 
to find.
Writing global functions makes your code rather messy – they are hard to organize and hard to keep track of. On the other hand, extensions are naturally 
grouped by the data type they are extending.
Because your extension methods are a full part of the original type, they get full access to the type’s internal data. That means they can use properties 
and methods marked with private access control, for example.

What’s more, extensions make it easier to modify values in place – i.e., to change a value directly, rather than return a new value.

For example, earlier we wrote a trimmed() method that returns a new string with whitespace and newlines removed, but if we wanted to modify the string 
directly we could add this to the extension:

mutating func trim() {
    self = self.trimmed()
}

Because the quote string was created as a variable, we can trim it in place like this:

quote.trim()

Notice how the method has slightly different naming now: when we return a new value we used trimmed(), but when we modified the string directly we used 
trim(). This is intentional, and is part of Swift’s design guidelines: if you’re returning a new value rather than changing it in place, you should use 
word endings like ed or ing, like reversed().

Tip: Previously I introduced you to the sorted() method on arrays. Now you know this rule, you should realize that if you create a variable array you can 
use sort() on it to sort the array in place rather than returning a new copy.

You can also use extensions to add properties to types, but there is one rule: they must only be computed properties, not stored properties. The reason 
for this is that adding new stored properties would affect the actual size of the data types – if we added a bunch of stored properties to an integer then 
every integer everywhere would need to take up more space in memory, which would cause all sorts of problems.

Fortunately, we can still get a lot done using computed properties. For example, one property I like to add to strings is called lines, which breaks the 
string up into an array of individual lines. This wraps another string method called components(separatedBy:), which breaks the string up into a string 
array by splitting it on a boundary of our choosing. In this case we’d want that boundary to be new lines, so we’d add this to our string extension:

var lines: [String] {
    self.components(separatedBy: .newlines)
}

With that in place we can now read the lines property of any string, like so:

let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print(lyrics.lines.count)

Whether they are single lines or complex pieces of functionality, extensions always have the same goal: to make your code easier to write, easier to read, 
and easier to maintain in the long term.

Before we’re done, I want to show you one really useful trick when working with extensions. You’ve seen previously how Swift automatically generates a 
memberwise initializer for structs, like this:

struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

let lotr = Book(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)

I also mentioned how creating your own initializer means that Swift will no longer provide the memberwise one for us. This is intentional, because a 
custom initializer means we want to assign data based on some custom logic, like this:

struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int

    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}

If Swift were to keep the memberwise initializer in this instance, it would skip our logic for calculating the approximate reading time.

However, sometimes you want both – you want the ability to use a custom initializer, but also retain Swift’s automatic memberwise initializer. In this 
situation it’s worth knowing exactly what Swift is doing: if we implement a custom initializer inside our struct, then Swift disables the automatic 
memberwise initializer.

That extra little detail might give you a hint on what’s coming next: if we implement a custom initializer inside an extension, then Swift won’t disable 
the automatic memberwise initializer. This makes sense if you think about it: if adding a new initializer inside an extension also disabled the default 
initializer, one small change from us could break all sorts of other Swift code.

So, if we wanted our Book struct to have the default memberwise initializer as well as our custom initializer, we’d place the custom one in an extension, 
like this:

extension Book {
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}



How to create and use protocol extensions

Protocols let us define contracts that conforming types must adhere to, and extensions let us add functionality to existing types. But what would happen 
if we could write extensions on protocols?

Well, wonder no more because Swift supports exactly this using the aptly named protocol extensions: we can extend a whole protocol to add method 
implementations, meaning that any types conforming to that protocol get those methods.

Let’s start with a trivial example. It’s very common to write a condition checking whether an array has any values in, like this:

let guests = ["Mario", "Luigi", "Peach"]

if guests.isEmpty == false {
    print("Guest count: \(guests.count)")
}
Some people prefer to use the Boolean ! operator, like this:

if !guests.isEmpty {
    print("Guest count: \(guests.count)")
}
I’m not really a big fan of either of those approaches, because they just don’t read naturally to me “if not some array is empty”?

We can fix this with a really simple extension for Array, like this:

extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
Tip: Xcode’s playgrounds run their code from top to bottom, so make sure you put that extension before where it’s used.

Now we can write code that I think is easier to understand:

if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}
But we can do better. You see, we just added isNotEmpty to arrays, but what about sets and dictionaries? Sure, we could repeat ourself and copy the code 
into extensions for those, but there’s a better solution: Array, Set, and Dictionary all conform to a built-in protocol called Collection, through which 
they get functionality such as contains(), sorted(), reversed(), and more.

This is important, because Collection is also what requires the isEmpty property to exist. So, if we write an extension on Collection, we can still access 
isEmpty because it’s required. This means we can change Array to Collection in our code to get this:

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
With that one word change in place, we can now use isNotEmpty on arrays, sets, and dictionaries, as well as any other types that conform to Collection. 
Believe it or not, that tiny extension exists in thousands of Swift projects because so many other people find it easier to read.

More importantly, by extending the protocol we’re adding functionality that would otherwise need to be done inside individual structs. This is really 
powerful, and leads to a technique Apple calls protocol-oriented programming – we can list some required methods in a protocol, then add default 
implementations of those inside a protocol extension. All conforming types then get to use those default implementations, or provide their own as needed.

For example, if we had a protocol like this one:

protocol Person {
    var name: String { get }
    func sayHello()
}
That means all conforming types must add a sayHello() method, but we can also add a default implementation of that as an extension like this:

extension Person {
    func sayHello() {
        print("Hi, I'm \(name)")
    }
}
And now conforming types can add their own sayHello() method if they want, but they don’t need to – they can always rely on the one provided inside our 
protocol extension.

So, we could create an employee without the sayHello() method:

struct Employee: Person {
    let name: String
}
But because it conforms to Person, we could use the default implementation we provided in our extension:

let taylor = Employee(name: "Taylor Swift")
taylor.sayHello()
Swift uses protocol extensions a lot, but honestly you don’t need to understand them in great detail just yet – you can build fantastic apps without ever 
using a protocol extension. At this point you know they exist and that’s enough!



Summary: Protocols and extensions

In these chapters we’ve covered some complex but powerful features of Swift, but don’t feel bad if you struggled a bit – these really are hard to grasp at 
first, and they’ll only really sink in once you’ve had time to try them out in your own code.

Let’s recap what we learned:

Protocols are like contracts for code: we specify the functions and methods that we required, and conforming types must implement them.

Opaque return types let us hide some information in our code. That might mean we want to retain flexibility to change in the future, but also means we 
don’t need to write out gigantic return types.

Extensions let us add functionality to our own custom types, or to Swift’s built-in types. This might mean adding a method, but we can also add computed 
properties.

Protocol extensions let us add functionality to many types all at once – we can add properties and methods to a protocol, and all conforming types get 
access to them.

When we boil it down to that these features seem easy, but they aren’t. You need to know about them, to know that they exist, but you need to use them only 
superficially in order to continue your learning journey.