Conditions

If there’s one line from Shakespeare’s Hamlet that most people know, it’s “to be or not to be, that is the question.” Shakespeare meant that as the ultimate 
question of life or death, but it just so happens that Hamlet strikes right at the heart of logic in programming: evaluating whether a condition is true or not.

Today we’re going to get into the real detail of Swift: operators and conditions, which let us evaluate our program’s state as it runs and take different 
action depending on the result. There are several ways of doing it and you’ll need them all, but we’ll walk through them step by step so you can see how 
they compare.

Today you have four tutorials to work through, where you’ll meet things like if, switch, and more. Once you’ve watched each video and optionally gone 
through the extra reading, there’s a short test to help make sure you’ve understood what was taught.



How to check a condition is true or false
Programs very often make choices:

If the student’s exam score was over 80 then print a success message.
If the user entered a name that comes after their friend’s name alphabetically, put the friend’s name first.
If adding a number to an array makes it contain more than 3 items, remove the oldest one.
If the user was asked to enter their name and typed nothing at all, give them a default name of “Anonymous”.

Swift handles these with if statements, which let us check a condition and run some code if the condition is true. They look like this:

if someCondition {
    print("Do something")
}

Let’s break that down:

The condition starts with if, which signals to Swift we want to check some kind of condition in our code.
The someCondition part is where you write your condition – was the score over 80? Does the array contain more than 3 items?
If the condition is true – if the score really is over 80 – then we print the “Do something” message.

Of course, that isn’t everything in the code: I didn’t mention the little { and } symbols. These are called braces – opening and closing braces, more 
specifically – although sometimes you’ll hear them referred to as “curly braces” or “curly brackets”.

These braces are used extensively in Swift to mark blocks of code: the opening brace starts the block, and the closing brace ends it. Inside the code 
block is all the code we want to run if our condition happens to be true when it’s checked, which in our case is printing a message.

You can include as much code in there as you want:

if someCondition {
    print("Do something")
    print("Do something else")
    print("Do a third thing")
}

Of course, what really matters is the someCondition part, because that’s where your checking code comes in: what condition do you actually want to check?

Well, let’s try the score example: if a score constant is over 80, let’s print a message. Here’s how that would look in code:

let score = 85

if score > 80 {
    print("Great job!")
}

In that code, score > 80 is our condition. You’ll remember > from school meaning “is greater than”, so our complete condition is “if score is greater than 80.” 
And if it is greater than 80, “Great job!” will be printed – nice!

That > symbol is a comparison operator, because it compares two things and returns a Boolean result: is the thing on the left greater than the thing on the 
right? You can also use < for less than, >= for “greater than or equal”, and <= for “less than or equal.”

Let’s try it out – what do you think this code will print?

let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
    print("Where we're going we don't need roads.")
}

if percentage < 85 {
    print("Sorry, you failed the test.")
}

if age >= 18 {
    print("You're eligible to vote")
}

Try and run the code mentally in your head – which print() lines will actually be run?

Well, our first one will run if speed is greater than or equal to 88, and because it is exactly 88 the first print() code will be run.

The second one will run if percentage is less than 85, and because it is exactly 85 the second print() will not run – we used less than, not less than or equal.

The third will run if age is greater than or equal to 18, and because it’s exactly 18 the third print() will run.

Now let’s try our second example condition: if the user entered a name that comes after their friend’s name alphabetically, put the friend’s name first. 
You’ve seen how <, >= and others work great with numbers, but they also work equally well with strings right out of the box:

let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"

if ourName < friendName {
    print("It's \(ourName) vs \(friendName)")
}

if ourName > friendName {
    print("It's \(friendName) vs \(ourName)")
}

So, if the string inside ourName comes before the string inside friendName when sorted alphabetically, it prints ourName first then friendName, exactly as 
we wanted.

Let’s take a look at our third example condition: if adding a number to an array makes it contain more than 3 items, remove the oldest one. You’ve already 
met append(), count, and remove(at:), so we can now put all three together with a condition like this:

// Make an array of 3 numbers
var numbers = [1, 2, 3]

// Add a 4th
numbers.append(4)

// If we have over 3 items
if numbers.count > 3 {
    // Remove the oldest number
    numbers.remove(at: 0)
}

// Display the result
print(numbers)

Now let’s look at our fourth example condition: if the user was asked to enter their name and typed nothing at all, give them a default name of “Anonymous”.

To solve this you’ll first need to meet two other comparison operators you’ll use a lot, both of which handle equality. The first is == and means “is equal 
to,” which is used like this:

let country = "Canada"

if country == "Australia" {
    print("G'day!")
}

The second is !=, which means “is not equal to”, and is used like this:

let name = "Taylor Swift"

if name != "Anonymous" {
    print("Welcome, \(name)")
}

In our case, we want to check whether the username entered by the user is empty, which we could do like this:

// Create the username variable
var username = "taylorswift13"

// If `username` contains an empty string
if username == "" {
    // Make it equal to "Anonymous"
    username = "Anonymous"
}

// Now print a welcome message
print("Welcome, \(username)!")

That "" is an empty string: we start the string and end the string, with nothing in between. By comparing username to that, we’re checking if the user 
also entered an empty string for their username, which is exactly what we want.

Now, there are other ways of doing this check, and it’s important you understand what they do.

First, we could compare the count of the string – how many letters it has – against 0, like this:

if username.count == 0 {
    username = "Anonymous"
}

Comparing one string against another isn’t very fast in any language, so we’ve replaced the string comparison with an integer comparison: does the number 
of letters in the string equal 0?

In many languages that’s very fast, but not in Swift. You see, Swift supports all sorts of complex strings – literally every human language works out of 
the box, including emoji, and that just isn’t true in so many other programming languages. However, this really great support has a cost, and one part of 
that cost is that asking a string for its count makes Swift go through and count up all the letters one by one – it doesn’t just store its length separately 
from the string.

So, think about the situation where you have a massive string that stores the complete works of Shakespeare. Our little check for count == 0 has to go 
through and count all the letters in the string, even though as soon as we have counted at least one character we know the answer to our question.

As a result, Swift adds a second piece of functionality to all its strings, arrays, dictionaries, and sets: isEmpty. This will send back true if the thing 
you’re checking has nothing inside, and we can use it to fix our condition like this:

if username.isEmpty == true {
    username = "Anonymous"
}

That’s better, but we can go one step further. You see, ultimately what matters is that your condition must boil down to either true or false; Swift 
won’t allow anything else. In our case, username.isEmpty is already a Boolean, meaning it will be true or false, so we can make our code even simpler:

if username.isEmpty {
    username = "Anonymous"
}

If isEmpty is true the condition passes and username gets set to Anonymous, otherwise the condition fails.



How to check multiple conditions
When we use if we must provide Swift some kind of condition that will either be true or false once it has been evaluated. If you want to check for several 
different values, you can place them one after the other like this:

let age = 16

if age >= 18 {
    print("You can vote in the next election.")
}

if age < 18 {
    print("Sorry, you're too young to vote.")
}

However, that’s not very efficient if you think about it: our two conditions are mutually exclusive, because if someone is greater than or equal to 18 
(the first condition) then they can’t be less than 18 (the second condition), and the opposite is also true. We’re making Swift do work that just isn’t needed.

In this situation, Swift provides us with a more advanced condition that lets us add an else block to our code – some code to run if the condition is not true.

Using else we could rewrite our previous code to this:

let age = 16

if age >= 18 {
    print("You can vote in the next election.")
} else {
    print("Sorry, you're too young to vote.")
}

Now Swift only needs to check age once: if it’s greater than or equal to 18 the first print() code is run, but if it’s any value less than 18 the second 
print() code is run.

So, now our condition looks like this:

if someCondition {
    print("This will run if the condition is true")
} else {
    print("This will run if the condition is false")
}

There’s an even more advanced condition called else if, which lets you run a new check if the first one fails. You can have just one of these if you want, 
or have multiple else if, and even combine else if with an else if needed. However, you can only ever have one else, because that means “if all the other 
conditions have been false.”

Here’s how that looks:

let a = false
let b = true

if a {
    print("Code to run if a is true")
} else if b {
    print("Code to run if a is false but b is true")
} else {
    print("Code to run if both a and b are false")
}

You can keep on adding more and more else if conditions if you want, but watch out that your code doesn’t get too complicated!

As well as using else and else if to make more advanced conditions, you can also check more than one thing. For example, we might want to say “if today’s 
temperature is over 20 degrees Celsius but under 30, print a message.”

This has two conditions, so we could write this:

let temp = 25

if temp > 20 {
    if temp < 30 {
        print("It's a nice day.")
    }
}

Although that works well enough, Swift provides a shorter alternative: we can use && to combine two conditions together, and the whole condition will only 
be true if the two parts inside the condition are true.

So, we could change our code to this:

if temp > 20 && temp < 30 {
    print("It's a nice day.")
}

You should read && as “and”, so our whole conditions reads “if temp is greater than 20 and temp is less than 30, print a message.” It’s called a logical 
operator because it combines Booleans to make a new Boolean.

&& has a counterpart that is two pipe symbols, ||, which means “or”. Whereas && will only make a condition be true if both subconditions are true, || will
make a condition be true if either subcondition is true.

For example, we could say that a user can buy a game if they are at least 18, or if they are under 18 they must have permission from a parent. We could 
write that using || like so:

let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent == true {
    print("You can buy the game")
}

That will print “You can buy the game”, because although the first half of our condition fails – the user is not at least 18 – the second half passes, 
because they do have parental consent.

Remember, using == true in a condition can be removed, because we’re obviously already checking a Boolean. So, we could write this instead:

if userAge >= 18 || hasParentalConsent {
    print("You can buy the game")
}

To finish up with checking multiple conditions, let’s try a more complex example that combines if, else if, else, and || all at the same time, and even 
shows off how enums fit into conditions.

In this example we’re going to create an enum called TransportOption, which contains five cases: airplane, helicopter, bicycle, car, and scooter. We’ll 
then assign an example value to a constant, and run some checks:

If we are going somewhere by airplane or by helicopter, we’ll print “Let’s fly!”
If we’re going by bicycle, we’ll print “I hope there’s a bike path…”
If we’re going by car, we’ll print “Time to get stuck in traffic.”
Otherwise we’ll print “I’m going to hire a scooter now!”

Here’s the code for that:

enum TransportOption {
    case airplane, helicopter, bicycle, car, scooter
}

let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("I hope there's a bike path…")
} else if transport == .car {
    print("Time to get stuck in traffic.")
} else {
    print("I'm going to hire a scooter now!")
}

I’d like to pick out a few parts of that code:

1. When we set the value for transport we need to be explicit that we’re referring to TransportOption.airplane. We can’t just write .airplane because 
Swift doesn’t understand we mean the TransportOption enum.

2. Once that has happened, we don’t need to write TransportOption any more because Swift knows transport must be some kind of TransportOption. So, we can 
check whether it’s equal to .airplane rather than TransportOption.airplane.

3. The code using || to check whether transport is equal to .airplane or equal to .helicopter, and if either of them are true then the condition is true, 
and “Let’s fly!” is printed.

4. If the first condition fails – if the transport mode isn’t .airplane or .helicopter – then the second condition is run: is the transport mode .bicycle? 
If so, “I hope there’s a bike path…” is printed.

5. If we aren’t going by bicycle either, then we check whether we’re going by car. If we are, “Time to get stuck in traffic.” is printed.

6. Finally, if all the previous conditions fail then the else block is run, and it means we’re going by scooter.



