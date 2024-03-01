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



How to create a deinitializer for a class

Swift’s classes can optionally be given a deinitializer, which is a bit like the opposite of an initializer in that it gets called when the object is 
destroyed rather than when it’s created.

This comes with a few small provisos:

Just like initializers, you don’t use func with deinitializers – they are special.
Deinitializers can never take parameters or return data, and as a result aren’t even written with parentheses.
Your deinitializer will automatically be called when the final copy of a class instance is destroyed. That might mean it was created inside a function 
that is now finishing, for example.
We never call deinitializers directly; they are handled automatically by the system.
Structs don’t have deinitializers, because you can’t copy them.
Exactly when your deinitializers are called depends on what you’re doing, but really it comes down to a concept called scope. Scope more or less means 
“the context where information is available”, and you’ve seen lots of examples already:

If you create a variable inside a function, you can’t access it from outside the function.
If you create a variable inside an if condition, that variable is not available outside the condition.
If you create a variable inside a for loop, including the loop variable itself, you can’t use it outside the loop.
If you look at the big picture, you’ll see each of those use braces to create their scope: conditions, loops, and functions all create local scopes.

When a value exits scope we mean the context it was created in is going away. In the case of structs that means the data is being destroyed, but in the 
case of classes it means only one copy of the underlying data is going away – there might still be other copies elsewhere. But when the final copy goes 
away – when the last constant or variable pointing at a class instance is destroyed – then the underlying data is also destroyed, and the memory it was 
using is returned back to the system.

To demonstrate this, we could create a class that prints a message when it’s created and destroyed, using an initializer and deinitializer:

class User {
    let id: Int

    init(id: Int) {
        self.id = id
        print("User \(id): I'm alive!")
    }

    deinit {
        print("User \(id): I'm dead!")
    }
}

Now we can create and destroy instances of that quickly using a loop – if we create a User instance inside the loop, it will be destroyed when the loop iteration finishes:

for i in 1...3 {
    let user = User(id: i)
    print("User \(user.id): I'm in control!")
}

When that code runs you’ll see it creates and destroys each user individually, with one being destroyed fully before another is even created.

Remember, the deinitializer is only called when the last remaining reference to a class instance is destroyed. This might be a variable or constant you 
have stashed away, or perhaps you stored something in an array.

For example, if we were adding our User instances as they were created, they would only be destroyed when the array is cleared:

var users = [User]()

for i in 1...3 {
    let user = User(id: i)
    print("User \(user.id): I'm in control!")
    users.append(user)
}

print("Loop is finished!")
users.removeAll()
print("Array is clear!")

How to work with variables inside classes

Swift’s classes work a bit like signposts: every copy of a class instance we have is actually a signpost pointing to the same underlying piece of data. 
Mostly this matters because of the way changing one copy changes all the others, but it also matters because of how classes treat variable properties.

This one small code sample demonstrates how things work:

class User {
    var name = "Paul"
}

let user = User()
user.name = "Taylor"
print(user.name)

That creates a constant User instance, but then changes it – it changes the constant value. That’s bad, right?

Except it doesn’t change the constant value at all. Yes, the data inside the class has changed, but the class instance itself – the object we created – 
has not changed, and in fact can’t be changed because we made it constant.

Think of it like this: we created a constant signpoint pointing towards a user, but we erased that user’s name tag and wrote in a different name. 
The user in question hasn’t changed – the person still exists – but a part of their internal data has changed.

Now, if we had made the name property a constant using let, then it could not be changed – we have a constant signpost pointing to a user, but we’ve 
written their name in permanent ink so that it can’t be erased.

In contrast, what happens if we made both the user instance and the name property variables? Now we’d be able to change the property, but we’d also be able 
to change to a wholly new User instance if we wanted. To continue the signpost analogy, it would be like turning the signpost to point at wholly different 
person.

Try it with this code:

class User {
    var name = "Paul"
}

var user = User()
user.name = "Taylor"
user = User()
print(user.name)

That would end up printing “Paul”, because even though we changed name to “Taylor” we then overwrote the whole user object with a new one, resetting it 
back to “Paul”.

The final variation is having a variable instance and constant properties, which would mean we can create a new User if we want, but once it’s done we 
can’t change its properties.

So, we end up with four options:

Constant instance, constant property – a signpost that always points to the same user, who always has the same name.
Constant instance, variable property – a signpost that always points to the same user, but their name can change.
Variable instance, constant property – a signpost that can point to different users, but their names never change.
Variable instance, variable property – a signpost that can point to different users, and those users can also change their names.

This might seem awfully confusing, and perhaps even pedantic. However, it serves an important purpose because of the way class instances get shared.

Let’s say you’ve been given a User instance. Your instance is constant, but the property inside was declared as a variable. This tells you not only that 
you can change that property if you want to, but more importantly tells you there’s the possibility of the property being changed elsewhere – that class 
you have could be a copy from somewhere else, and because the property is variable it means some other part of code could change it by surprise.

When you see constant properties it means you can be sure neither your current code nor any other part of your program can change it, but as soon as you’re
 dealing with variable properties – regardless of whether the class instance itself is constant or not – it opens up the possibility that the data could 
 change under your feet.

This is different from structs, because constant structs cannot have their properties changed even if the properties were made variable. Hopefully you can 
now see why this happens: structs don’t have the whole signpost thing going on, they hold their data directly. This means if you try to change a value 
inside the struct you’re also implicitly changing the struct itself, which isn’t possible because it’s constant.

One upside to all this is that classes don’t need to use the mutating keyword with methods that change their data. This keyword is really important for 
structs because constant structs cannot have their properties changed no matter how they were created, so when Swift sees us calling a mutating method on 
a constant struct instance it knows that shouldn’t be allowed.

With classes, how the instance itself was created no longer matters – the only thing that determines whether a property can be modified or not is whether 
the property itself was created as a constant. Swift can see that for itself just by looking at how you made the property, so there’s no more need to mark 
the method specially.



Summary: Classes

Classes aren’t quite as commonly used as structs, but they serve an invaluable purpose for sharing data, and if you ever choose to learn Apple’s older UIKit 
framework you’ll find yourself using them extensively.

Let’s recap what we learned:

Classes have lots of things in common with structs, including the ability to have properties and methods, but there are five key differences between 
classes and structs.

First, classes can inherit from other classes, which means they get access to the properties and methods of their parent class. You can optionally 
override methods in child classes if you want, or mark a class as being final to stop others subclassing it.

Second, Swift doesn’t generate a memberwise initializer for classes, so you need to do it yourself. If a subclass has its own initializer, it must always 
call the parent class’s initializer at some point.

Third, if you create a class instance then take copies of it, all those copies point back to the same instance. This means changing some data in one of 
the copies changes them all.

Fourth, classes can have deinitializers that run when the last copy of one instance is destroyed.

Finally, variable properties inside class instances can be changed regardless of whether the instance itself was created as variable.