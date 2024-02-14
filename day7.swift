Functions, part one

Functions let us wrap up pieces of code so they can be used in lots of places. We can send data into functions to customize how they work, and get back 
data that tells us the result that was calculated.

Believe it or not, function calls used to be really slow. Steve Johnson, the author of many early coding tools for the Unix operating system, said this:

“Dennis Ritchie (the creator of the C programming language) encouraged modularity by telling all and sundry that function calls were really, really cheap in 
C. Everybody started writing small functions and modularizing. Years later we found out that function calls were still expensive, and our code was often 
spending 50% of its time just calling them. Dennis had lied to us! But it was too late; we were all hooked...”

Why would they be “hooked” on function calls? Because they do so much to help simplify our code: rather than copying and pasting the same 10 lines of code 
in a dozen places, we can instead wrap them up in a function and use that instead. That means less code duplication, but also means if you change that 
function – perhaps adding more work – then everywhere using it will automatically get the new behavior, and there’s no risk of you forgetting to update 
one of the places you pasted it into.



How to reuse code with functions
When you’ve written some code you really like, and want to use again and again, you should consider putting it into a function. Functions are just chunks 
of code you’ve split off from the rest of your program, and given a name so you can refer to them easily.

For example, let’s say we had this nice and simple code:

print("Welcome to my app!")
print("By default This prints out a conversion")
print("chart from centimeters to inches, but you")
print("can also set a custom range if you want.")

That’s a welcome message for an app, and you might want it to be printed when the app launches, or perhaps when the user asks for help.

But what if you wanted it to be in both places? Yes, you could just copy those four print() lines and put them in both places, but what if you wanted that 
text in ten places? Or what if you wanted to change the wording later on – would you really remember to change it everywhere it appeared in your code?

This is where functions come in: we can pull out that code, give it a name, and run it whenever and wherever we need. This means all the print() lines stay 
in one place, and get reused elsewhere.

Here’s how that looks:

func showWelcome() {
    print("Welcome to my app!")
    print("By default This prints out a conversion")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}
Let’s break that down…

It starts with the func keyword, which marks the start of a function.
We’re naming the function showWelcome. This can be any name you want, but try to make it memorable – printInstructions(), displayHelp(), etc are all good 
choices.
The body of the function is contained within the open and close braces, just like the body of loops and the body of conditions.
There’s one extra thing in there, and you might recognize it from our work so far: the () directly after showWelcome. We first met these way back when we 
looked at strings, when I said that count doesn’t have () after it, but uppercased() does.

Well, now you’re learning why: those () are used with functions. They are used when you create the function, as you can see above, but also when you call 
the function – when you ask Swift to run its code. In our case, we can call our function like this:

showWelcome()
That’s known as the function’s call site, which is a fancy name meaning “a place where a function is called.”

So what do the parentheses actually do? Well, that’s where we add configuration options for our functions – we get to pass in data that customizes the way 
the function works, so the function becomes more flexible.

As an example, we already used code like this:

let number = 139

if number.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}
isMultiple(of:) is a function that belongs to integers. If it didn’t allow any kind of customization, it just wouldn’t make sense – is it a multiple of 
what? Sure, Apple could have made this be something like isOdd() or isEven() so it never needed to have configuration options, but by being able to write 
(of: 2) suddenly the function becomes more powerful, because now we can check for multiples of 2, 3, 4, 5, 50, or any other number.

Similarly, when we were rolling virtual dice earlier we used code like this:

let roll = Int.random(in: 1...20)
Again, random() is a function, and the (in: 1...20) part marks configuration options – without that we’d have no control over the range of our random 
numbers, which would be significantly less useful.

We can make our own functions that are open to configuration, all by putting extra code in between the parentheses when we create our function. This should 
be given a single integer, such as 8, and calculate the multiplication tables for that from 1 through 12.

Here’s that in code:

func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(number: 5)
Notice how I’ve placed number: Int inside the parentheses? That’s called a parameter, and it’s our customization point. We’re saying whoever calls this 
function must pass in an integer here, and Swift will enforce it. Inside the function, number is available to use like any other constant, so it appears 
inside the print() call.

