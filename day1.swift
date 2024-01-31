First steps in Swift
SwiftUI is a powerful framework for building user-interactive apps for iOS, macOS, tvOS, and even watchOS. But you can’t build software without having a 
programming language, so behind SwiftUI lies Swift itself: a powerful, flexible, and modern programming language that you’ll use for all your SwiftUI apps.

As Mark Twain once said, “the secret to getting ahead is getting started.” Well, you’re starting now, so we’re going to dive in and learn about variables, 
constants, and simple data types in Swift.

Today you have seven tutorials to complete. If you want to dive deeper into each topic there is optional further reading, but you don’t need to read that 
unless you want to and have the time. Regardless, there are a number of short tests to help make sure you’ve understood key concepts.

I know, I know: the temptation is strong to continue on to watch more videos and take more tests beyond those linked below, but remember: don’t rush ahead! 
It’s much better to do one hour a day every day than do chunks with large gaps between.



Why Swift?
There are lots of programming languages out there, but I think you’re going to really enjoy learning Swift. This is partly for practical reasons – you can 
make a lot of money on the App Store! – but there are lots of technical reasons too.

You see, Swift is a relatively young language, having launched only in 2014. This means it doesn’t have a lot of the language cruft that old languages can 
suffer from, and usually means there is only one way to solve a particular problem.

At the same time, being such a new programming language means that Swift leverages all sorts of new ideas built upon the successes – and sometimes mistakes 
– of older languages. For example, it makes it hard to accidentally write unsafe code, it makes it very easy to write code that is clear and understandable, 
and it supports all the world languages so you’ll never see those strange character errors that plague other languages.

Swift itself is just the language, and isn’t designed to draw anything on the screen. When it comes to building software with Swift, you’ll be using SwiftUI: 
Apple’s powerful framework that creates text, buttons, images, user interaction, and much more. As the name suggests, SwiftUI was built for Swift – it’s l
iterally designed to leverage the power and safety offered by the language, which makes it remarkably quick to build really powerful apps.

So, you should learn Swift because you can make a lot of money with it, but also because it does so many things really well. No cruft, no confusion, just 
lots of power at your fingertips. What’s not to like?



About this course
I’ve been teaching folks to write Swift since 2014, the same year Swift launched, and at this point Hacking with Swift is the world’s largest site 
dedicated to teaching Swift.

Along the way I learned a huge amount about what topics matter the most, how to structure topics into a smooth and consistent flow, and most importantly 
how to help learners remember topics they’ve learned. This course is the product of all that learning.

Unlike my previous work this does not strive to teach you every aspect of Swift, but instead it spends more time on the subset of features that matter the 
most – the ones you’ll use in every app you build, time and time again. Yes, there are some advanced language features covered, but I’ve cherrypicked them 
based on usefulness. When you’ve finished the book you might want to carry on learning some of the more advanced features, but I suspect you’d much rather 
get busy learning how to use SwiftUI.

Each chapter of this book is available as both text and video, but they cover exactly the same material so you’re welcome to learn whichever way suits 
you best. If you’re using the videos you’ll notice that I sometimes introduce topics using slides and sometimes demonstrate them in Xcode. It might feel 
repetitive, but it’s intentional – there’s a lot of things to learn, and if you saw each one only once it just wouldn’t stay in your memory!

There’s one last thing: you might notice how many chapters start with “How to…”, and that’s intentional – this book is here to show you how to do things 
in a hands-on way, as opposed to delving into theory. Theory is important, and you’ll come across a lot of it as you can continue to learn, but here the 
focus is relentlessly practical because I believe the best way to learn something new is to try it yourself.

Programming is an art: don't spend all your time sharpening your pencil when you should be drawing.



How to follow along
There’s a lot of code shown off in this book, and I really want to encourage you to try it all yourself – type the code into your computer, run it and see 
the output, then experiment a little to make sure you understand it.

To run the code in this book you should have installed Xcode 15.0 or later from the Mac App Store. It’s free, and includes everything you need to follow 
along.

We’ll be using a Swift Playground for all the code in this book. You can create one by launching Xcode, then going to the File menu and choosing New > 
Playground. When you’re asked what kind of playground to create, choose Blank from the macOS tab, then save it somewhere you can get to easily.

