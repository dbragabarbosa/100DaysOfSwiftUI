Milestone: Projects 7-9

Congratulations on making it through another three projects! You’re probably feeling tired after our navigation technique project, but both today and tomorrow should be a good change of pace – today is a consolidation day, and tomorrow is something a little bit different.

Today’s challenge is an interesting one, and honestly it has such a big potential to be developed into a larger app if you have the time. Days like today are important because they give you an idea that is wholly within your grasp, and give you the time and scope to execute on it. Hopefully you make the most of that – as the astronaut Mae Jemison once said, “I like to think of ideas as potential energy: they're really wonderful, but nothing will happen until we risk putting them into action.”

So, today is an action day: you’ve got lots of coding ahead, plus the potential for more if you want to take the project further. Let’s get into it!

Today you have three topics to work through, one of which of is your challenge.


What you learned
Hopefully you felt like these projects started to stretch you a little, not only in pushing your SwiftUI skills further but also teaching you some more advanced Swift. Plus, of course, you also have two new SwiftUI projects that you built – you can go ahead and keep customizing these all you want, put them on GitHub, or perhaps convert them into something else that better suits your tastes.

Here’s a quick recap of all the new things we covered in the last three projects:

Why @State works with structs.
How to use @Observable to store data in classes.
Presenting and dismissing views using the sheet() modifier and the dismiss environment key.
Using onDelete(perform:) to enable swipe to delete.
Adding EditButton to navigation bar items, to let users edit list data more easily.
Reading and writing data with UserDefaults.
Archiving and unarchiving data with Codable, including working with data stored in a hierarchy.
Using the Identifiable protocol to make sure all items can be identified uniquely in our user interface.
How to use containerRelativeFrame() to make content fit the screen.
Using ScrollView to lay out custom views in a scrollable area.
Using Swift’s generics system to write methods that work with different kinds of data.
Pushing new views onto the navigation stack using NavigationLink.
Navigating programmatically, including with the type-erased NavigationPath.
How to customize the navigation bar appearance.
Placing toolbar items in exact locations.

I hope you’ll agree that’s a lot, and it also spans a wide range – we’ve gone from hard-core language features through to user-facing views, with a huge spread in between. Some folks will prefer the pure language stuff and others will prefer the more creative side of coding, and that’s OK – we all learn differently!


Key points
Although we covered a lot in the previous three projects, there are three specific things I want to get into in more detail.

Classes vs structs: what’s the difference and why does it matter?
Swift gives us two ways to create our own complex data types, and it’s important you understand why we have them and which to choose for any given task.

The fundamental difference between a class and a struct is that one is a value type and the other is a reference type. These are standard programming terms for how we work with data: is the data just a simple value such as “Hello” or 5, or is it a merely a signpost saying “my data is stored in RAM at this location.”

Once you understand that difference, structs and classes become two very different things, but when you’re learning those differences can feel not very different at all. Think of it like this: when we make a variable that holds a struct, that data is literally stored inside the variable. In comparison, when we use a class, that data is put in memory somewhere and the variable holds a long number that identifies the location of that memory.

This is where the name comes from: “reference types” are stored as a reference to some memory somewhere, a bit like a signpost. Rather than a variable pointing directly to my house, it points to a signpost that points to my house – there’s an extra layer of indirection. This is why if you point two or more variables to the same instance of a class they can modify the same data: you just have several signposts all pointing to the same house.

This is also why reference types and value types behave differently when used as constants. If we make a constant instance of a class, what we’ve done is make a constant signpost – we’ve said “this signpost always points to house number 24601, and can’t point to a different house.” However, that doesn’t stop us from remodeling the house: maybe we want to add an extra floor, or change the kitchen, or perhaps even demolish the house entirely and build a new one. If you want those things to be fixed – if you want the actual house itself to be constant – then you need to use constant properties for your class.

So, we can make a constant signpost (let myHouse = House()) while having variable data (var numberOfFloors = 3). But we can also flip things around: we can make a variable signpost (var myHouse = House()) that has constant data (let numberOfFloors = 3), and that behaves very differently: we can move the signpost around so that it points to different houses, but we can’t remodel the houses themselves.

Now think about how all this relates to Swift, SwiftUI, and even UIKit. If you have three screens in an app, all of which share the same data, it’s important to make sure that data stays synchronized both behind the scenes (all the variables contain the same values), and to the user (all our lists / text views / etc show the same values).