As you can see, when printTimesTables() is called, we need to explicitly write number: 5 – we need to write the parameter name as part of the function call. 
This isn’t common in other languages, but I think it’s really helpful in Swift as a reminder of what each parameter does.

This naming of parameters becomes even more important when you have multiple parameters. For example, if we wanted to customize how high our multiplication
tables went we might make the end of our range be set using a second parameter, like this:

func printTimesTables(number: Int, end: Int) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(number: 5, end: 20)
Now that takes two parameters: an integer called number, and an end point called end. Both of those need to be named specifically when printTablesTable() 
is run, and I hope you can see now why they are important – imagine if our code was this instead:

printTimesTables(5, 20)
Can you remember which number was which? Maybe. But would you remember six months from now? Probably not.

Now, technically we give slightly different names to sending data and receiving data, and although many people (myself included) ignore this distinction, 
I’m going to at least make you aware of it so you aren’t caught off guard later.

Take a look at this code:

func printTimesTables(number: Int, end: Int) {
There both number and end are parameters: they are placeholder names that will get filled in with values when the function is called, so that we have a 
name for those values inside the function.

Now look at this code:

printTimesTables(number: 5, end: 20)
There the 5 and 20 are arguments: they are the actual values that get sent into the function to work with, used to fill number and end.

So, we have both parameters and arguments: one is a placeholder the other is an actual value, so if you ever forget which is which just remember 
Parameter/Placeholder, Argument/Actual Value.

Does this name distinction matter? Not really: I use “parameter” for both, and I’ve known other people to use “argument” for both, and honestly never once 
in my career has it caused even the slightest issue. In fact, as you’ll see shortly in Swift the distinction is extra confusing, so it’s just not worth 
thinking about.

Important: If you prefer to use “argument” for data being passed in and “parameter” for data being received, that’s down to you, but I really do use 
“parameter” for both, and will be doing so throughout this book and beyond.

Regardless of whether you’re calling them “arguments” or “parameters”, when you ask Swift to call the function you must always pass the parameters in 
the order they were listed when you created the function.

So, for this code:

func printTimesTables(number: Int, end: Int) {
This is not valid code, because it puts end before number:

printTimesTables(end: 20, number: 5)
Tip: Any data you create inside a function is automatically destroyed when the function is finished.



How to return values from functions
You’ve seen how to create functions and how to add parameters to them, but functions often also send data back – they perform some computation, then return 
the result of that work back to the call site.

Swift has lots of these functions built in, and there are tens of thousands more in Apple’s frameworks. For example, our playground has always had import 
Cocoa at the very top, and that includes a variety of mathematical functions such as sqrt() for calculating the square root of a number.

The sqrt() function accepts one parameter, which is the number we want to calculate the square root of, and it will go ahead and do the work then send 
back the square root.

For example, we could write this:

let root = sqrt(169)
print(root)
If you want to return your own value from a function, you need to do two things:

Write an arrow then a data type before your function’s opening brace, which tells Swift what kind of data will get sent back.
Use the return keyword to send back your data.
For example, perhaps you want to roll a dice in various parts of your program, but rather than always forcing the dice roll to use a 6-sided dice you could 
instead make it a function:

func rollDice() -> Int {
    return Int.random(in: 1...6)
}

let result = rollDice()
print(result)
So, that says the function must return an integer, and the actual value is sent back with the return keyword.

Using this approach you can call rollDice() in lots of places across your program, and they will all use a 6-sided dice. But if in the future you decide 
you want to use a 20-sided dice, you just need to change that one function to have the rest of your program updated.

Important: When you say your function will return an Int, Swift will make sure it always returns an Int – you can’t forget to send back a value, because 
your code won’t build.

Let’s try a more complex example: do two strings contain the same letters, regardless of their order? This function should accept two string parameters, 
and return true if their letters are the same – so, “abc” and “cab” should return true because they both contain one “a”, one “b”, and one “c”.

You actually know enough to solve this problem yourself already, but you’ve learned so much already you’ve probably forgotten the one thing that makes 
this task so easy: if you call sorted() on any string, you get a new string back with all the letters in alphabetical order. So, if you do that for both 
strings, you can use == to compare them to see if their letters are the same.

Go ahead and try writing the function yourself. Again, don’t worry if you struggle – it’s all very new to you, and fighting to remember new knowledge is 
part of the learning process. I’ll show you the solution in a moment, but please do try it yourself first.

Still here? Okay, here’s one example solution:

func areLettersIdentical(string1: String, string2: String) -> Bool {
    let first = string1.sorted()
    let second = string2.sorted()
    return first == second
}
Let’s break that down:

It creates a new function called areLettersIdentical().
The function accepts two string parameters, string1 and string2.
The function says it returns a Bool, so at some point we must always return either true or false.
Inside the function body, we sort both strings then use == to compare the strings – if they are the same it will return true, otherwise it will return false.
That code sorts both string1 and string2, assigning their sorted values to new constants, first and second. However, that isn’t needed – we can skip those 
temporary constants and just compare the results of sorted() directly, like this:

func areLettersIdentical(string1: String, string2: String) -> Bool {
    return string1.sorted() == string2.sorted()
}
That’s less code, but we can do even better. You see, we’ve told Swift that this function must return a Boolean, and because there’s only one line of code 
in the function Swift knows that’s the one that must return data. Because of this, when a function has only one line of code, we can remove the return 
keyword entirely, like this:

func areLettersIdentical(string1: String, string2: String) -> Bool {
    string1.sorted() == string2.sorted()
}
We can go back and do the same for the rollDice() function too:

func rollDice() -> Int {
    Int.random(in: 1...6)
}
Remember, this only works when your function contains a single line of code, and in particular that line of code must actually return the data you promised 
to return.

Let’s try a third example. Do you remember the Pythagorean theorem from school? It states that if you have a triangle with one right angle inside, you can
calculate the length of the hypotenuse by squaring both its other sides, adding them together, then calculating the square root of the result

You already learned how to use sqrt(), so we can build a pythagoras() function that accepts two decimal numbers and returns another one:

func pythagoras(a: Double, b: Double) -> Double {
    let input = a * a + b * b
    let root = sqrt(input)
    return root
}

let c = pythagoras(a: 3, b: 4)
print(c)
So, that’s a function called pythagoras(), that accepts two Double parameters and returns another Double. Inside it squares a and b, adds them together, 
then passes that into sqrt() and sends back the result.

That function can also be boiled down to a single line, and have its return keyword removed – give it a try. As usual I’ll show you my solution afterwards, 
but it’s important you try.

Still here? Okay, here’s my solution:

func pythagoras(a: Double, b: Double) -> Double {
    sqrt(a * a + b * b)
}
There’s one last thing I want to mention before we move on: if your function doesn’t return a value, you can still use return by itself to force the 
function to exit early. For example, perhaps you have a check that the input matches what you expected, and if it doesn’t you want to exit the function 
immediately before continuing.



How to return multiple values from functions
When you want to return a single value from a function, you write an arrow and a data type before your function’s opening brace, like this:

func isUppercase(string: String) -> Bool {
    string == string.uppercased()
}
That compares a string against the uppercased version of itself. If the string was already fully uppercased then nothing will have changed and the two 
strings will be identical, otherwise they will be different and == will send back false.

If you want to return two or more values from a function, you could use an array. For example, here’s one that sends back a user’s details:

func getUser() -> [String] {
    ["Taylor", "Swift"]
}

let user = getUser()
print("Name: \(user[0]) \(user[1])") 
That’s problematic, because it’s hard to remember what user[0] and user[1] are, and if we ever adjust the data in that array then user[0] and user[1] 
could end up being something else or perhaps not existing at all.

We could use a dictionary instead, but that has its own problems:

func getUser() -> [String: String] {
    [
        "firstName": "Taylor",
        "lastName": "Swift"
    ]
}

let user = getUser()
print("Name: \(user["firstName", default: "Anonymous"]) \(user["lastName", default: "Anonymous"])") 
Yes, we’ve now given meaningful names to the various parts of our user data, but look at that call to print() – even though we know both firstName and 
lastName will exist, we still need to provide default values just in case things aren’t what we expect.

Both of these solutions are pretty bad, but Swift has a solution in the form of tuples. Like arrays, dictionaries, and sets, tuples let us put multiple 
pieces of data into a single variable, but unlike those other options tuples have a fixed size and can have a variety of data types.

Here’s how our function looks when it returns a tuple:

func getUser() -> (firstName: String, lastName: String) {
    (firstName: "Taylor", lastName: "Swift")
}

let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")
Let’s break that down…

Our return type is now (firstName: String, lastName: String), which is a tuple containing two strings.
Each string in our tuple has a name. These aren’t in quotes: they are specific names for each item in our tuple, as opposed to the kinds of arbitrary keys 
we had in dictionaries.
Inside the function we send back a tuple containing all the elements we promised, attached to the names: firstName is being set to “Taylor”, etc.
When we call getUser(), we can read the tuple’s values using the key names: firstName, lastName, etc.
I know tuples seem awfully similar to dictionaries, but they are different:

When you access values in a dictionary, Swift can’t know ahead of time whether they are present or not. Yes, we knew that user["firstName"] was going to 
be there, but Swift can’t be sure and so we need to provide a default value.
When you access values in a tuple, Swift does know ahead of time that it is available because the tuple says it will be available.
We access values using user.firstName: it’s not a string, so there’s also no chance of typos.
Our dictionary might contain hundreds of other values alongside "firstName", but our tuple can’t – we must list all the values it will contain, and as a 
result it’s guaranteed to contain them all and nothing else.
So, tuples have a key advantage over dictionaries: we specify exactly which values will exist and what types they have, whereas dictionaries may or may 
not contain the values we’re asking for.

There are three other things it’s important to know when using tuples.

First, if you’re returning a tuple from a function, Swift already knows the names you’re giving each item in the tuple, so you don’t need to repeat them 
when using return. So, this code does the same thing as our previous tuple:

func getUser() -> (firstName: String, lastName: String) {
    ("Taylor", "Swift")
}
Second, sometimes you’ll find you’re given tuples where the elements don’t have names. When this happens you can access the tuple’s elements using 
numerical indices starting from 0, like this:

func getUser() -> (String, String) {
    ("Taylor", "Swift")
}

let user = getUser()
print("Name: \(user.0) \(user.1)")
These numerical indices are also available with tuples that have named elements, but I’ve always found using names preferable.

Finally, if a function returns a tuple you can actually pull the tuple apart into individual values if you want to.

To understand what I mean by that, first take a look at this code:

func getUser() -> (firstName: String, lastName: String) {
    (firstName: "Taylor", lastName: "Swift")
}

let user = getUser()
let firstName = user.firstName
let lastName = user.lastName

print("Name: \(firstName) \(lastName)")
That goes back to the named version of getUser(), and when the tuple comes out we’re copying the elements from there into individual contents before 
using them. There’s nothing new here; we’re just moving data around a bit.

However, rather than assigning the tuple to user, then copying individual values out of there, we can skip the first step – we can pull apart the return 
value from getUser() into two separate constants, like this:

let (firstName, lastName) = getUser()
print("Name: \(firstName) \(lastName)")
That syntax might hurt your head at first, but it’s really just shorthand for what we had before: convert the tuple of two elements that we get back from 
getUser() into two separate constants.

In fact, if you don’t need all the values from the tuple you can go a step further by using _ to tell Swift to ignore that part of the tuple:

let (firstName, _) = getUser()
print("Name: \(firstName)")



How to customize parameter labels
You’ve seen how Swift developers like to name their function parameters, because it makes it easier to remember what they do when the function is called. 
For example, we could write a function to roll a dice a certain number of times, using parameters to control the number of sides on the dice and the number 
of rolls:

func rollDice(sides: Int, count: Int) -> [Int] {
    // Start with an empty array
    var rolls = [Int]()

    // Roll as many dice as needed
    for _ in 1...count {
        // Add each result to our array
        let roll = Int.random(in: 1...sides)
        rolls.append(roll)
    }

    // Send back all the rolls
    return rolls
}

let rolls = rollDice(sides: 6, count: 4)
Even if you came back to this code six months later, I feel confident that rollDice(sides: 6, count: 4) is pretty self-explanatory.

This method of naming parameters for external use is so important to Swift that it actually uses the names when it comes to figuring out which method to 
call. This is quite unlike many other languages, but this is perfect valid in Swift:

func hireEmployee(name: String) { }
func hireEmployee(title: String) { }
func hireEmployee(location: String) { }
Yes, those are all functions called hireEmployee(), but when you call them Swift knows which one you mean based on the parameter names you provide. 
To distinguish between the various options, it’s very common to see documentation refer to each function including its parameters, like this: 
hireEmployee(name:) or hireEmployee(title:).

Sometimes, though, these parameter names are less helpful, and there are two ways I want to look at.

First, think about the hasPrefix() function you learned earlier:

let lyric = "I see a red door and I want it painted black"
print(lyric.hasPrefix("I see"))
When we call hasPrefix() we pass in the prefix to check for directly – we don’t say hasPrefix(string:) or, worse, hasPrefix(prefix:). How come?

Well, when we’re defining the parameters for a function we can actually add two names: one for use where the function is called, and one for use inside 
the function itself. hasPrefix() uses this to specify _ as the external name for its parameter, which is Swift’s way of saying “ignore this” and causes 
there to be no external label for that parameter.

We can use the same technique in our own functions, if you think it reads better. For example, previously we had this function:

func isUppercase(string: String) -> Bool {
    string == string.uppercased()
}

let string = "HELLO, WORLD"
let result = isUppercase(string: string)
You might look at that and think it’s exactly right, but you might also look at string: string and see annoying duplication. After all, what else are we 
going to pass in there other than a string?

If we add an underscore before the parameter name, we can remove the external parameter label like so:

func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}

let string = "HELLO, WORLD"
let result = isUppercase(string)
This is used a lot in Swift, such as with append() to add items to an array, or contains() to check whether an item is inside an array – in both places 
it’s pretty evident what the parameter is without having a label too.

The second problem with external parameter names is when they aren’t quite right – you want to have them, so _ isn’t a good idea, but they just don’t read 
naturally at the function’s call site.

As an example, here’s another function we looked at earlier:

func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(number: 5)
That code is valid Swift, and we could leave it alone as it is. But the call site doesn’t read well: printTimesTables(number: 5). It would be much better 
like this:

func printTimesTables(for: Int) {
    for i in 1...12 {
        print("\(i) x \(for) is \(i * for)")
    }
}

printTimesTables(for: 5)
That reads much better at the call site – you can literally say “print times table for 5” aloud, and it makes sense. But now we have invalid Swift: 
although for is allowed and reads great at the call site, it’s not allowed inside the function.

You already saw how we can put _ before the parameter name so that we don’t need to write an external parameter name. Well, the other option is to write 
a second name there: one to use externally, and one to use internally.

Here’s how that looks:

func printTimesTables(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5)
There are three things in there you need to look at closely:

We write for number: Int: the external name is for, the internal name is number, and it’s of type Int.
When we call the function we use the external name for the parameter: printTimesTables(for: 5).
Inside the function we use the internal name for the parameter: print("\(i) x \(number) is \(i * number)").
So, Swift gives us two important ways to control parameter names: we can use _ for the external parameter name so that it doesn’t get used, or add a 
second name there so that we have both external and internal parameter names.

Tip: Earlier I mentioned that technically values you pass in to a function are called “arguments”, and values you receive inside the function are called 
parameters. This is where things get a bit muddled, because now we have argument labels and parameter names side by side, both in the function definition. 
Like I said, I’ll be using the term “parameter” for both, and when the distinction matters you’ll see I distinguish between them using “external parameter 
name” and “internal parameter name”.