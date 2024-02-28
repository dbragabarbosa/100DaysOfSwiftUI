Classes


At first, classes seem very similar to structs because we use them to create new data types with properties and methods. However, they introduce a new, 
important, and complex feature called inheritance – the ability to make one class build on the foundations of another.

This is a powerful feature, there’s no doubt about it, and there is no way to avoid using classes when you start building real iOS apps. But please remember 
to keep your code simple: just because a feature exists, it doesn’t mean you need to use it. As Martin Fowler wrote, “any fool can write code that a computer 
can understand, but good programmers write code that humans can understand.”

I’ve already said that SwiftUI uses structs extensively for its UI design. Well, it uses classes extensively for its data: when you show data from some 
object on the screen, or when you pass data between your layouts, you’ll usually be using classes.

I should add: if you’ve ever worked with UIKit before, this will be a remarkable turnaround for you – in UIKit we normally use classes for UI design and 
structs for data. So, if you thought perhaps you could skip a day here and there I’m sorry to say that you can’t: this is all required.

Today you have six tutorials to work through, and you’ll meet classes, inheritance, deinitializers, and more.



How to create your own classes

Swift uses structs for storing most of its data types, including String, Int, Double, and Array, but there is another way to create custom data types called 
classes. These have many things in common with structs, but are different in key places.

First, the things that classes and structs have in common include:

You get to create and name them.
You can add properties and methods, including property observers and access control.
You can create custom initializers to configure new instances however you want.
However, classes differ from structs in five key places:

You can make one class build upon functionality in another class, gaining all its properties and methods as a starting point. If you want to selectively 
override some methods, you can do that too.
Because of that first point, Swift won’t automatically generate a memberwise initializer for classes. This means you either need to write your own 
initializer, or assign default values to all your properties.
When you copy an instance of a class, both copies share the same data – if you change one copy, the other one also changes.
When the final copy of a class instance is destroyed, Swift can optionally run a special function called a deinitializer.
Even if you make a class constant, you can still change its properties as long as they are variables.

On the surface those probably seem fairly random, and there’s a good chance you’re probably wondering why classes are even needed when we already have structs.

However, SwiftUI uses classes extensively, mainly for point 3: all copies of a class share the same data. This means many parts of your app can share the 
same information, so that if the user changed their name in one screen all the other screens would automatically update to reflect that change.

The other points matter, but are of varying use:

Being able to build one class based on another is really important in Apple’s older UI framework, UIKit, but is much less common in SwiftUI apps. In UIKit 
it was common to have long class hierarchies, where class A was built on class B, which was built on class C, which was built on class D, etc.
Lacking a memberwise initializer is annoying, but hopefully you can see why it would be tricky to implement given that one class can be based upon another – 
if class C added an extra property it would break all the initializers for C, B, and A.
Being able to change a constant class’s variables links in to the multiple copy behavior of classes: a constant class means we can’t change what pot our 
copy points to, but if the properties are variable we can still change the data inside the pot. This is different from structs, where each copy of a struct 
is unique and holds its own data.
Because one instance of a class can be referenced in several places, it becomes important to know when the final copy has been destroyed. That’s where the 
deinitializer comes in: it allows us to clean up any special resources we allocated when that last copy goes away.

Before we’re done, let’s look at just a tiny slice of code that creates and uses a class:

class Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var newGame = Game()
newGame.score += 10

Yes, the only difference between that and a struct is that it was created using class rather than struct – everything else is identical. 
That might make classes seem redundant, but trust me: all five of their differences are important.

I’ll be going into more detail on the five differences between classes and structs in the following chapters, but right now the most important thing to 
know is this: structs are important, and so are classes – you will need both when using SwiftUI.



How to make one class inherit from another

Swift lets us create classes by basing them on existing classes, which is a process known as inheritance. When one class inherits functionality from 
another class (its “parent” or “super” class), Swift will give the new class access (the “child class” or “subclass”) to the properties and methods from 
that parent class, allowing us to make small additions or changes to customize the way the new class behaves.

To make one class inherit from another, write a colon after the child class’s name, then add the parent class’s name. For example, here is an Employee 
class with one property and an initializer:

class Employee {
    let hours: Int

    init(hours: Int) {
        self.hours = hours
    }
}

We could make two subclasses of Employee, each of which will gain the hours property and initializer:

class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}

Notice how those two child classes can refer directly to hours – it’s as if they added that property themselves, except we don’t have to keep repeating 
ourselves.

Each of those classes inherit from Employee, but each then adds their own customization. So, if we create an instance of each and call work(), we’ll get a 
different result:

let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)
robert.work()
joseph.work()

As well as sharing properties, you can also share methods, which can then be called from the child classes. As an example, try adding this to the Employee 
class:

func printSummary() {
    print("I work \(hours) hours a day.")
}

Because Developer inherits from Employee, we can immediately start calling printSummary() on instances of Developer, like this:

let novall = Developer(hours: 8)
novall.printSummary()

Things get a little more complicated when you want to change a method you inherited. For example, we just put printSummary() into Employee, but maybe one 
of those child classes wants slightly different behavior.

This is where Swift enforces a simple rule: if a child class wants to change a method from a parent class, you must use override in the child class’s 
version. This does two things:

If you attempt to change a method without using override, Swift will refuse to build your code. This stops you accidentally overriding a method.
If you use override but your method doesn’t actually override something from the parent class, Swift will refuse to build your code because you probably 
made a mistake.

So, if we wanted developers to have a unique printSummary() method, we’d add this to the Developer class:

override func printSummary() {
    print("I'm a developer who will sometimes work \(hours) hours a day, but other times spend hours arguing about whether code should be indented using tabs or spaces.")
}

Swift is smart about how method overrides work: if your parent class has a work() method that takes no parameters, but the child class has a work() method 
that accepts a string to designate where the work is being done, that does not require override because you aren’t replacing the parent method.

Tip: If you know for sure that your class should not support inheritance, you can mark it as final. This means the class itself can inherit from other 
things, but can’t be used to inherit from – no child class can use a final class as its parent.



How to add initializers for classes

Class initializers in Swift are more complicated than struct initializers, but with a little cherrypicking we can focus on the part that really matters: 
if a child class has any custom initializers, it must always call the parent’s initializer after it has finished setting up its own properties, if it has any.

Like I said previously, Swift won’t automatically generate a memberwise initializer for classes. This applies with or without inheritance happening – it 
will never generate a memberwise initializer for you. So, you either need to write your own initializer, or provide default values for all the properties 
of the class.

Let’s start by defining a new class:

class Vehicle {
    let isElectric: Bool

    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}

That has a single Boolean property, plus an initializer to set the value for that property. Remember, using self here makes it clear we’re assigning the 
isElectric parameter to the property of the same name.

Now, let’s say we wanted to make a Car class inheriting from Vehicle – you might start out writing something like this:

class Car: Vehicle {
    let isConvertible: Bool

    init(isConvertible: Bool) {
        self.isConvertible = isConvertible
    }
}

But Swift will refuse to build that code: we’ve said that the Vehicle class needs to know whether it’s electric or not, but we haven’t provided a value 
for that.

What Swift wants us to do is provide Car with an initializer that includes both isElectric and isConvertible, but rather than trying to store isElectric 
ourselves we instead need to pass it on – we need to ask the super class to run its own initializer.

Here’s how that looks:

class Car: Vehicle {
    let isConvertible: Bool

    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible
        super.init(isElectric: isElectric)
    }
}

super is another one of those values that Swift automatically provides for us, similar to self: it allows us to call up to methods that belong to our
parent class, such as its initializer. You can use it with other methods if you want; it’s not limited to initializers.

Now that we have a valid initializer in both our classes, we can make an instance of Car like so:

let teslaX = Car(isElectric: true, isConvertible: false)

Tip: If a subclass does not have any of its own initializers, it automatically inherits the initializers of its parent class.



How to copy classes

In Swift, all copies of a class instance share the same data, meaning that any changes you make to one copy will automatically change the other copies. 
This happens because classes are reference types in Swift, which means all copies of a class all refer back to the same underlying pot of data.

To see this in action, try this simple class:

class User {
    var username = "Anonymous"
}

That has just one property, but because it’s stored inside a class it will get shared across all copies of the class.

So, we could create an instance of that class:

var user1 = User()

We could then take a copy of user1 and change the username value:

var user2 = user1
user2.username = "Taylor"

I hope you see where this is going! Now we’ve changed the copy’s username property we can then print out the same properties from each different copy:

print(user1.username)  
print(user2.username)

…and that’s going to print “Taylor” for both – even though we only changed one of the instances, the other also changed.

This might seem like a bug, but it’s actually a feature – and a really important feature too, because it’s what allows us to share common data across all 
parts of our app. As you’ll see, SwiftUI relies very heavily on classes for its data, specifically because they can be shared so easily.

In comparison, structs do not share their data amongst copies, meaning that if we change class User to struct User in our code we get a different result: 
it will print “Anonymous” then “Taylor”, because changing the copy didn’t also adjust the original.

If you want to create a unique copy of a class instance – sometimes called a deep copy – you need to handle creating a new instance and copy across all
your data safely.

In our case that’s straightforward:

class User {
    var username = "Anonymous"

    func copy() -> User {
        let user = User()
        user.username = username
        return user
    }
}

Now we can safely call copy() to get an object with the same starting data, but any future changes won’t impact the original.