Closures

Brace yourself, because today we’re covering the first thing in Swift that many people have a hard time understanding. Please keep in mind Flip Wilson's 
law: “you can't expect to hit the jackpot if you don't put a few nickels in the machine.”

Today the topic is closures, which are a bit like anonymous functions – functions we can create and assign directly to a variable, or pass into other 
functions to customize how they work. Yes, you read that right: passing one function into another as a parameter.

Closures are really difficult. I’m not saying that to put you off, only so that you know in advance if you’re finding closures hard to understand or hard 
to remember, it’s okay – we’ve all been there!

Sometimes the syntax for closures can be a bit hard on your eyes, and this will really be apparent as you work through today’s lessons. If you find it a 
bit overwhelming – if you’re staring at some code and aren’t 100% sure of what it means – just go back one video and watch it again to give your memory a 
little nudge. You’ll find there are more tests and optional reading links than usual below, hopefully helping to solidify your knowledge.

SwiftUI uses closures extensively so it’s worth taking the time to understand what’s going on here. Yes, closures are probably the most complex feature of 
Swift, but it’s a bit like cycling up a hill – once you’ve reached the top, once you’ve mastered closures, it all gets much easier.

Today you have three tutorials to follow, plus a summary and another checkpoint. As always once you’ve completed each video there’s some optional extra 
reading and short tests to help make sure you’ve understood what was taught. This time you’ll notice there’s quite a bit of each of those because closures 
really can take some time to understand, so don’t be afraid to explore!



How to create and use closures

Functions are powerful things in Swift. Yes, you’ve seen how you can call them, pass in values, and return data, but you can also assign them to variables, 
pass functions into functions, and even return functions from functions.

For example:

func greetUser() {
    print("Hi there!")
}

greetUser()

var greetCopy = greetUser
greetCopy()
That creates a trivial function and calls it, but then creates a copy of that function and calls the copy. As a result, it will print the same message twice.

Important: When you’re copying a function, you don’t write the parentheses after it – it’s var greetCopy = greetUser and not var greetCopy = greetUser(). 
If you put the parentheses there you are calling the function and assigning its return value back to something else.

But what if you wanted to skip creating a separate function, and just assign the functionality directly to a constant or variable? Well, it turns out you 
can do that too:

let sayHello = {
    print("Hi there!")
}

sayHello()
Swift gives this the grandiose name closure expression, which is a fancy way of saying we just created a closure – a chunk of code we can pass around and 
call whenever we want. This one doesn’t have a name, but otherwise it’s effectively a function that takes no parameters and doesn’t return a value.

If you want the closure to accept parameters, they need to be written in a special way. You see, the closure starts and ends with the braces, which means 
we can’t put code outside those braces to control parameters or return value. So, Swift has a neat workaround: we can put that same information inside the 
braces, like this:

let sayHello = { (name: String) -> String in
    "Hi \(name)!"
}

I added an extra keyword there – did you spot it? It’s the in keyword, and it comes directly after the parameters and return type of the closure. Again, 
with a regular function the parameters and return type would come outside the braces, but we can’t do that with closures. So, in is used to mark the end 
of the parameters and return type – everything after that is the body of the closure itself. There’s a reason for this, and you’ll see it for yourself 
soon enough.

In the meantime, you might have a more fundamental question: “why would I ever need these things?” I know, closures do seem awfully obscure. Worse, they 
seem obscure and complicated – many, many people really struggle with closures when they first meet them, because they are complex beasts and seem like 
they are never going to be useful.

However, as you’ll see this gets used extensively in Swift, and almost everywhere in SwiftUI. Seriously, you’ll use them in every SwiftUI app you write, 
sometimes hundreds of times – maybe not necessarily in the form you see above, but you’re going to be using it a lot.

To get an idea of why closures are so useful, I first want to introduce you to function types. You’ve seen how integers have the type Int, and decimals 
have the type Double, etc, and now I want you to think about how functions have types too.

Let’s take the greetUser() function we wrote earlier: it accepts no parameters, returns no value, and does not throw errors. If we were to write that as 
a type annotation for greetCopy, we’d write this:

var greetCopy: () -> Void = greetUser
Let’s break that down…

