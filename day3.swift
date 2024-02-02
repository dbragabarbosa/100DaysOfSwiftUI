Complex data types, part 1

Today we’re going to look at some more complex data types that group data together. Understanding the differences between them, and especially knowing 
which to use and when, can sometimes trip folks up when they are learning – as Joseph Campbell once said, “computers are like Old Testament gods: lots 
of rules and no mercy.”

Don’t worry, though: you’ll find that the three types we’re learning today cover the overwhelming majority of requirements you’ll need for grouping data, 
and if you choose the wrong one when you’re learning then nothing bad is going to happen.

In fact, a common mistake folks make while learning is they have a fear of running their code. Trust me on this: while you’re following all the code here, 
none of the code you write can somehow break your computer. So, make a change and run it. Make another change and run that. Just try changing your values 
until you feel comfortable with what’s happening – it all helps.

Today you have four tutorials to follow, and you’ll meet things like arrays, dictionaries, sets, and more. After watching each video you’re welcome to go 
through some optional extra reading if you want extra clarification on a topic, and there are some short tests to help make sure you’ve understood what 
was taught.



How to store ordered data in arrays
It’s extremely common to want to have lots of data in a single place, whether that’s the days of the week, a list of students in a class, a city’s 
population for the last 100 years, or any of countless other examples.

In Swift, we do this grouping using an array. Arrays are their own data type just like String, Int, and Double, but rather than hold just one string they 
can hold zero strings, one string, two strings, three, fifty, fifty million, or even more strings – they can automatically adapt to hold as many as you 
need, and always hold data in the order you add it.

Let’s start with some simple examples of creating arrays:

var beatles = ["John", "Paul", "George", "Ringo"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]

That creates three different arrays: one holding strings of people’s names, one holding integers of important numbers, and one holding decimals of 
temperatures in Celsius. Notice how we start and end arrays using square brackets, with commas between every item.

When it comes to reading values out from an array, we ask for values by the position they appear in the array. The position of an item in an array is 
ommonly called its index.

This confuses beginners a bit, but Swift actually counts an item’s index from zero rather than one – beatles[0] is the first element, and beatles[1] is 
the second, for example.

So, we could read some values out from our arrays like this:

print(beatles[0])
print(numbers[1])
print(temperatures[2])

Tip: Make sure an item exists at the index you’re asking for, otherwise your code will crash – your app will just stop working.

If your array is variable, you can modify it after creating it. For example, you can use append() to add new items:

beatles.append("Adrian")

And there’s nothing stopping you from adding items more than once:

beatles.append("Allen")
beatles.append("Adrian")
beatles.append("Novall")
beatles.append("Vivian")

However, Swift does watch the kind of data you’re trying to add, and will make sure your array only ever contains one type of data at a time. So, this 
kind of code isn’t allowed:

temperatures.append("Chris")
This also applies to reading data out of the array – Swift knows that the beatles array contains strings, so when you read one value out you’ll always
get a string. If you try to do the same with numbers, you’ll always get an integer. Swift won’t let you mix these two different types together, so this 
kind of code isn’t allowed:

let firstBeatle = beatles[0]
let firstNumber = numbers[0]
let notAllowed = firstBeatle + firstNumber

This is type safety, just like how Swift won’t let us mix integers and decimals, except it’s taken to a deeper level. Yes, all beatles and numbers are 
oth arrays, but they are specialized types of arrays: one is an array of strings, and one is an array of integers.

You can see this more clearly when you want to start with an empty array and add items to it one by one. This is done with very precise syntax:

var scores = Array<Int>()
scores.append(100)
scores.append(80)
scores.append(85)
print(scores[1])

We’ve covered the last four lines already, but that first line shows how we have a specialized array type – this isn’t just any array, it’s an array that 
holds integers. This is what allows Swift to know for sure that beatles[0] must always be a string, and also what stops us from adding integers to a string 
array.

The open and closing parentheses after Array<Int> are there because it’s possible to customize the way the array is created if you need to. For example, 
you might want to fill the array with lots of temporary data before adding the real stuff later on.

You can make other kinds of array by specializing it in different ways, like this:

var albums = Array<String>()
albums.append("Folklore")
albums.append("Fearless")
albums.append("Red")