SwiftUI provides wrappers such as @State to make sure our views stay updated as their data changes, however these were not available to use with UIKit – you needed to respond to changes yourself, then update the user interface to reflect those changes.

This created a problem:

View A could create an instance of a class.
View A could pass that to View B so they are sharing it.
View B could then change the data and update its UI.
View A would have no idea the data changed, and would show the old UI.
As a result of this, it was common for UIKit developers to use structs for data, because it meant that every view had its own copy of the data and it couldn’t change by surprise. Even more interestingly, all of UIKit’s view types were built using classes, which meant UIKit developers build their views as classes and use structs for their data – the complete opposite of SwiftUI.

Using UserDefaults wisely
UserDefaults lets us store small amounts of data easily – it’s automatically attached to our app, which means it’s there ready to load as soon as our app launches. While it’s very useful (and you’ll be relying on its heavily!) it does have two drawbacks:

You should only store small amounts of data there – anything over about 512KB is dubious.
You can only store certain types of data easily; everything else must use Codable first to get some binary data.
The list of types that are supported by UserDefaults is short and precise: strings, numbers, dates, URLs, and binary data, plus arrays and dictionaries of those types. Excluding URLs (which are really just fancy strings), all those are the same types that can be stored in a plist file – short for a property list.

This isn’t a coincidence: UserDefaults actually writes out its data using a property list just like our Info.plist file. In fact, keeping this link in mind can really help you make the best of UserDefaults – it would be strange if our Info.plist file contained 100,000 entries of data, and it’s just as strange to put 100,000 items in UserDefaults.

So, use the UserDefaults system for what it was designed for – as Apple’s own documentation says, it’s called user defaults “because they’re commonly used to determine an app’s default state at startup or the way it acts by default.”

When to use generics
We used generics to create a decoding method that is capable of taking any JSON file from an app bundle and loading into a Codable type of our choosing. But – and this is a big but! – we first wrote the method to be non-generic: if you recall, it originally decoded an array of astronauts before being upgraded to load any kind of Codable type.

That wasn’t me just wasting your time, but instead introducing you to a sensible approach to thinking about generics and protocols. In this project we needed to decode an array of Astronaut instances from astronauts.json, so we wrote a method to do precisely that – no protocols and no generics, just a simple extension on Bundle to help keep the code organized. This mimics the way our brain thinks: we can understand concrete things like astronauts, and we can describe them pretty easily.

Things aren’t quite so straightforward with protocols and generics, though – we now have a range of possible types to work with, which might be entirely unrelated apart from conforming to the same protocol. For example, integers and strings conform to Swift’s built-in Comparable protocol, which is why Swift knows how to sort arrays of them, but otherwise they are completely different things.

Perhaps confusingly, we can’t compare two comparable objects, and in fact even trying to return Comparable from a method won’t work. If you don’t believe me, just try it:

func makeString() -> Comparable {
    "Hello"
}
That won’t compile, and with good reason: Comparable by itself doesn’t mean anything. As I said, both strings and integers conform to the Comparable protocol, but all that means is that you can compare one integer against another, not that you can compare any Comparable type against another – it just wouldn’t make any sense.

This is why generic constraints are so useful: they let us say “this can be any kind of object, as long as…” then provide some restrictions. And – perhaps counterintuitively – adding restrictions often enables more functionality. As you saw, when we said that our decoding method could work with any type, it meant we couldn’t use JSONDecoder with it; Swift wasn’t able to know it could safely decode JSON as that type until we explicitly added a Codable restriction.

So, the key to using generics well is not to use them at first, and when you do need them to add restrictions so that you get the most functionality you can.


Challenge
Before we move on to our next batch of projects, you have a fresh challenge to complete. This means building a complete app from scratch by yourself, using the skills you’ve acquired over the previous three projects.

This time your goal is to build a habit-tracking app, for folks who want to keep track of how much they do certain things. That might be learning a language, practicing an instrument, exercising, or whatever – they get to decide which activities they add, and track it however they want.

At the very least, this means there should be a list of all activities they want to track, plus a form to add new activities – a title and description should be enough.

For a bigger challenge, tapping one of the activities should show a detail screen with the description. For a tough challenge – see the hints below! – make that detail screen contain how many times they have completed it, plus a button incrementing their completion count.

And if you want to make the app really useful, use Codable and UserDefaults to load and save all your data.

So, there are three levels to this app, and you can choose how far you want to go depending on how much time you have and how far you want to push yourself. I do recommend you at least give each level a try, though – every little bit of practice you get helps solidify your learning!