The empty parentheses marks a function that takes no parameters.
The arrow means just what it means when creating a function: we’re about to declare the return type for the function.
Void means “nothing” – this function returns nothing. Sometimes you might see this written as (), but we usually avoid that because it can be confused 
with the empty parameter list.
Every function’s type depends on the data it receives and sends back. That might sound simple, but it hides an important catch: the names of the data it 
receives are not part of the function’s type.

We can demonstrate this with some more code:

func getUserData(for id: Int) -> String {
    if id == 1989 {
        return "Taylor Swift"
    } else {
        return "Anonymous"
    }
}

let data: (Int) -> String = getUserData
let user = data(1989)
print(user)
That starts off easily enough: it’s a function that accepts an integer and returns a string. But when we take a copy of the function the type of function 
doesn’t include the for external parameter name, so when the copy is called we use data(1989) rather than data(for: 1989).

Cunningly this same rule applies to all closures – you might have noticed that I didn’t actually use the sayHello closure we wrote earlier, and that’s 
because I didn’t want to leave you questioning the lack of a parameter name at the call site. Let’s call it now:

sayHello("Taylor")
That uses no parameter name, just like when we copy functions. So, again: external parameter names only matter when we’re calling a function directly, not 
when we create a closure or when we take a copy of the function first.

You’re probably still wondering why all this matters, and it’s all about to become clear. Do you remember I said we can use sorted() with an array to have 
it sort its elements?

It means we can write code like this:

let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]
let sortedTeam = team.sorted()
print(sortedTeam)
That’s really neat, but what if we wanted to control that sort – what if we always wanted one person to come first because they were the team captain, with 
the rest being sorted alphabetically?

Well, sorted() actually allows us to pass in a custom sorting function to control exactly that. This function must accept two strings, and return true if 
the first string should be sorted before the second, or false if the first string should be sorted after the second.

If Suzanne were the captain, the function would look like this:

func captainFirstSorted(name1: String, name2: String) -> Bool {
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }

    return name1 < name2
}
So, if the first name is Suzanne, return true so that name1 is sorted before name2. On the other hand, if name2 is Suzanne, return false so that name1 is 
sorted after name2. If neither name is Suzanne, just use < to do a normal alphabetical sort.

Like I said, sorted() can be passed a function to create a custom sort order, and as long as that function a) accepts two strings, and b) returns a Boolean, 
sorted() can use it.

That’s exactly what our new captainFirstSorted() function does, so we can use it straight away:

let captainFirstTeam = team.sorted(by: captainFirstSorted)
print(captainFirstTeam)
When that runs it will print ["Suzanne", "Gloria", "Piper", "Tasha", "Tiffany"], exactly as we wanted.

We’ve now covered two seemingly very different things. First, we can create closures as anonymous functions, storing them inside constants and variables:

let sayHello = {
    print("Hi there!")
}

sayHello()
And we’re also able to pass functions into other functions, just like we passed captainFirstSorted() into sorted():

let captainFirstTeam = team.sorted(by: captainFirstSorted)
The power of closures is that we can put these two together: sorted() wants a function that will accept two strings and return a Boolean, and it doesn’t 
care if that function was created formally using func or whether it’s provided using a closure.

So, we could call sorted() again, but rather than passing in the captainFirstTeam() function, instead start a new closure: write an open brace, list its 
parameters and return type, write in, then put our standard function code.

This is going to hurt your brain at first. It’s not because you’re not smart enough to understand closures or not cut out for Swift programming, only that 
closures are really hard. Don’t worry – we’re going to look at ways to make this easier!

Okay, let’s write some new code that calls sorted() using a closure:

let captainFirstTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }

    return name1 < name2
})
That’s a big chunk of syntax all at once, and again I want to say it’s going to get easier – in the very next chapter we’re going to look at ways to reduce 
the amount of code so it’s easier to see what’s going on.

But first I want to break down what’s happening there:

We’re calling the sorted() function as before.
Rather than passing in a function, we’re passing a closure – everything from the opening brace after by: down to the closing brace on the last line is part 
of the closure.
Directly inside the closure we list the two parameters sorted() will pass us, which are two strings. We also say that our closure will return a Boolean, 
then mark the start of the closure’s code by using in.
Everything else is just normal function code.
Again, there’s a lot of syntax in there and I wouldn’t blame you if you felt a headache coming on, but I hope you can see the benefit of closures at least 
a little: functions like sorted() let us pass in custom code to adjust how they work, and do so directly – we don’t need to write out a new function just 
for that one usage.

Now you understand what closures are, let’s see if we can make them easier to read…



How to use trailing closures and shorthand syntax

Swift has a few tricks up its sleeve to reduce the amount of syntax that comes with closures, but first let’s remind ourselves of the problem. Here’s the 
code we ended up with at the end of the previous chapter:

let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

let captainFirstTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }

    return name1 < name2
})

print(captainFirstTeam)
If you remember, sorted() can accept any kind of function to do custom sorting, with one rule: that function must accept two items from the array in 
question (that’s two strings here), and return a Boolean set to true if the first string should be sorted before the second.

To be clear, the function must behave like that – if it returned nothing, or if it only accepted one string, then Swift would refuse to build our code.

Think it through: in this code, the function we provide to sorted() must provide two strings and return a Boolean, so why do we need to repeat ourselves 
in our closure?

The answer is: we don’t. We don’t need to specify the types of our two parameters because they must be strings, and we don’t need to specify a return type 
because it must be a Boolean. So, we can rewrite the code to this:

let captainFirstTeam = team.sorted(by: { name1, name2 in
That’s already reduced the amount of clutter in the code, but we can go a step further: when one function accepts another as its parameter, like sorted() 
does, Swift allows special syntax called trailing closure syntax. It looks like this:

let captainFirstTeam = team.sorted { name1, name2 in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }

    return name1 < name2
}
Rather than passing the closure in as a parameter, we just go ahead and start the closure directly – and in doing so remove (by: from the start, and a 
losing parenthesis at the end. Hopefully you can now see why the parameter list and in come inside the closure, because if they were outside it would look
 even weirder!

There’s one last way Swift can make closures less cluttered: Swift can automatically provide parameter names for us, using shorthand syntax. With this 
syntax we don’t even write name1, name2 in any more, and instead rely on specially named values that Swift provides for us: $0 and $1, for the first and 
second strings respectively.

Using this syntax our code becomes even shorter:

let captainFirstTeam = team.sorted {
    if $0 == "Suzanne" {
        return true
    } else if $1 == "Suzanne" {
        return false
    }

    return $0 < $1
}
I left this one to last because it’s not as clear cut as the others – some people see that syntax and hate it because it’s less clear, and that’s okay.

Personally I wouldn’t use it here because we’re using each value more than once, but if our sorted() call was simpler – e.g., if we just wanted to do a 
reverse sort – then I would:

let reverseTeam = team.sorted {
    return $0 > $1
}
So, in is used to mark the end of the parameters and return type – everything after that is the body of the closure itself. There’s a reason for this, and 
you’ll see it for yourself soon enough.

There I’ve flipped the comparison from < to > so we get a reverse sort, but now that we’re down to a single line of code we can remove the return and get 
it down to almost nothing:

let reverseTeam = team.sorted { $0 > $1 }
There are no fixed rules about when to use shorthand syntax and when not to, but in case it’s helpful I use shorthand syntax unless any of the following 
are true:

The closure’s code is long.
$0 and friends are used more than once each.
You get three or more parameters (e.g. $2, $3, etc).
If you’re still unconvinced about the power of closures, let’s take a look at two more examples.

First up, the filter() function lets us run some code on every item in the array, and will send back a new array containing every item that returns true 
for the function. So, we could find all team players whose name begins with T like this:

let tOnly = team.filter { $0.hasPrefix("T") }
print(tOnly)
That will print ["Tiffany", "Tasha"], because those are the only two team members whose name begins with T.

And second, the map() function lets us transform every item in the array using some code of our choosing, and sends back a new array of all the transformed 
items:

let uppercaseTeam = team.map { $0.uppercased() }
print(uppercaseTeam)
That will print ["GLORIA", "SUZANNE", "PIPER", "TIFFANY", "TASHA"], because it has uppercased every name and produced a new array from the result.

Tip: When working with map(), the type you return doesn’t have to be the same as the type you started with – you could convert an array of integers to an 
array of strings, for example.

Like I said, you’re going to be using closures a lot with SwiftUI:

When you create a list of data on the screen, SwiftUI will ask you to provide a function that accepts one item from the list and converts it something it 
can display on-screen.
When you create a button, SwiftUI will ask you to provide one function to execute when the button is pressed, and another to generate the contents of the 
button – a picture, or some text, and so on.
Even just putting stacking pieces of text vertically is done using a closure.
Yes, you can create individual functions every time SwiftUI does this, but trust me: you won’t. Closures make this kind of code completely natural, and I 
think you’ll be amazed at how SwiftUI uses them to produce remarkably simple, clean code.



How to accept functions as parameters

There’s one last closure-related topic I want to look at, which is how to write functions that accept other functions as parameters. This is particularly 
important for closures because of trailing closure syntax, but it’s a useful skill to have regardless.

Previously we looked at this code:

func greetUser() {
    print("Hi there!")
}

greetUser()

var greetCopy: () -> Void = greetUser
greetCopy()
I’ve added the type annotation in there intentionally, because that’s exactly what we use when specifying functions as parameters: we tell Swift what 
parameters the function accepts, as well its return type.

Once again, brace yourself: the syntax for this is a little hard on the eyes at first! Here’s a function that generates an array of integers by repeating a 
function a certain number of times:

func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int]()

    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }

    return numbers
}
Let’s break that down…