Again, we’ve said that must always contain strings, so we can’t try to put an integer in there.

Arrays are so common in Swift that there’s a special way to create them: rather than writing Array<String>, you can instead write [String]. So, this kind 
of code is exactly the same as before:

var albums = [String]()
albums.append("Folklore")
albums.append("Fearless")
albums.append("Red")

Swift’s type safety means that it must always know what type of data an array is storing. That might mean being explicit by saying albums is an 
Array<String>, but if you provide some initial values Swift can figure it out for itself:

var albums = ["Folklore"]
albums.append("Fearless")
albums.append("Red")

Before we’re done, I want to mention some useful functionality that comes with arrays.

First, you can use .count to read how many items are in an array, just like you did with strings:

print(albums.count)

Second, you can remove items from an array by using either remove(at:) to remove one item at a specific index, or removeAll() to remove everything:

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)

characters.remove(at: 2)
print(characters.count)

characters.removeAll()
print(characters.count)

That will print 4, then 3, then 0 as characters are removed.

Third, you can check whether an array contains a particular item by using contains(), like this:

let bondMovies = ["Casino Royale", "Spectre", "No Time To Die"]
print(bondMovies.contains("Frozen"))

Fourth, you can sort an array using sorted(), like this:

let cities = ["London", "Tokyo", "Rome", "Budapest"]
print(cities.sorted())

That returns a new array with its items sorted in ascending order, which means alphabetically for strings but numerically for numbers – the original 
array remains unchanged.

Finally, you can reverse an array by calling reversed() on it:

let presidents = ["Bush", "Obama", "Trump", "Biden"]
let reversedPresidents = presidents.reversed()
print(reversedPresidents)

Tip: When you reverse an array, Swift is very clever – it doesn’t actually do the work of rearranging all the items, but instead just remembers to itself 
that you want the items to be reversed. So, when you print out reversedPresidents, don’t be surprised to see it’s not just a simple array any more!

Arrays are extremely common in Swift, and you’ll have lots of opportunity to learn more about them as you progress. Even better sorted(), reversed(), and 
lots of other array functionality also exists for strings – using sorted() there puts the string’s letters in alphabetical order, making something like 
“swift” into “fistw”.



How to store and find data in dictionaries
You’ve seen how arrays are a great way to store data that has a particular order, such as days of the week or temperatures for a city. Arrays are a 
great choice when items should be stored in the order you add them, or when you might have duplicate items in there, but very often accessing data by 
its position in the array can be annoying or even dangerous.

For example, here’s an array containing an employee’s details:

var employee = ["Taylor Swift", "Singer", "Nashville"]

I’ve told you that the data is about an employee, so you might be able to guess what various parts do:

print("Name: \(employee[0])")
print("Job title: \(employee[1])")
print("Location: \(employee[2])")

But that has a couple of problems. First, you can’t really be sure that employee[2] is their location – maybe that’s their password. Second, there’s no 
guarantee that item 2 is even there, particularly because we made the array a variable. This kind of code would cause serious problems:

print("Name: \(employee[0])")
employee.remove(at: 1)
print("Job title: \(employee[1])")
print("Location: \(employee[2])")    

That now prints Nashville as the job title, which is wrong, and will cause our code to crash when it reads employee[2], which is just bad.

Swift has a solution for both these problems, called dictionaries. Dictionaries don’t store items according to their position like arrays do, but instead 
let us decide where items should be stored.

For example, we could rewrite our previous example to be more explicit about what each item is:

let employee2 = ["name": "Taylor Swift", "job": "Singer", "location": "Nashville"]

If we split that up into individual lines you’ll get a better idea of what the code does:

let employee2 = [
    "name": "Taylor Swift",
    "job": "Singer", 
    "location": "Nashville"
]

As you can see, we’re now being really clear: the name is Taylor Swift, the job is Singer, and the location is Nashville. Swift calls the strings on 
the left – name, job, and location – the keys to the dictionary, and the strings on the right are the values.

When it comes to reading data out from the dictionary, you use the same keys you used when creating it:

print(employee2["name"])
print(employee2["job"])
print(employee2["location"])

