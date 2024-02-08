Loops
Loops are one of the things that make computers so utterly brilliant: the ability to repeat some simple task billions of times every second.

Of course, what goes in those loops is down to you: you might be adding some numbers, you might be reading some sensor data, or you might be redrawing 
the screen 120 times a second. As Craig Bruce said, “it’s hardware that makes a machine fast, but it’s software that makes a fast machine slow.”

Today you have three tutorials to work through, plus a summary and a checkpoint. Once you’ve completed each video you can read the optional extra section, 
and there’s a short test to help make sure you’ve understood what was taught.



How to use a for loop to repeat work

Computers are really great at doing repetitive work, and Swift makes it easy to repeat some code a fixed number of times, or once for every item in an array, 
dictionary, or set.

Let’s start with something simple: if we have an array of strings, we can print each string out like this:

let platforms = ["iOS", "macOS", "tvOS", "watchOS"]

for os in platforms {
    print("Swift works great on \(os).")
}

That loops over all the items in platforms, putting them one by one into os. We haven’t created os elsewhere; it’s created for us as part of the loop and 
made available only inside the opening and closing braces.

Inside the braces is the code we want to run for each item in the array, so the code above will print four lines – one for each loop item. First it puts 
“iOS” in there then calls print(), then it puts “macOS” in there and calls print(), then “tvOS”, then “watchOS”.

To make things easier to understand, we give these things common names:

We call the code inside the braces the loop body
We call one cycle through the loop body a loop iteration.
We call os the loop variable. This exists only inside the loop body, and will change to a new value in the next loop iteration.
I should say that the name os isn’t special – we could have written this instead:

for name in platforms {
    print("Swift works great on \(name).")
}
Or even this:

for rubberChicken in platforms {
    print("Swift works great on \(rubberChicken).")
}

The code will still work exactly the same.

In fact, Xcode is really smart here: if you write for plat it will recognize that there’s an array called platforms, and offer to autocomplete all of for 
platform in platforms – it recognizes that platforms is plural and suggests the singular name for the loop variable. When you see Xcode’s suggestion appear, 
press Return to select it.

Rather than looping over an array (or set, or dictionary – the syntax is the same!), you can also loop over a fixed range of numbers. For example, we 
could print out the 5 times table from 1 through 12 like this:

for i in 1...12 {
    print("5 x \(i) is \(5 * i)")
}

A couple of things are new there, so let’s pause and examine them:

I used the loop variable i, which is a common coding convention for “number you’re counting with”. If you’re counting a second number you would use j, and 
if you’re counting a third you would use k, but if you’re counting a fourth maybe you should pick better variable names.
The 1...12 part is a range, and means “all integer numbers between 1 and 12, as well as 1 and 12 themselves.” Ranges are their own unique data type in Swift.
So, when that loop first runs i will be 1, then it will be 2, then 3, etc, all the way up to 12, after which the loop finishes.

You can also put loops inside loops, called nested loops, like this:

for i in 1...12 {
    print("The \(i) times table:")

    for j in 1...12 {
        print("  \(j) x \(i) is \(j * i)")
    }

    print()
}

That shows off a couple of other new things, so again let’s pause and look closer:

There’s now a nested loop: we count from 1 through 12, and for each number inside there we count 1 through 12 again.
Using print() by itself, with no text or value being passed in, will just start a new line. This helps break up our output so it looks nicer on the screen.
So, when you see x...y you know it creates a range that starts at whatever number x is, and counts up to and including whatever number y is.

Swift has a similar-but-different type of range that counts up to but excluding the final number: ..<. This is best seen in code:

for i in 1...5 {
    print("Counting from 1 through 5: \(i)")
}

print()

for i in 1..<5 {
    print("Counting 1 up to 5: \(i)")
}

When that runs, it will print for numbers 1, 2, 3, 4, 5 in the first loop, but only numbers 1, 2, 3, and 4 in the second. I pronounce 1...5 as “one 
through five”, and 1..<5 as “one up to five,” and you’ll see similar wording elsewhere in Swift.

Tip: ..< is really helpful for working with arrays, where we count from 0 and often want to count up to but excluding the number of items in the array.

Before we’re done with for loops, there’s one more thing I want to mention: sometimes you want to run some code a certain number of times using a range, 
but you don’t actually want the loop variable – you don’t want the i or j, because you don’t use it.

In this situation, you can replace the loop variable with an underscore, like this:

var lyric = "Haters gonna"

for _ in 1...5 {
    lyric += " hate"
}

print(lyric)



How to use a while loop to repeat work