Playgrounds are like little sandboxes where you can try out Swift code easily, seeing the result of your work side by side with the code. You can use one 
playground for all the work you’ll be doing, or create new a playground for each chapter – do whatever works best for you.

Tip: The first time you run code in a playground it might take a few seconds to start, but subsequent runs will be fast.



How to create variables and constants
Whenever you build programs, you’re going to want to store some data. Maybe it’s the user’s name they just typed in, maybe it’s some news stories you 
downloaded from the internet, or maybe it’s the result of a complex calculation you just performed.

Swift gives us two ways of storing data, depending on whether you want the data to change over time. The first option is automatically used when you create 
a new playground, because it will contain this line:

var greeting = "Hello, playground"

That creates a new variable called greeting, and because it’s a variable its value can vary – it can change as our program runs.

Tip: The other line in a macOS playground is import Cocoa, which brings in a huge collection of code provided by Apple to make app building easier. 
This includes lots of important functionality, so please don’t delete it.

There are really four pieces of syntax in there:

The var keyword means “create a new variable”; it saves a little typing.

We’re calling our variable greeting. You can call your variable anything you want, but most of the time you’ll want to make it descriptive.
The equals sign assigns a value to our variable. You don’t need to have those spaces on either side of the equals sign if you don’t want to, but it’s the 
most common style.
The value we’re assigning is the text “Hello, playground”. Notice that text is written inside double quotes, so that Swift can see where the text starts 
and where it ends.
If you’ve used other languages, you might have noticed that our code doesn’t need a semicolon at the end of the line. Swift does allow semicolons, but 
they are very rare – you’ll only ever need them if you want to write two pieces of code on the same line for some reason.

When you make a variable, you can change it over time:

var name = "Ted"
name = "Rebecca"
name = "Keeley"

That creates a new variable called name, and gives it the value “Ted”. It then gets changed twice, first to “Rebecca” and then to “Keeley” – we don’t 
use var again because we are modifying an existing variable rather than creating a new one. You can change variables as much as you need to, and the 
old value is discarded each time.

(You’re welcome to put different text in your variables, but I’m a big fan of the TV show Ted Lasso so I went with Ted. And yes, you can expect other 
Ted Lasso references and more in the following chapters.)

If you don’t ever want to change a value, you need to use a constant instead. Creating a constant works almost identically to creating a variable, 
except we use let rather than var, like this:

let character = "Daphne"

Now, when we use let we make a constant, which is a value that can’t change. Swift literally won’t let us, and will show a big error if we try.

Don’t believe me? Try putting this into Xcode:

let character = "Daphne"
character = "Eloise"
character = "Francesca"

Again, there are no let keywords in those second and third lines because we aren’t creating new constants, we’re just trying to change the one we already 
have. However, like I said that won’t work – you can’t change a constant, otherwise it wouldn’t be constant!

If you were curious, “let” comes from the mathematics world, where they say things like “let x be equal to 5.”

Important: Please delete the two lines of code that are showing errors – you really can’t change constants!

When you’re learning Swift, you can ask Xcode to print out the value of any variable. You won’t use this much in real apps because users can’t see 
what’s printed, but it’s really helpful as a simple way of seeing what’s inside your data.

For example, we could print out the value of a variable each time it’s set – try entering this into your playground:

var playerName = "Roy"
print(playerName)

playerName = "Dani"
print(playerName)

playerName = "Sam"
print(playerName)

Tip: You can run code in your Xcode playground by clicking the blue play icon to the left of it. If you move up or down along that blue strip, you’ll 
see the play icon moves too – this lets you run the code up to a certain point if you want, but most of the time here you’ll want to run up to the last line.

You might have noticed that I named my variable playerName, and not playername, player_name, or some other alternative. This is a choice: Swift doesn’t 
really care what you name your constants and variables, as long as you refer to them the same way everywhere. So, I can’t use playerName first then 
playername later – Swift sees those two as being different names.

Although Swift doesn’t care how we name our data, the naming style I’m using is the standard among Swift developers – what we call a convention. 
If you’re curious, the style is called “camel case”, because the second and subsequent words in a name start with a little bump for the capital letter:

let managerName = "Michael Scott"
let dogBreed = "Samoyed"
let meaningOfLife = "How many roads must a man walk down?"