How to use switch statements to check multiple conditions
You can use if and else if repeatedly to check conditions as many times as you want, but it gets a bit hard to read. For example, if we had a weather 
forecast from an enum we could choose which message to print based on a series of conditions, like this:

enum Weather {
    case sun, rain, wind, snow, unknown
}

let forecast = Weather.sun

if forecast == .sun {
    print("It should be a nice day.")
} else if forecast == .rain {
    print("Pack an umbrella.")
} else if forecast == .wind {
    print("Wear something warm")
} else if forecast == .snow {
    print("School is cancelled.")
} else {
    print("Our forecast generator is broken!")
}

That works, but it has problems:

We keep having to write forecast, even though we’re checking the same thing each time.
I accidentally checked .rain twice, even though the second check can never be true because the second check is only performed if the first check failed.
I didn’t check .snow at all, so we’re missing functionality.

We can solve all three of those problems using a different way of checking conditions called switch. This also lets us check individual cases one by one, 
but now Swift is able to help out. In the case of an enum, it knows all possible cases the enum can have, so if we miss one or check one twice it will complain.

So, we can replace all those if and else if checks with this:

switch forecast {
case .sun:
    print("It should be a nice day.")
case .rain:
    print("Pack an umbrella.")
case .wind:
    print("Wear something warm")
case .snow:
    print("School is cancelled.")
case .unknown:
    print("Our forecast generator is broken!")
}

Let’s break that down:

We start with switch forecast, which tells Swift that’s the value we want to check.
We then have a string of case statements, each of which are values we want to compare against forecast.
Each of our cases lists one weather type, and because we’re switching on forecast we don’t need to write Weather.sun, Weather.rain and so on – 
Swift knows it must be some kind of Weather.
After each case, we write a colon to mark the start of the code to run if that case is matched.
We use a closing brace to end the switch statement.

If you try changing .snow for .rain, you’ll see Swift complains loudly: once that we’ve checked .rain twice, and again that our switch statement is not 
exhaustive – that it doesn’t handle all possible cases.

If you’ve ever used other programming languages, you might have noticed that Swift’s switch statement is different in two places:

All switch statements must be exhaustive, meaning that all possible values must be handled in there so you can’t leave one off by accident.
Swift will execute the first case that matches the condition you’re checking, but no more. Other languages often carry on executing other code from all 
subsequent cases, which is usually entirely the wrong default thing to do.

Although both those statements are true, Swift gives us a little more control if we need it.

First, yes all switch statements must be exhaustive: you must ensure all possible values are covered. If you’re switching on a string then clearly it’s not 
possible to make an exhaustive check of all possible strings because there is an infinite number, so instead we need to provide a default case – code to 
run if none of the other cases match.

For example, we could switch over a string containing a place name:

let place = "Metropolis"

switch place {
case "Gotham":
    print("You're Batman!")
case "Mega-City One":
    print("You're Judge Dredd!")
case "Wakanda":
    print("You're Black Panther!")
default:
    print("Who are you?")
}

That default: at the end is the default case, which will be run if all cases have failed to match.

Remember: Swift checks its cases in order and runs the first one that matches. If you place default before any other case, that case is useless because it 
will never be matched and Swift will refuse to build your code.

Second, if you explicitly want Swift to carry on executing subsequent cases, use fallthrough. This is not commonly used, but sometimes – just sometimes – 
it can help you avoid repeating work.

For example, there’s a famous Christmas song called The Twelve Days of Christmas, and as the song goes on more and more gifts are heaped on an unfortunate 
person who by about day six has a rather full house.

We could make a simple approximation of this song using fallthrough. First, here’s how the code would look without fallthrough:

let day = 5
print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
case 4:
    print("4 calling birds")
case 3:
    print("3 French hens")
case 2:
    print("2 turtle doves")
default:
    print("A partridge in a pear tree")
}

