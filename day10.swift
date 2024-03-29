Structs, part one

I know some of you might be keen to charge on with today’s new Swift learning, but hold up: you just finished learning about closures, which are a difficult 
topic. And you came back for more. Seriously, that deserves a lot of respect.

And I have some good news for you. First, not only can you avoid thinking about closures for the next few days, but once you’ve had a break we’ll start 
putting them into practice in real iOS projects. So, even if you aren’t 100% sure of how they work or why they are needed, it will all become clear – stick 
with it!

Anyway, today’s topic is structs. Structs are one of the ways Swift lets us create our own data types out of several small types. For example, you might put 
three strings and a Boolean together and say that represents a user in your app. In fact, most of Swift’s own types are implemented as structs, including 
String, Int, Bool, Array, and more.

These custom types – users, games, documents, and more – form the real core of the software we build. If you get those right then often your code will follow.

As Fred Brooks, the author of the hugely influential book The Mythical Man-Month, once said, “the programmer at wit’s end... can often do best by 
disentangling themself from their code, rearing back, and contemplating their data. Representation is the essence of programming.”

What’s more, structs are extremely common in SwiftUI, because every piece of UI we design is built on a struct, with lots of structs inside. 
They aren’t difficult to learn, but to be fair after closures almost everything seems easier!

Today you have four tutorials to follow, where you’ll meet custom structs, computed properties, property observers, and more. Once you’ve watched each video 
and optionally gone through the extra reading, there are short tests to help make sure you’ve understood what was taught.



How to create your own structs

Swift’s structs let us create our own custom, complex data types, complete with their own variables and their own functions.

A simple struct looks like this:

struct Album {
    let title: String
    let artist: String
    let year: Int

    func printSummary() {
        print("\(title) (\(year)) by \(artist)")
    }
}

That creates a new type called Album, with two string constants called title and artist, plus an integer constant called year. I also added a simple 
function that summarizes the values of our three constants.

Notice how Album starts with a capital A? That’s the standard in Swift, and we’ve been using it all along – think of String, Int, Bool, Set, and so on. 
When you’re referring to a data type, we use camel case where the first letter is uppercased, but when you’re referring to something inside the type, such 
as a variable or function, we use camel case where the first letter is lowercased. Remember, for the most part this is only a convention rather than a rule, 
but it’s a helpful one to stick with.

At this point, Album is just like String or Int – we can make them, assign values, copy them, and so on. For example, we could make a couple of albums, 
then print some of their values and call their functions:

let red = Album(title: "Red", artist: "Taylor Swift", year: 2012)
let wings = Album(title: "Wings", artist: "BTS", year: 2016)

print(red.title)
print(wings.artist)

red.printSummary()
wings.printSummary()

Notice how we can create a new Album as if we were calling a function – we just need to provide values for each of the constants in the order they were defined.

As you can see, both red and wings come from the same Album struct, but once we create them they are separate just like creating two strings.

You can see this in action when we call printSummary() on each struct, because that function refers to title, artist, and year. In both instances the 
correct values are printed out for each struct: red prints “Red (2012) by Taylor Swift” and wings prints out “Wings (2016) by BTS” – Swift understands 
that when printSummary() is called on red, it should use the title, artist, and year constants that also belong to red.

Where things get more interesting is when you want to have values that can change. For example, we could create an Employee struct that can take vacation 
as needed:

struct Employee {
    let name: String
    var vacationRemaining: Int

    func takeVacation(days: Int) {
        if vacationRemaining > days {
            vacationRemaining -= days
            print("I'm going on vacation!")
            print("Days remaining: \(vacationRemaining)")
        } else {
            print("Oops! There aren't enough days remaining.")
        }
    }
}

However, that won’t actually work – Swift will refuse to build the code.

You see, if we create an employee as a constant using let, Swift makes the employee and all its data constant – we can call functions just fine, but those 
functions shouldn’t be allowed to change the struct’s data because we made it constant.

As a result, Swift makes us take an extra step: any functions that only read data are fine as they are, but any that change data belonging to the struct 
must be marked with a special mutating keyword, like this:

mutating func takeVacation(days: Int) {

Now our code will build just fine, but Swift will stop us from calling takeVacation() from constant structs.

In code, this is allowed:

var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
archer.takeVacation(days: 5)
print(archer.vacationRemaining)

But if you change var archer to let archer you’ll find Swift refuses to build your code again – we’re trying to call a mutating function on a constant 
struct, which isn’t allowed.

We’re going to explore structs in detail over the next few chapters, but first I want to give some names to things.

Variables and constants that belong to structs are called properties.
Functions that belong to structs are called methods.
When we create a constant or variable out of a struct, we call that an instance – you might create a dozen unique instances of the Album struct, for example.
When we create instances of structs we do so using an initializer like this: Album(title: "Wings", artist: "BTS", year: 2016).

That last one might seem a bit odd at first, because we’re treating our struct like a function and passing in parameters. This is a little bit of what’s 
called syntactic sugar – Swift silently creates a special function inside the struct called init(), using all the properties of the struct as its parameters. 
It then automatically treats these two pieces of code as being the same:

var archer1 = Employee(name: "Sterling Archer", vacationRemaining: 14)
var archer2 = Employee.init(name: "Sterling Archer", vacationRemaining: 14)

We actually relied on this behavior previously. Way back when I introduced Double for the first time, I explained that you can’t add an Int and a Double 
and instead need to write code like this:

let a = 1
let b = 2.0
let c = Double(a) + b

Now you can see what’s really happening here: Swift’s own Double type is implemented as a struct, and has an initializer function that accepts an integer.

Swift is intelligent in the way it generates its initializer, even inserting default values if we assign them to our properties.

For example, if our struct had these two properties

let name: String
var vacationRemaining = 14

Then Swift will silently generate an initializer with a default value of 14 for vacationRemaining, making both of these valid:

let kane = Employee(name: "Lana Kane")
let poovey = Employee(name: "Pam Poovey", vacationRemaining: 35)

Tip: If you assign a default value to a constant property, that will be removed from the initializer entirely. To assign a default but leave open the 
possibility of overriding it when needed, use a variable property.



How to compute property values dynamically

Structs can have two kinds of property: a stored property is a variable or constant that holds a piece of data inside an instance of the struct, and a 
computed property calculates the value of the property dynamically every time it’s accessed. This means computed properties are a blend of both stored 
properties and functions: they are accessed like stored properties, but work like functions.

As an example, previously we had an Employee struct that could track how many days of vacation remained for that employee. Here’s a simplified version:

struct Employee {
    let name: String
    var vacationRemaining: Int
}

var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
archer.vacationRemaining -= 5
print(archer.vacationRemaining)
archer.vacationRemaining -= 3
print(archer.vacationRemaining)

That works as a trivial struct, but we’re losing valuable information – we’re assigning this employee 14 days of vacation then subtracting them as days 
are taken, but in doing so we’ve lost how many days they were originally granted.

We could adjust this to use computed property, like so:

struct Employee {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0

    var vacationRemaining: Int {
        vacationAllocated - vacationTaken
    }
}

Now rather than making vacationRemaining something we can assign to directly, it is instead calculated by subtracting how much vacation they have taken 
from how much vacation they were allotted.

When we’re reading from vacationRemaining, it looks like a regular stored property:

var archer = Employee(name: "Sterling Archer", vacationAllocated: 14)
archer.vacationTaken += 4
print(archer.vacationRemaining)
archer.vacationTaken += 4
print(archer.vacationRemaining)

This is really powerful stuff: we’re reading what looks like a property, but behind the scenes Swift is running some code to calculate its value every time.

We can’t write to it, though, because we haven’t told Swift how that should be handled. To fix that, we need to provide both a getter and a setter – 
fancy names for “code that reads” and “code that writes” respectively.

In this case the getter is simple enough, because it’s just our existing code. But the setter is more interesting – if you set vacationRemaining for an 
employee, do you mean that you want their vacationAllocated value to be increased or decreased, or should vacationAllocated stay the same and instead we 
change vacationTaken?

I’m going to assume the first of those two is correct, in which case here’s how the property would look:

var vacationRemaining: Int {
    get {
        vacationAllocated - vacationTaken
    }

    set {
        vacationAllocated = vacationTaken + newValue
    }
}

Notice how get and set mark individual pieces of code to run when reading or writing a value. More importantly, notice newValue – that’s automatically 
provided to us by Swift, and stores whatever value the user was trying to assign to the property.

With both a getter and setter in place, we can now modify vacationRemaining:

var archer = Employee(name: "Sterling Archer", vacationAllocated: 14)
archer.vacationTaken += 4
archer.vacationRemaining = 5
print(archer.vacationAllocated)

SwiftUI uses computed properties extensively – you’ll see them in the very first project you create!



How to take action when a property changes

Swift lets us create property observers, which are special pieces of code that run when properties change. These take two forms: a didSet observer to run 
when the property just changed, and a willSet observer to run before the property changed.

To see why property observers might be needed, think about code like this:

struct Game {
    var score = 0
}

var game = Game()
game.score += 10
print("Score is now \(game.score)")
game.score -= 3
print("Score is now \(game.score)")
game.score += 1

That creates a Game struct, and modifies its score a few times. Each time the score changes, a print() line follows it so we can keep track of the changes. 
Except there’s a bug: at the end the score changed without being printed, which is a mistake.

With property observers we can solve this problem by attaching the print() call directly to the property using didSet, so that whenever it changes – 
wherever it changes – we will always run some code.

Here’s that same example, now with a property observer in place:

struct Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var game = Game()
game.score += 10
game.score -= 3
game.score += 1

If you want it, Swift automatically provides the constant oldValue inside didSet, in case you need to have custom functionality based on what you were 
changing from. There’s also a willSet variant that runs some code before the property changes, which in turn provides the new value that will be assigned 
in case you want to take different action based on that.

We can demonstrate all this functionality in action using one code sample, which will print messages as the values change so you can see the flow when the 
code is run:

struct App {
    var contacts = [String]() {
        willSet {
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
        }

        didSet {
            print("There are now \(contacts.count) contacts.")
            print("Old value was \(oldValue)")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")

Yes, appending to an array will trigger both willSet and didSet, so that code will print lots of text when run.

In practice, willSet is used much less than didSet, but you might still see it from time to time so it’s important you know it exists. Regardless of which 
you choose, please try to avoid putting too much work into property observers – if something that looks trivial such as game.score += 1 triggers intensive 
work, it will catch you out on a regular basis and cause all sorts of performance problems.



How to create custom initializers

Initializers are specialized methods that are designed to prepare a new struct instance to be used. You’ve already seen how Swift silently generates one 
for us based on the properties we place inside a struct, but you can also create your own as long as you follow one golden rule: all properties must have 
a value by the time the initializer ends.

Let’s start by looking again at Swift’s default initializer for structs:

struct Player {
    let name: String
    let number: Int
}

let player = Player(name: "Megan R", number: 15)

That creates a new Player instance by providing values for its two properties. Swift calls this the memberwise initializer, which is a fancy way of saying 
an initializer that accepts each property in the order it was defined.

Like I said, this kind of code is possible because Swift silently generates an initializer accepting those two values, but we could write our own to do the 
same thing. The only catch here is that you must be careful to distinguish between the names of parameters coming in and the names of properties being assigned.

Here’s how that would look:

struct Player {
    let name: String
    let number: Int

    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}

That works the same as our previous code, except now the initializer is owned by us so we can add extra functionality there if needed.

However, there are a couple of things I want you to notice:

There is no func keyword. Yes, this looks like a function in terms of its syntax, but Swift treats initializers specially.
Even though this creates a new Player instance, initializers never explicitly have a return type – they always return the type of data they belong to.
I’ve used self to assign parameters to properties to clarify we mean “assign the name parameter to my name property”.

That last point is particularly important, because without self we’d have name = name and that doesn’t make sense – are we assigning the property to the 
parameter, assigning the parameter to itself, or something else? By writing self.name we’re clarifying we mean “the name property that belongs to my current 
instance,” as opposed to anything else.

Of course, our custom initializers don’t need to work like the default memberwise initializer Swift provides us with. For example, we could say that you 
must provide a player name, but the shirt number is randomized:

struct Player {
    let name: String
    let number: Int

    init(name: String) {
        self.name = name
        number = Int.random(in: 1...99)
    }
}

let player = Player(name: "Megan R")
print(player.number)

Just remember the golden rule: all properties must have a value by the time the initializer ends. If we had not provided a value for number inside the 
initializer, Swift would refuse to build our code.

Important: Although you can call other methods of your struct inside your initializer, you can’t do so before assigning values to all your properties – 
Swift needs to be sure everything is safe before doing anything else.

You can add multiple initializers to your structs if you want, as well as leveraging features such as external parameter names and default values. 
However, as soon as you implement your own custom initializers you’ll lose access to Swift’s generated memberwise initializer unless you take extra steps 
to retain it. This isn’t an accident: if you have a custom initializer, Swift effectively assumes that’s because you have some special way to initialize 
your properties, which means the default one should no longer be available.