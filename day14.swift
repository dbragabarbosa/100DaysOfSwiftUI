Optionals

Null references – literally when a variable has no value – were invented by Tony Hoare way back in 1965. When asked about it in retrospect, he said “I call 
it my billion-dollar mistake” because they lead to so many problems.

This is the last day that you’ll be learning the fundamentals of Swift, and it’s devoted exclusively to Swift’s solution to null references, known as 
optionals. These are a really important language feature, but they can hurt your brain a little – don’t feel bad if you need to repeat some tutorials a 
few times.

In essence, an optional is trying to answer the question “what if our variable doesn’t have any sort of value at all?” Swift wants to make sure all our 
programs are as safe as possible, so it has some very specific – and very important! – techniques for handling this eventuality.

Today you have five tutorials to work through, where you’ll meet optionals, optional unwrapping, nil coalescing, and more.



How to handle missing data with optionals

Swift likes to be predictable, which means as much as possible it encourages us to write code that is safe and will work the way we expect. You’ve already 
met throwing functions, but Swift has another important way of ensuring predictability called optionals – a word meaning “this thing might have a value or 
might not.”

To see optionals in action, think about the following code:

let opposites = [
    "Mario": "Wario",
    "Luigi": "Waluigi"
]

let peachOpposite = opposites["Peach"]

There we create a [String: String] dictionary with two keys: Mario and Luigi. We then attempt to read the value attached to the key “Peach”, which doesn’t 
exist, and we haven’t provided a default value to send back in place of missing data.

What will peachOpposite be after that code runs? This is a [String: String] dictionary, which means the keys are strings and the values are strings, but we 
just tried to read a key that doesn’t exist – it wouldn’t make sense to get a string back if there isn’t a value there.

Swift’s solution is called optionals, which means data that might be present or might not. They are primarily represented by placing a question mark after 
your data type, so in this case peachOpposite would be a String? rather than a String.

Optionals are like a box that may or may not have something inside. So, a String? means there might be a string waiting inside for us, or there might be 
nothing at all – a special value called nil, that means “no value”. Any kind of data can be optional, including Int, Double, and Bool, as well as instances 
of enums, structs, and classes.

You’re probably thinking “so… what has actually changed here? Before we had a String, and now we have a String?, but how does that actually change the code 
we write?”

Well, here’s the clincher: Swift likes our code to be predictable, which means it won’t let us use data that might not be there. In the case of optionals, 
that means we need to unwrap the optional in order to use it – we need to look inside the box to see if there’s a value, and, if there is, take it out and 
use it.

Swift gives us two primary ways of unwrapping optionals, but the one you’ll see the most looks like this:

if let marioOpposite = opposites["Mario"] {
    print("Mario's opposite is \(marioOpposite)")
}

This if let syntax is very common in Swift, and combines creating a condition (if) with creating a constant (let). Together, it does three things:

It reads the optional value from the dictionary.
If the optional has a string inside, it gets unwrapped – that means the string inside gets placed into the marioOpposite constant.
The condition has succeeded – we were able to unwrap the optional – so the condition’s body is run.

The condition’s body will only be run if the optional had a value inside. Of course, if you want to add an else block you can – it’s just a normal condition, 
so this kind of code is fine:

var username: String? = nil

if let unwrappedName = username {
    print("We got a user: \(unwrappedName)")
} else {
    print("The optional was empty.")
}

Think of optionals a bit like Schrödinger’s data type: there might be a value inside the box or there might not be, but the only way to find out is to check.

This might seem rather academic so far, but optionals really are critical for helping us produce better software. You see, in the same way optionals mean 
data may or may not be present, non-optionals – regular strings, integers, etc – mean data must be available.

Think about it: if we have a non-optional Int it means there is definitely a number inside, always. It might be something like 1 million or 0, but it’s 
still a number and is guaranteed to be present. In comparison, an optional Int set to nil has no value at all – it’s not 0 or any other number, it’s nothing
 at all.

Similarly, if we have a non-optional String it means there is definitely a string in there: it might be something like “Hello” or an empty string, but both 
of those are different from an optional string set to nil.

Every data type can be optional if needed, including collections such as Array and Dictionary. Again, an array of integers might contain one or more 
numbers, or perhaps no numbers at all, but both of those are different from optional arrays set to nil.

To be clear, an optional integer set to nil is not the same as a non-optional integer holding 0, an optional string set to nil is not the same as a 
non-optional string that is currently set to an empty string, and an optional array set to nil is not the same as a non-optional array that currently has
 no items – we’re talking about the absence of any data at all, empty or otherwise.

As Zev Eisenberg said, “Swift didn’t introduce optionals. It introduced non-optionals.”

You can see this in action if you try to pass an optional integer into a function that requires a non-optional integer, like this:

func square(number: Int) -> Int {
    number * number
}

var number: Int? = nil
print(square(number: number))

Swift will refuse to build that code, because the optional integer needs to be unwrapped – we can’t use an optional value where a non-optional is needed, 
because if there were no value inside we’d hit a problem.