That will print “5 golden rings”, which isn’t quite right. On day 1 only “A partridge in a pear tree” should be printed, on day 2 it should be “2 turtle 
doves” then “A partridge in a pear tree”, on day 3 it should be “3 French hens”, “2 turtle doves”, and… well, you get the idea.

We can use fallthrough to get exactly that behavior:

let day = 5
print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
    fallthrough
case 4:
    print("4 calling birds")
    fallthrough
case 3:
    print("3 French hens")
    fallthrough
case 2:
    print("2 turtle doves")
    fallthrough
default:
    print("A partridge in a pear tree")
}

That will match the first case and print “5 golden rings”, but the fallthrough line means case 4 will execute and print “4 calling birds”, which in turn 
uses fallthrough again so that “3 French hens” is printed, and so on. It’s not a perfect match to the song, but at least you can see the functionality in 
action!



How to use the ternary conditional operator for quick tests
There’s one last way to check conditions in Swift, and when you’ll see it chances are you’ll wonder when it’s useful. To be fair, for a long time I very 
rarely used this approach, but as you’ll see later it’s really important with SwiftUI.

This option is called the ternary conditional operator. To understand why it has that name, you first need to know that +, -, ==, and so on are all called 
binary operators because they work with two pieces of input: 2 + 5, for example, works with 2 and 5.

Ternary operators work with three pieces of input, and in fact because the ternary conditional operator is the only ternary operator in Swift, you’ll often 
hear it called just “the ternary operator.”

Anyway, enough about names: what does this actually do? Well, the ternary operator lets us check a condition and return one of two values: something if the 
condition is true, and something if it’s false.

For example, we could create a constant called age that stores someone’s age, then create a second constant called canVote that will store whether that 
person is able to vote or not:

let age = 18
let canVote = age >= 18 ? "Yes" : "No"

When that code runs, canVote will be set to “Yes” because age is set to 18.

As you can see, the ternary operator is split into three parts: a check (age >= 18), something for when the condition is true (“Yes”), and something for 
when the condition is false (“No”). That makes it exactly like a regular if and else block, in the same order.

If it helps, Scott Michaud suggested a helpful mnemonic: WTF. It stands for “what, true, false”, and matches the order of our code:

What is our condition? Well, it’s age >= 18.
What to do when the condition is true? Send back “Yes”, so it can be stored in canVote.
And if the condition is false? Send back “No”.

Let’s look at some other examples, start with an easy one that reads an hour in 24-hour format and prints one of two messages:

let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

Notice how that doesn’t assign the result anywhere – either the true or false case just gets printed depending on the value of hour.

Or here’s one that reads the count of an array as part of its condition, then sends back one of two strings:

let names = ["Jayne", "Kaylee", "Mal"]   
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)

It gets a little hard to read when your condition use == to check for equality, as you can see here:

enum Theme {
    case light, dark
}

let theme = Theme.dark

let background = theme == .dark ? "black" : "white"
print(background)

The = theme == part is usually the bit folks find hard to read, but remember to break it down:

What? theme == .dark
True: “black”
False: “white”

So if theme is equal to .dark return “Black”, otherwise return “White”, then assign that to background.

Now, you might be wondering why the ternary operator is useful, particularly when we have regular if/else conditions available to us. I realize it’s not a 
great answer, but you’ll have to trust me on this: there are some times, particularly with SwiftUI, when we have no choice and must use a ternary.

You can see roughly what the problem is with our code to check hours:

let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")
If we wanted to write that out using if and else we’d either need to write this invalid code:

print(
    if hour < 12 {
        "It's before noon"
    } else {
        "It's after noon"
    }
)
Or run print() twice, like this:

if hour < 12 {
    print("It's before noon")
} else {
    print("It's after noon")
}

That second one works fine here, but it becomes almost impossible in SwiftUI as you’ll see much later. So, even though you might look at the ternary 
operator and wonder why you’d ever use it, please trust me: it matters!