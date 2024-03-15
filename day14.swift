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