Swift has a second kind of loop called while: provide it with a condition, and a while loop will continually execute the loop body until the condition is 
false.

Although you’ll still see while loops from time to time, they aren’t as common as for loops. As a result, I want to cover them so you know they exist, but 
let’s not dwell on them too long, okay?

Here’s a basic while loop to get us started:

var countdown = 10

while countdown > 0 {
    print("\(countdown)…")
    countdown -= 1
}

print("Blast off!")

That creates an integer counter starting at 10, then starts a while loop with the condition countdown > 0. So, the loop body – printing the number and 
subtracting 1 – will run continually until countdown is equal to or below 0, at which point the loop will finish and the final message will be printed.

while loops are really useful when you just don’t know how many times the loop will go around. To demonstrate this, I want to introduce you to a really 
useful piece of functionality that Int and Double both have: random(in:). Give that a range of numbers to work with, and it will send back a random Int 
or Double somewhere inside that range.

For example, this creates a new integer between 1 and 1000

let id = Int.random(in: 1...1000)

And this creates a random decimal between 0 and 1:

let amount = Double.random(in: 0...1)

We can use this functionality with a while loop to roll some virtual 20-sided dice again and again, ending the loop only when a 20 is rolled – a critical 
hit for all you Dungeons & Dragons players out there.

Here’s the code to make that happen:

// create an integer to store our roll
var roll = 0

// carry on looping until we reach 20
while roll != 20 {
    // roll a new dice and print what it was
    roll = Int.random(in: 1...20)
    print("I rolled a \(roll)")
}

// if we're here it means the loop ended – we got a 20!    
print("Critical hit!")

You’ll find yourself using both for and while loops in your own code: for loops are more common when you have a finite amount of data to go through, such 
as a range or an array, but while loops are really helpful when you need a custom condition.



How to skip loop items with break and continue

Swift gives us two ways to skip one or more items in a loop: continue skips the current loop iteration, and break skips all remaining iterations. Like
while loops these are sometimes used, but in practice much less than you might think.

Let’s look at them individually, starting with continue. When you’re looping over an array of data, Swift will take out one item from the array and 
execute the loop body using it. If you call continue inside that loop body, Swift will immediately stop executing the current loop iteration and jump 
to the next item in the loop, where it will carry on as normal. This is commonly used near the start of loops, where you eliminate loop variables that 
don’t pass a test of your choosing.

Here’s an example:

let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue
    }

    print("Found picture: \(filename)")
}

That creates an array of filename strings, then loops over each one and checks to make sure it has the suffix “.jpg” – that it’s a picture. continue is 
used with all the filenames failing that test, so that the rest of the loop body is skipped.

As for break, that exits a loop immediately and skips all remaining iterations. To demonstrate this, we could write some code to calculate 10 common 
multiples for two numbers:

let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
    if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
        multiples.append(i)

        if multiples.count == 10 {
            break
        }
    }
}

print(multiples)

That does quite a lot:

1.Create two constants to hold two numbers.

2.Create an integer array variable that will store common multiples of our two numbers.

3.Count from 1 through 100,000, assigning each loop variable to i.

4.If i is a multiple of both the first and second numbers, append it to the integer array.

5.Once we hit 10 multiples, call break to exit the loop.

6.Print out the resulting array.

So, use continue when you want to skip the rest of the current loop iteration, and use break when you want to skip all remaining loop iterations.



Summary: Conditions and loops

We’ve covered a lot about conditions and loops in the previous chapters, so let’s recap:

We use if statements to check a condition is true. You can pass in any condition you want, but ultimately it must boil down to a Boolean.

If you want, you can add an else block, and/or multiple else if blocks to check other conditions. Swift executes these in order.

You can combine conditions using ||, which means that the whole condition is true if either subcondition is true, or &&, which means the whole condition 
is true if both subconditions are true.

If you’re repeating the same kinds of check a lot, you can use a switch statement instead. These must always be exhaustive, which might mean adding a 
default case.

If one of your switch cases uses fallthrough, it means Swift will execute the following case afterwards. This is not used commonly.

The ternary conditional operator lets us check WTF: What, True, False. Although it’s a little hard to read at first, you’ll see this used a lot in SwiftUI.

for loops let us loop over arrays, sets, dictionaries, and ranges. You can assign items to a loop variable and use it inside the loop, or you can use 
underscore, _, to ignore the loop variable.

while loops let us craft custom loops that will continue running until a condition becomes false.

We can skip some or all loop items using continue or break respectively.

That’s another huge chunk of new material, but with conditions and loops you now know enough to build some really useful software – give it a try!