If you can, prefer to use constants rather than variables – not only does it give Swift the chance to optimize your code a little better, but it also 
allows Swift to make sure you never change a constant’s value by accident.



How to create strings
When you assign text to a constant or variable, we call that a string – think of a bunch of Scrabble tiles threaded onto a string to make a word.

Swift’s strings start and end with double quotes, but what you put inside those quotes is down to you. You can use short pieces of alphabetic text, like this:

let actor = "Denzel Washington"

You can use punctuation, emoji and other characters, like this:

let filename = "paris.jpg"
let result = "⭐️ You win! ⭐️"

And you can even use other double quotes inside your string, as long as you’re careful to put a backslash before them so that Swift understands they are 
inside the string rather than ending the string:

let quote = "Then he tapped a sign saying \"Believe\" and walked away."

Don’t worry – if you miss off the backslash, Swift will be sure to shout loudly that your code isn’t quite right.

There is no realistic limit to the length of your strings, meaning that you could use a string to store something very long such as the complete works 
of Shakespeare. However, what you’ll find is that Swift doesn’t like line breaks in its strings. So, this kind of code isn’t allowed:

let movie = "A day in
the life of an
Apple engineer"

That doesn’t mean you can’t create strings across multiple lines, just that Swift needs you to treat them specially: rather than one set of quotes on 
either side of your string, you use three, like this:

let movie = """
A day in
the life of an
Apple engineer
"""

These multi-line strings aren’t used terribly often, but at least you can see how it’s done: the triple quotes at the start and end are on their own 
line, with your string in between.

Once you’ve created your string, you’ll find that Swift gives us some useful functionality to work with its contents. You’ll learn more about this 
functionality over time, but I want to introduce you to three things here.

First, you can read the length of a string by writing .count after the name of the variable or constant:

print(actor.count)

Because actor has the text “Denzel Washington”, that will print 17 – one for each letter in the name, plus the space in the middle.

You don’t need to print the length of a string directly if you don’t want to – you can assign it to another constant, like this:

let nameLength = actor.count
print(nameLength)

The second useful piece of functionality is uppercased(), which sends back the same string except every one of its letter is uppercased:

print(result.uppercased())

Yes, the open and close parentheses are needed here but aren’t needed with count. The reason for this will become clearer as you learn, but at this 
early stage in your Swift learning the distinction is best explained like this: if you’re asking Swift to read some data you don’t need the parentheses, 
but if you’re asking Swift to do some work you do. That’s not wholly true as you’ll learn later, but it’s enough to get you moving forward for now.

The last piece of helpful string functionality is called hasPrefix(), and lets us know whether a string starts with some letters of our choosing:

print(movie.hasPrefix("A day"))

There’s also a hasSuffix() counterpart, which checks whether a string ends with some text:

print(filename.hasSuffix(".jpg"))

Important: Strings are case-sensitive in Swift, which means using filename.hasSuffix(".JPG") will return false because the letters in the string are 
lowercase.

Strings are really powerful in Swift, and we’ve only really scratched the surface of what they can do!



How to store whole numbers
When you’re working with whole numbers such as 3, 5, 50, or 5 million, you’re working with what Swift calls integers, or Int for short – “integer” is 
originally a Latin word meaning “whole”, if you were curious.

Making a new integer works just like making a string: use let or var depending on whether you want a constant or variable, provide a name, then give it a 
value. For example, we could create a score constant like this:

let score = 10
Integers can be really big – past billions, past trillions, past quadrillions, and well into quintillions, but they they can be really small too – they 
can hold negative numbers up to quintillions.

When you’re writing out numbers by hand, it can be hard to see quite what’s going on. For example, what number is this?

let reallyBig = 100000000

If we were writing that out by hand we’d probably write “100,000,000” at which point it’s clear that the number is 100 million. Swift has something 
similar: you can use underscores, _, to break up numbers however you want.

So, we could change our previous code to this:

let reallyBig = 100_000_000

Swift doesn’t actually care about the underscores, so if you wanted you could write this instead:

let reallyBig = 1_00__00___00____00

The end result is the same: reallyBig gets set to an integer with the value of 100,000,000.

Of course, you can also create integers from other integers, using the kinds of arithmetic operators that you learned at school: + for addition, - for 
subtraction, * for multiplication, and / for division.

For example:

let lowerScore = score - 2
let higherScore = score + 10
let doubledScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2
print(score)

Rather than making new constants each time, Swift has some special operations that adjust an integer somehow and assigns the result back to the original 
number.

For example, this creates a counter variable equal to 10, then adds 5 more to it:

var counter = 10
counter = counter + 5

Rather than writing counter = counter + 5, you can use the shorthand operator +=, which adds a number directly to the integer in question:

counter += 5
print(counter)

That does exactly the same thing, just with less typing. We call these compound assignment operators, and they come in other forms:

counter *= 2
print(counter)
counter -= 10
print(counter)
counter /= 2
print(counter)

Before we’re done with integers, I want to mention one last thing: like strings, integers have some useful functionality attached. For example, 
you can call isMultiple(of:) on an integer to find out whether it’s a multiple of another integer.

So, we could ask whether 120 is a multiple of three like this:

let number = 120
print(number.isMultiple(of: 3))

I’m calling isMultiple(of:) on a constant there, but you can just use the number directly if you want:

print(120.isMultiple(of: 3))



How to store decimal numbers
When you’re working with decimal numbers such as 3.1, 5.56, or 3.141592654, you’re working with what Swift calls floating-point numbers. The name comes 
from the surprisingly complex way the numbers are stored by your computer: it tries to store very large numbers such as 123,456,789 in the same amount 
of space as very small numbers such as 0.0000000001, and the only way it can do that is by moving the decimal point around based on the size of the number.

This storage method causes decimal numbers to be notoriously problematic for programmers, and you can get a taste of this with just two lines of Swift code:

let number = 0.1 + 0.2
print(number)

When that runs it won’t print 0.3. Instead, it will print 0.30000000000000004 – that 0.3, then 15 zeroes, then a 4 because… well, like I said, it’s complex.

I’ll explain more why it’s complex in a moment, but first let’s focus on what matters.

First, when you create a floating-point number, Swift considers it to be a Double. That’s short for “double-precision floating-point number”, which I 
realize is quite a strange name – the way we’ve handled floating-point numbers has changed a lot over the years, and although Swift does a good job of 
simplifying this you might sometimes meet some older code that is more complex. In this case, it means Swift allocates twice the amount of storage as 
some older languages would do, meaning a Double can store absolutely massive numbers.

Second, Swift considers decimals to be a wholly different type of data to integers, which means you can’t mix them together. After all, integers are 
always 100% accurate, whereas decimals are not, so Swift won’t let you put the two of them together unless you specifically ask for it to happen.

In practice, this means you can’t do things like adding an integer to a decimal, so this kind of code will produce an error:

let a = 1
let b = 2.0
let c = a + b

Yes, we can see that b is really just the integer 2 masquerading as a decimal, but Swift still won’t allow that code to run. This is called type safety: 
Swift won’t let us mix different types of data by accident.

If you want that to happen you need to tell Swift explicitly that it should either treat the Double inside b as an Int:

let c = a + Int(b)

Or treat the Int inside a as a Double:

let c = Double(a) + b

Third, Swift decides whether you wanted to create a Double or an Int based on the number you provide – if there’s a dot in there, you have a Double, 
otherwise it’s an Int. Yes, even if the numbers after the dot are 0.

So:

let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3

Combined with type safety, this means that once Swift has decided what data type a constant or variable holds, it must always hold that same data type. 
That means this code is fine:

var name = "Nicolas Cage"
name = "John Travolta"

But this kind of code is not:

var name = "Nicolas Cage"
name = 57

That tells Swift name will store a string, but then it tries to put an integer in there instead.

Finally, decimal numbers have the same range of operators and compound assignment operators as integers:

var rating = 5.0
rating *= 2

Many older APIs use a slightly different way of storing decimal numbers, called CGFloat. Fortunately, Swift lets us use regular Double numbers everywhere a 
CGFloat is expected, so although you will see CGFloat appear from time to time you can just ignore it.

In case you were curious, the reason floating-point numbers are complex is because computers are trying to use binary to store complicated numbers. 
For example, if you divide 1 by 3 we know you get 1/3, but that can’t be stored in binary so the system is designed to create very close approximations. 
It’s extremely efficient, and the error is so small it’s usually irrelevant, but at least you know why Swift doesn’t let us mix Int and Double by accident!