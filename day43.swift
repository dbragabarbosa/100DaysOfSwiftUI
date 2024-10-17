Project 9, part 1

Today kicks off another new technique project where we’ll be focusing on navigation. This is an area of SwiftUI we touched on just briefly in the previous project, but really lies at the core of practically every app you'll build.

As you'll see, navigation is really broken down into two major types: navigation driven by user interaction, and programmatic navigation that you trigger yourself. Both are important, and you'll find yourself mixing the two freely.

One thing you'll be exploring later on is the difference between using navigation and using sheets. Both matter, and you'll certainly use both on a regular occasion, but as you're working through these days I want you to think carefully about what each choice means and why you think you'd use one rather than the other – as John Maxwell said, "find your why and you'll find your way."

Today you have three topics to work through, in which you’ll learn a smarter, more flexible approach to navigation using navigation presentation values and the navigationDestination() modifier.


Navigation: Introduction

In this technique project we’re going to take a close look at navigation in SwiftUI – how we move from one screen to another using NavigationStack, both because the user asked for it and also because we want to do it automatically at a specific time.

Once we've covered those basics, we're going to look at more advanced navigation, including handling state restoration – remembering exactly where the user had navigated to, so when your app launches in the future they can pick up where they left off.

And when we're done with that we'll look at some customization options: changing the way the navigation bar looks, positioning your buttons just right, and even how to let your user change the navigation title on demand.

That's a lot to cram in, but by the end of it all you'll have a much stronger understanding of how navigation works in SwiftUI, so you can really make the most of it in all your apps.

Please create a new App project called Navigation and let’s get started…


The problem with a simple NavigationLink

When you're just learning SwiftUI, or if you have very simple needs, you'll write navigation code like this:

NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
}
Sometimes that's absolutely the right thing to do, but it has a hidden problem. To see what it is, I want to create a real detail view that prints a message in its initializer:

struct DetailView: View {
    var number: Int

    var body: some View {
        Text("Detail View \(number)")
    }

    init(number: Int) {
        self.number = number
        print("Creating detail view \(number)")
    }
}
And now try using that in your navigation code:

NavigationStack {
    NavigationLink("Tap Me") {
        DetailView(number: 556)
    }
}
Go ahead and run the project, but don't tap the navigation link – just run it and look in Xcode's debug console area, because you should see "Creating detail view 556".

What's happening is that just showing the navigation on the screen is enough for SwiftUI to automatically create a detail view instance. Doing that a couple of times is fine, but what if we had something more complex? For example, imagine doing this inside a list of 1000 rows:

NavigationStack {
    List(0..<1000) { i in
        NavigationLink("Tap Me") {
            DetailView(number: i)
        }
    }
}
Now you'll see lots of DetailView instances are being created as you scroll around, often more than once. This is making Swift and SwiftUI do a lot more work than is necessary, so when you're dealing with dynamic data – when you have lots of different integers to show in the same way, for example – SwiftUI gives us a better solution: attaching a presentation value to our navigation link.

Let's look at that next…


Handling navigation the smart way with navigationDestination()

In the simplest form of SwiftUI navigation, we provide both a label and a destination view in one single NavigationLink, like this:

NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
}
But for more advanced navigation, it's better to separate the destination from the value. This allows SwiftUI to load the destination only when it's needed.

Doing this takes two steps:

We attach a value to the NavigationLink. This value can be anything you want – a string, an integer, a custom struct instance, or whatever. However, there is one requirement: whatever type you use must conform to a protocol called Hashable.
Attaching a navigationDestination() modifier inside the navigation stack, telling it what to do when it receives your data.
Both of those are new, but to begin with you can ignore the Hashable requirement because most of Swift's built-in types already conform to Hashable. For example, Int, String, Date, URL, arrays, and dictionaries already conform to Hashable, so you don't need to worry about them.

So, let's look at the navigationDestination() modifier first, then circle back to look at Hashable in more detail.

First, we could make a List of 100 numbers, with each one being attached to a navigation link as its presentation value – we're telling SwiftUI we want to navigate to a number. Here's how that looks:

NavigationStack {
    List(0..<100) { i in
        NavigationLink("Select \(i)", value: i)
    }
}
Now, that code isn't quite enough. Yes, we've told SwiftUI we want to navigate to 0 when "Select 0" is tapped, but we haven't said how to show that data. Should it be some text, a VStack with some pictures, a custom SwiftUI view, or something else entirely?

This is where the navigationDestination() modifier comes in: we can tell it "when you're asked to navigate to an integer, here's what you should do…"

Modify your code to this:

NavigationStack {
    List(0..<100) { i in
        NavigationLink("Select \(i)", value: i)
    }
    .navigationDestination(for: Int.self) { selection in
        Text("You selected \(selection)")
    }
}
So, when SwiftUI attempts to navigation to any Int value, it gives us that value in the selection constant, and we need to return the correct SwiftUI view to show it.

Tip: If you have several different types of data to navigate to them, just add several navigationDestination() modifiers. In effect you're saying, "do this when you want to navigate to an integer, but do that when you want to navigate to a string."

That works great for lots of data, such as navigating to strings, integers, and UUIDs. But for more complex data such as custom structs, we need to use hashing.

Hashing is a computer science term that is the process of converting some data into a smaller representation in a consistent way. It's commonly used when downloading data: if you imagine downloading a movie on your Apple TV, that movie might be 10GB or so, but how can you be sure every single piece of data got downloaded successfully?

With hashing, we can convert that 10GB movie into a short string – maybe 40 characters in total – that uniquely identifies it. The hash function needs to be consistent, which means if we hash the movie locally and compare it to the hash on the server, they should always be the same, and comparing two 40-character strings is much easier than comparing two 10GB files!

Obviously there's no way to unhash data, because you can't convert just 40 characters back into a 10GB movie. But that's okay: the main thing is that the hash value for each piece of data ought to be unique, and also consistent so that we get the same hash value for the movie every time.

Swift uses Hashable a lot internally. For example, when you use a Set rather than an array, everything you put in there must conform to the Hashable protocol. This is what makes sets so fast compared to arrays: when you say "does the set contain this particular object?" Swift will compute the hash of your object, then search for that in the set rather than trying to compare every property against every object.

If all this sounds complicated, remember that most of Swift's built-in types already conform to Hashable. And if you make a custom struct with properties that all conform to Hashable, you can make the whole struct conform to Hashable with one tiny change.

As an example, this struct contains a UUID, a string, and an integer:

struct Student {
    var id = UUID()
    var name: String
    var age: Int
}
If we want to make that struct conform to Hashable, we just add the protocol like this:

struct Student: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}
Now that our Student struct conforms to Hashable it can be used with both NavigationLink and navigationDestination() just like integers or strings