If you try that in a playground, you’ll see Xcode throws up various warnings along the lines of “Expression implicitly coerced from 'String?' to 
'Any’”. Worse, if you look at the output from your playground you’ll see it prints Optional("Taylor Swift") rather than just Taylor Swift – what gives?

Well, think about this:

print(employee2["password"])
print(employee2["status"])
print(employee2["manager"])

All of that is valid Swift code, but we’re trying to read dictionary keys that don’t have a value attached to them. Sure, Swift could just crash here 
just like it will crash if you read an array index that doesn’t exist, but that would make it very hard to work with – at least if you have an array 
with 10 items you know it’s safe to read indices 0 through 9. (“Indices” is just the plural form of “index”, in case you weren’t sure.)

So, Swift provides an alternative: when you access data inside a dictionary, it will tell us “you might get a value back, but you might get back nothing 
at all.” Swift calls these optionals because the existence of data is optional - it might be there or it might not.

Swift will even warn you when you write the code, albeit in a rather obscure way – it will say “Expression implicitly coerced from 'String?' to 'Any’”, 
but it will really mean “this data might not actually be there – are you sure you want to print it?”

Optionals are a pretty complex issue that we’ll be covering in detail later on, but for now I’ll show you a simpler approach: when reading from a 
dictionary, you can provide a default value to use if the key doesn’t exist.

Here’s how that looks:

print(employee2["name", default: "Unknown"])
print(employee2["job", default: "Unknown"])
print(employee2["location", default: "Unknown"])

All the examples have used strings for both the keys and values, but you can use other data types for either of them. For example, we could track 
which students have graduated from school using strings for names and Booleans for their graduation status:

let hasGraduated = [
    "Eric": false,
    "Maeve": true,
    "Otis": false,
]

Or we could track years when Olympics took place along with their locations:

let olympics = [
    2012: "London",
    2016: "Rio de Janeiro",
    2021: "Tokyo"
]

print(olympics[2012, default: "Unknown"])

You can also create an empty dictionary using whatever explicit types you want to store, then set keys one by one:

var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["LeBron James"] = 206

Notice how we need to write [String: Int] now, to mean a dictionary with strings for its keys and integers for its values.

Because each dictionary item must exist at one specific key, dictionaries don’t allow duplicate keys to exist. Instead, if you set a value for a key 
that already exists, Swift will overwrite whatever was the previous value.

For example, if you were chatting with a friend about superheroes and supervillains, you might store them in a dictionary like this:

var archEnemies = [String: String]()
archEnemies["Batman"] = "The Joker"
archEnemies["Superman"] = "Lex Luthor"

If your friend disagrees that The Joker is Batman’s arch-enemy, you can just rewrite that value by using the same key:

archEnemies["Batman"] = "Penguin"

Finally, just like arrays and the other data types we’ve seen so far, dictionaries come with some useful functionality that you’ll want to use in the 
future – count and removeAll() both exists for dictionaries, and work just like they do for arrays.



How to use sets for fast data lookup
So far you’ve learned about two ways of collecting data in Swift: arrays and dictionaries. There is a third very common way to group data, called a set – 
they are similar to arrays, except you can’t add duplicate items, and they don’t store their items in a particular order.

Creating a set works much like creating an array: tell Swift what kind of data it will store, then go ahead and add things. There are two important 
differences, though, and they are best demonstrated using some code.

First, here’s how you would make a set of actor names:

let people = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson"])

Notice how that actually creates an array first, then puts that array into the set? That’s intentional, and it’s the standard way of creating a set from 
fixed data. Remember, the set will automatically remove any duplicate values, and it won’t remember the exact order that was used in the array.

If you’re curious how the set has ordered the data, just try printing it out:

print(people)

You might see the names in the original order, but you might also get a completely different order – the set just doesn’t care what order its items come in.

The second important difference when adding items to a set is visible when you add items individually. Here’s the code:

var people = Set<String>()
people.insert("Denzel Washington")
people.insert("Tom Cruise")
people.insert("Nicolas Cage")
people.insert("Samuel L Jackson")

Notice how we’re using insert()? When we had an array of strings, we added items by calling append(), but that name doesn’t make sense here – we aren’t 
adding an item to the end of the set, because the set will store the items in whatever order it wants.