So, to use the optional we must first unwrap it like this:

if let unwrappedNumber = number {
    print(square(number: unwrappedNumber))
}

Before we’re done, I want to mention one last thing: when unwrapping optionals, it’s very common to unwrap them into a constant of the same name. 
This is perfectly allowable in Swift, and means we don’t need to keep naming constants unwrappedNumber or similar.

Using this approach, we could rewrite the previous code to this:

if let number = number {
    print(square(number: number))
}

This style is a bit confusing when you first read it, because now it feels like quantum physics – can number really be both optional and non-optional at 
the same time? Well, no.

What’s happening here is that we’re temporarily creating a second constant of the same name, available only inside the condition’s body. This is called 
shadowing, and it’s mainly used with optional unwraps like you can see above.

So, inside the condition’s body we have an unwrapped value to work with – a real Int rather than an optional Int? – but outside we still have the optional.



How to unwrap optionals with guard

You’ve already seen how Swift uses if let to unwrap optionals, and it’s the most common way of using optionals. But there is a second way that does much 
the same thing, and it’s almost as common: guard let.

It looks like this:

func printSquare(of number: Int?) {
    guard let number = number else {
        print("Missing input")
        return
    }

    print("\(number) x \(number) is \(number * number)")
}
Like if let, guard let checks whether there is a value inside an optional, and if there is it will retrieve the value and place it into a constant of our 
choosing.

However, the way it does so flips things around:

var myVar: Int? = 3

if let unwrapped = myVar {
    print("Run if myVar has a value inside")
}

guard let unwrapped = myVar else {
    print("Run if myVar doesn't have a value inside")
}
So, if let runs the code inside its braces if the optional had a value, and guard let runs the code inside its braces if the optional didn’t have a value. 
This explains the use of else in the code: “check that we can unwrap the optional, but if we can’t then…”

I realize that sounds like a small difference, but it has important ramifications. You see, what guard provides is the ability to check whether our program 
state is what we expect, and if it isn’t to bail out – to exit from the current function, for example.

This is sometimes called an early return: we check that all a function’s inputs are valid right as the function starts, and if any aren’t valid we get to 
run some code then exit straight away. If all our checks pass, our function can run exactly as intended.

guard is designed exactly for this style of programming, and in fact does two things to help:

If you use guard to check a function’s inputs are valid, Swift will always require you to use return if the check fails.
If the check passes and the optional you’re unwrapping has a value inside, you can use it after the guard code finishes.
You can see both of these points in action if you look at the printSquare() function from earlier:

func printSquare(of number: Int?) {
    guard let number = number else {
        print("Missing input")

        // 1: We *must* exit the function here
        return
    }

    // 2: `number` is still available outside of `guard`
    print("\(number) x \(number) is \(number * number)")
}
So: use if let to unwrap optionals so you can process them somehow, and use guard let to ensure optionals have something inside them and exit otherwise.

Tip: You can use guard with any condition, including ones that don’t unwrap optionals. For example, you might use guard someArray.isEmpty else { return }.



How to unwrap optionals with nil coalescing

Wait… Swift has a third way of unwrapping optionals? Yep! And it’s really useful, too: it’s called the nil coalescing operator and it lets us unwrap an 
optional and provide a default value if the optional was empty.

Let’s rewind a bit:

let captains = [
    "Enterprise": "Picard",
    "Voyager": "Janeway",
    "Defiant": "Sisko"
]

let new = captains["Serenity"]
That reads a non-existent key in our captains dictionary, which means new will be an optional string to set to nil.

With the nil coalescing operator, written ??, we can provide a default value for any optional, like this:

let new = captains["Serenity"] ?? "N/A"
That will read the value from the captains dictionary and attempt to unwrap it. If the optional has a value inside it will be sent back and stored in new, 
but if it doesn’t then “N/A” will be used instead.

This means no matter what the optional contains – a value or nil – the end result is that new will be a real string, not an optional one. That might be the 
string from inside the captains value, or it might be “N/A”.

Now, I know what you’re thinking: can’t we just specify a default value when reading from the dictionary? If you’re thinking that you’re absolutely correct:

let new = captains["Serenity", default: "N/A"]
That produces exactly the same result, which might make it seem like the nil coalescing operator is pointless. However, not only does the nil coalescing 
operator work with dictionaries, but it works with any optionals.

For example, the randomElement() method on arrays returns one random item from the array, but it returns an optional because you might be calling it on an 
empty array. So, we can use nil coalescing to provide a default:

let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"
Or perhaps you have a struct with an optional property, and want to provide a sensible default for when it’s missing:

struct Book {
    let title: String
    let author: String?
}

let book = Book(title: "Beowulf", author: nil)
let author = book.author ?? "Anonymous"
print(author)
It’s even useful if you create an integer from a string, where you actually get back an optional Int? because the conversion might have failed – you might 
have provided an invalid integer, such as “Hello”. Here we can use nil coalescing to provide a default value, like this:

let input = ""
let number = Int(input) ?? 0
print(number)
As you can see, the nil coalescing operator is useful anywhere you have an optional and want to use the value inside or provide a default value if it’s missing.



How to handle multiple optionals using optional chaining

Optional chaining is a simplified syntax for reading optionals inside optionals. That might sound like something you’d want to use rarely, but if I show you 
an example you’ll see why it’s helpful.

Take a look at this code:

let names = ["Arya", "Bran", "Robb", "Sansa"]

let chosen = names.randomElement()?.uppercased() ?? "No one"
print("Next in line: \(chosen)")
That uses two optional features at once: you’ve already seen how the nil coalescing operator helps provide a default value if an optional is empty, but 
before that you see optional chaining where we have a question mark followed by more code.

Optional chaining allows us to say “if the optional has a value inside, unwrap it then…” and we can add more code. In our case we’re saying “if we managed 
to get a random element from the array, then uppercase it.” Remember, randomElement() returns an optional because the array might be empty.

The magic of optional chaining is that it silently does nothing if the optional was empty – it will just send back the same optional you had before, still 
empty. This means the return value of an optional chain is always an optional, which is why we still need nil coalescing to provide a default value.

Optional chains can go as long as you want, and as soon as any part sends back nil the rest of the line of code is ignored and sends back nil.

To give you an example that pushes optional chaining harder, imagine this: we want to place books in alphabetical order based on their author names. 
If we break this right down, then:

We have an optional instance of a Book struct – we might have a book to sort, or we might not.
The book might have an author, or might be anonymous.
If it does have an author string present, it might be an empty string or have text, so we can’t always rely on the first letter being there.
If the first letter is there, make sure it’s uppercase so that authors with lowercase names such as bell hooks are sorted correctly.

Here’s how that would look:

struct Book {
    let title: String
    let author: String?
}

var book: Book? = nil
let author = book?.author?.first?.uppercased() ?? "A"
print(author)

So, it reads “if we have a book, and the book has an author, and the author has a first letter, then uppercase it and send it back, otherwise send back A”.

Admittedly it’s unlikely you’ll ever dig that far through optionals, but I hope you can see how delightfully short the syntax is!



How to handle function failure with optionals

When we call a function that might throw errors, we either call it using try and handle errors appropriately, or if we’re certain the function will not 
fail we use try! and accept that if we were wrong our code will crash. (Spoiler: you should use try! very rarely.)

However, there is an alternative: if all we care about is whether the function succeeded or failed, we can use an optional try to have the function return 
an optional value. If the function ran without throwing any errors then the optional will contain the return value, but if any error was thrown the function 
will return nil. This means we don’t get to know exactly what error was thrown, but often that’s fine – we might just care if the function worked or not.

Here’s how it looks:

enum UserError: Error {
    case badID, networkFailed
}

func getUser(id: Int) throws -> String {
    throw UserError.networkFailed
}

if let user = try? getUser(id: 23) {
    print("User: \(user)")
}

The getUser() function will always throw a networkFailed error, which is fine for our testing purposes, but we don’t actually care what error was thrown – 
all we care about is whether the call sent back a user or not.

This is where try? helps: it makes getUser() return an optional string, which will be nil if any errors are thrown. If you want to know exactly what error 
happened then this approach won’t be useful, but a lot of the time we just don’t care.

If you want, you can combine try? with nil coalescing, which means “attempt to get the return value from this function, but if it fails use this default 
value instead.”

Be careful, though: you need to add some parentheses before nil coalescing so that Swift understands exactly what you mean. For example, you’d write this:

let user = (try? getUser(id: 23)) ?? "Anonymous"
print(user)

You’ll find try? is mainly used in three places:

In combination with guard let to exit the current function if the try? call returns nil.

In combination with nil coalescing to attempt something or provide a default value on failure.

When calling any throwing function without a return value, when you genuinely don’t care if it succeeded or not – maybe you’re writing to a log file or 
sending analytics to a server, for example.



Summary: Optionals

In these chapters we’ve covered one of Swift’s most important features, and although most people find optionals hard to understand at first almost everyone 
agrees they are useful in practice.

Let’s recap what we learned:

Optionals let us represent the absence of data, which means we’re able to say “this integer has no value” – that’s different from a fixed number such as 0.

As a result, everything that isn’t optional definitely has a value inside, even if that’s just an empty string.

Unwrapping an optional is the process of looking inside a box to see what it contains: if there’s a value inside it’s sent back for use, otherwise there 
will be nil inside.

We can use if let to run some code if the optional has a value, or guard let to run some code if the optional doesn’t have a value – but with guard we 
must always exit the function afterwards.

The nil coalescing operator, ??, unwraps and returns an optional’s value, or uses a default value instead.

Optional chaining lets us read an optional inside another optional with a convenient syntax.

If a function might throw errors, you can convert it into an optional using try? – you’ll either get back the function’s return value, or nil if an error 
is thrown.

Optionals are second only to closures when it comes to language features folks struggle to learn, but I promise after a few months you’ll wonder how you 
could live without them!