The function is called makeArray(). It takes two parameters, one of which is the number of integers we want, and also returns an array of integers.
The second parameter is a function. This accepts no parameters itself, but will return one integer every time it’s called.
Inside makeArray() we create a new empty array of integers, then loop as many times as requested.
Each time the loop goes around we call the generator function that was passed in as a parameter. This will return one new integer, so we put that into the 
numbers array.
Finally the finished array is returned.
The body of the makeArray() is mostly straightforward: repeatedly call a function to generate an integer, adding each value to an array, then send it all back.

The complex part is the very first line:

func makeArray(size: Int, using generator: () -> Int) -> [Int] {
There we have two sets of parentheses and two sets of return types, so it can be a bit of a jumble at first. If you split it up you should be able to read 
it linearly:

We’re creating a new function.
The function is called makeArray().
The first parameter is an integer called size.
The second parameter is a function called generator, which itself accepts no parameters and returns an integer.
The whole thing – makeArray() – returns an array of integers.
The result is that we can now make arbitrary-sized integer arrays, passing in a function that should be used to generate each number:

let rolls = makeArray(size: 50) {
    Int.random(in: 1...20)
}

print(rolls)
And remember, this same functionality works with dedicated functions too, so we could write something like this:

func generateNumber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 50, using: generateNumber)
print(newRolls)
That will call generateNumber() 50 times to fill the array.

While you’re learning Swift and SwiftUI, there will only be a handful of times when you need to know how to accept functions as parameters, but at least 
now you have an inkling of how it works and why it matters.

There’s one last thing before we move on: you can make your function accept multiple function parameters if you want, in which case you can specify multiple 
trailing closures. The syntax here is very common in SwiftUI, so it’s important to at least show you a taste of it here.

To demonstrate this here’s a function that accepts three function parameters, each of which accept no parameters and return nothing:

func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
    print("About to start first work")
    first()
    print("About to start second work")
    second()
    print("About to start third work")
    third()
    print("Done!")
}
I’ve added extra print() calls in there to simulate specific work being done in between first, second, and third being called.

When it comes to calling that, the first trailing closure is identical to what we’ve used already, but the second and third are formatted differently: you 
end the brace from the previous closure, then write the external parameter name and a colon, then start another brace.

Here’s how that looks:

doImportantWork {
    print("This is the first work")
} second: {
    print("This is the second work")
} third: {
    print("This is the third work")
}
Having three trailing closures is not as uncommon as you might expect. For example, making a section of content in SwiftUI is done with three trailing 
closures: one for the content itself, one for a head to be put above, and one for a footer to be put below.