Now, you might think sets just sound like simplified arrays – after all, if you can’t have duplicates and you lose the order of your items, why not just 
use arrays? Well, both of those restrictions actually get turned into an advantage.

First, not storing duplicates is sometimes exactly what you want. There’s a reason I chose actors in the previous example: the Screen Actors Guild 
requires that all its members have a unique stage name to avoid confusion, which means that duplicates must never be allowed. For example, the actor 
Michael Keaton (Spider-Man Homecoming, Toy Story 3, Batman, and more) is actually named Michael Douglas, but because there was already a Michael Douglas 
in the guild (Avengers, Falling Down, Romancing the Stone, and more), he had to have a unique name.

Second, instead of storing your items in the exact order you specify, sets instead store them in a highly optimized order that makes it very fast to 
locate items. And the difference isn’t small: if you have an array of 1000 movie names and use something like contains() to check whether it contains 
“The Dark Knight” Swift needs to go through every item until it finds one that matches – that might mean checking all 1000 movie names before returning 
alse, because The Dark Knight wasn’t in the array.

In comparison, calling contains() on a set runs so fast you’d struggle to measure it meaningfully. Heck, even if you had a million items in the set, or 
even 10 million items, it would still run instantly, whereas an array might take minutes or longer to do the same work.

Most of the time you’ll find yourself using arrays rather than sets, but sometimes – just sometimes – you’ll find that a set is exactly the right choice 
to solve a particular problem, and it will make otherwise slow code run in no time at all.

Tip: Alongside contains(), you’ll also find count to read the number of items in a set, and sorted() to return a sorted array containing the the set’s items.



How to create and use enums
An enum – short for enumeration – is a set of named values we can create and use in our code. They don’t have any special meaning to Swift, but they are 
more efficient and safer, so you’ll use them a lot in your code.

To demonstrate the problem, let’s say you wanted to write some code to let the user select a day of the week. You might start out like this:

var selected = "Monday"

Later on in your code you change it, like so:

selected = "Tuesday"

That might work well in very simple programs, but take a look at this code:

selected = "January"

Oops! You accidentally typed in a month rather than a day – what will your code do? Well, you might be lucky enough to have a colleague spot the error 
as they review your code, but how about this:

selected = "Friday "
That has a space at the end of Friday, and “Friday ” with a space is different from “Friday” without a space in Swift’s eyes. Again, what would your code do?

Using strings for this kind of thing takes some very careful programming, but it’s also pretty inefficient – do we really need to store all the letters 
of “Friday” to track one single day?

This is where enums come in: they let us define a new data type with a handful of specific values that it can have. Think of a Boolean, that can only 
have true or false – you can’t set it to “maybe” or “probably”, because that isn’t in the range of values it understands. Enums are the same: we get to 
list up front the range of values it can have, and Swift will make sure you never make a mistake using them.

So, we could rewrite our weekdays into a new enum like this:

enum Weekday {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

That calls the new enum Weekday, and provides five cases to handle the five weekdays.

Now rather than using strings, we would use the enum. Try this in your playground:

var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday

With that change you can’t accidentally use “Friday ” with an extra space in there, or put a month name instead – you must always choose one of the 
possible days listed in the enum. You’ll even see Swift offer up all possible options when you’ve typed Weekday., because it knows you’re going to 
select one of the cases.

Swift does two things that make enums a little easier to use. First, when you have many cases in an enum you can just write case once, then separate 
each case with a comma:

enum Weekday {
    case monday, tuesday, wednesday, thursday, friday
}

Second, remember that once you assign a value to a variable or constant, its data type becomes fixed – you can’t set a variable to a string at first, then 
an integer later on. Well, for enums this means you can skip the enum name after the first assignment, like this:

var day = Weekday.monday
day = .tuesday
day = .friday

Swift knows that .tuesday must refer to Weekday.tuesday because day must always be some kind of Weekday.

Although it isn’t visible here, one major benefit of enums is that Swift stores them in an optimized form – when we say Weekday.monday Swift is likely 
to store that using a single integer such as 0, which is much more efficient to store and check than the letters M, o, n, d, a, y.