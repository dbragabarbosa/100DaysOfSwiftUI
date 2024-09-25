Project 7, part 1

Linus Torvalds, the creator of the open source Linux operating system, was once asked if he had any advice for developers who wanted to build a large software project. Here is the response he gave:

Nobody should start to undertake a large project. You start with a small trivial project, and you should never expect it to get large. If you do, you'll just overdesign and generally think it is more important than it likely is at that stage. Or worse, you might be scared away by the sheer size of the work you envision.

In writing this course, I’ve already had people emailing me asking “why didn’t I use X to solve a problem in project 1?” or “Y would have been much better than Z in project 4.” They are probably right, but if I tried to teach you everything in project 1 you’d have found it overwhelming and unpleasant, so instead we built a small app. Then in project 2 we built a second small app. Then we built a third and a fourth, with each one adding to your skills.

Today you’ll start project 7, which is still most definitely a small app. However, in the process you’ll learn how to show another screen, how to share data across screens, how to load and save user data, and more – the kinds of features that really help take your SwiftUI skills to the next level.

That doesn’t mean the app is perfect – as you’ll learn later, UserDefaults isn’t the ideal choice for what we’re doing here, and instead something like the much bigger and more complex SwiftData would be a better fit – but that’s okay. Remember, we’re setting out to build something small and work our way up, rather than just jumping into one all-encompassing mega-project.

If you’re all set, let’s get to it!

Today you have seven topics to work through, in which you’ll learn about @Observable, sheet(), onDelete(), and more.


iExpense: Introduction

Our next two projects are going to start pushing your SwiftUI skills beyond the basics, as we explore apps that have multiple screens, that load and save user data, and have more complex user interfaces.

In this project we’re going to build iExpense, which is an expense tracker that separates personal costs from business costs. At its core this is an app with a form (how much did you spend?) and a list (here are the amounts you spent), but in order to accomplish those two things you’re going to need to learn how to:

Present and dismiss a second screen of data.
Delete rows from a list
Save and load user data
…and more.

There’s lots to do, so let’s get started: create a new iOS app using the App template, naming it “iExpense”. We’ll be using that for the main project, but first lets take a closer look at the new techniques required for this project…


Using @State with classes

SwiftUI’s @State property wrapper is designed for simple data that is local to the current view, but as soon as you want to share data you need to take some important extra steps.

Let’s break this down with some code – here’s a struct to store a user’s first and last name:

struct User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
We can now use that in a SwiftUI view by creating an @State property and attaching things to $user.firstName and $user.lastName, like this:

struct ContentView: View {
    @State private var user = User()

    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")

            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}
That all works: SwiftUI is smart enough to understand that one object contains all our data, and will update the UI when either value changes. Behind the scenes, what’s actually happening is that each time a value inside our struct changes the whole struct changes – it’s like a new user every time we type a key for the first or last name. That might sound wasteful, but it’s actually extremely fast.

Previously we looked at the differences between classes and structs, and there were two important differences I mentioned. First, that structs always have unique owners, whereas with classes multiple things can point to the same value. And second, that classes don’t need the mutating keyword before methods that change their properties, because you can change properties of constant classes.

In practice, what this means is that if we have two SwiftUI views and we send them both the same struct to work with, they actually each have a unique copy of that struct; if one changes it, the other won’t see that change. On the other hand, if we create an instance of a class and send that to both views, they will share changes.

For SwiftUI developers, what this means is that if we want to share data between multiple views – if we want two or more views to point to the same data so that when one changes they all get those changes – we need to use classes rather than structs.

So, please change the User struct to be a class. From this:

struct User {
To this:

class User {
Now run the program again and see what you think.

Spoiler: it doesn’t work any more. Sure, we can type into the text fields just like before, but the text view above doesn’t change.

When we use @State, we’re asking SwiftUI to watch a property for changes. So, if we change a string, flip a Boolean, add to an array, and so on, the property has changed and SwiftUI will re-invoke the body property of the view.

When User was a struct, every time we modified a property of that struct Swift was actually creating a new instance of the struct. @State was able to spot that change, and automatically reloaded our view. Now that we have a class, that behavior no longer happens: Swift can just modify the value directly.

Remember how we had to use the mutating keyword for struct methods that modify properties? This is because if we create the struct’s properties as variable but the struct itself is constant, we can’t change the properties – Swift needs to be able to destroy and recreate the whole struct when a property changes, and that isn’t possible for constant structs. Classes don’t need the mutating keyword, because even if the class instance is marked as constant Swift can still modify variable properties.

I know that all sounds terribly theoretical, but here’s the twist: now that User is a class the property itself isn’t changing, so @State doesn’t notice anything and can’t reload the view. Yes, the values inside the class are changing, but @State doesn’t monitor those, so effectively what’s happening is that the values inside our class are being changed but the view isn’t being reloaded to reflect that change.

We can fix this problem with one small change: I'd like you to add the line @Observable before the class. It should look like this:

@Observable
class User {
And now our code will work again. To understand why, let's explore what @Observable actually does…


Sharing SwiftUI state with @Observable

If you use @State with a struct, your SwiftUI view will update automatically when a value changes, but if you use @State with a class then you must mark that class with @Observable if you want SwiftUI to watch its contents for changes.

To understand what's going on, let's take a look at this code in more detail:

@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
This is a class with two string variables, but it starts with @Observable. That tells SwiftUI to watch each individual property inside the class for changes, and reload any view that relies on a property when it changes. I know that might sound a bit like magic, but it's not – it's just a whole lot of work carefully hidden.

I want to dig in a little here so you can see what's really happening, and to do that I'd like you to add another import line to the top, next to import SwiftUI:

import Observation
That @Observable line is a macro, which is Swift's way of quietly rewriting our code to add extra functionality. Now that we've imported the framework it comes from, Xcode can do something really neat: if you right-click on @Observable in your code, you can choose Expand Macro to see exactly what rewriting is happening – Xcode will show you all the hidden code that's being generated.

I'm not going to write out the whole macro expansion here because it's a lot, but I do want to point out three things:

Our two properties are marked @ObservationTracked, which means Swift and SwiftUI are watching them for changes.
If you right-click on @ObservationTracked you can expand that macro too – yes, it's a macro inside a macro. This macro has the job of tracking whenever any property is read or written, so that SwiftUI can update only views that absolutely need to be refreshed.
Our class is made to conform to the Observable protocol. This is important, because some parts of SwiftUI look for this to mean "this class can be watched for changes."
All three of those are important, but it's the middle one that is doing the heavy lifting: iOS keeps track of every SwiftUI view that reads properties from an @Observed object, so that when a property changes it can intelligently update all the views that depend on it while leaving the others unchanged.

When working with structs, the @State property wrapper keeps a value alive and also watches it for changes. On the other hand, when working with classes, @State is just there for keeping object alive – all the watching for changes and updating the view is taken care of by @Observable.


Showing and hiding views

There are several ways of showing views in SwiftUI, and one of the most basic is a sheet: a new view presented on top of our existing one. On iOS this automatically gives us a card-like presentation where the current view slides away into the distance a little and the new view animates in on top.

Sheets work much like alerts, in that we don’t present them directly with code such as mySheet.present() or similar. Instead, we define the conditions under which a sheet should be shown, and when those conditions become true or false the sheet will either be presented or dismissed respectively.

Let’s start with a simple example, which will be showing one view from another using a sheet. First, we create the view we want to show inside a sheet, like this:

struct SecondView: View {
    var body: some View {
        Text("Second View")
    }
}
There’s nothing special about that view at all – it doesn’t know it’s going to be shown in a sheet, and doesn’t need to know it’s going to be shown in a sheet.

Next we create our initial view, which will show the second view. We’ll make it simple, then add to it:

struct ContentView: View { 
    var body: some View {
        Button("Show Sheet") {
            // show the sheet
        }
    }
}
Filling that in requires four steps, and we’ll tackle them individually.

First, we need some state to track whether the sheet is showing. Just as with alerts, this can be a simple Boolean, so add this property to ContentView now:

@State private var showingSheet = false
Second, we need to toggle that when our button is tapped, so replace the // show the sheet comment with this:

showingSheet.toggle()
Third, we need to attach our sheet somewhere to our view hierarchy. If you remember, we show alerts using isPresented with a two-way binding to our state property, and we use something almost identical here: sheet(isPresented:).

sheet() is a modifier just like alert(), so please add this modifier to our button now:

.sheet(isPresented: $showingSheet) {
    // contents of the sheet
}
Fourth, we need to decide what should actually be in the sheet. In our case, we already know exactly what we want: we want to create and show an instance of SecondView. In code that means writing SecondView(), then… er… well, that’s it.

So, the finished ContentView struct should look like this:

struct ContentView: View {
    @State private var showingSheet = false

    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView()
        }
    }
}
If you run the program now you’ll see you can tap the button to have our second view slide upwards from the bottom, and you can then drag that down to dismiss it.

When you create a view like this, you can pass in any parameters it needs to work. For example, we could require that SecondView be sent a name it can display, like this:

struct SecondView: View {
    let name: String

    var body: some View {
        Text("Hello, \(name)!")
    }
}
And now just using SecondView() in our sheet isn’t good enough – we need to pass in a name string to be shown. For example, we could pass in my Twitter username like this:

.sheet(isPresented: $showingSheet) {
    SecondView(name: "@twostraws")
}
Now the sheet will show “Hello, @twostraws”.

Swift is doing a ton of work on our behalf here: as soon as we said that SecondView has a name property, Swift ensured that our code wouldn’t even build until all instances of SecondView() became SecondView(name: "some name"), which eliminates a whole range of possible errors.

Before we move on, there’s one more thing I want to demonstrate, which is how to make a view dismiss itself. Yes, you’ve seen that the user can just swipe downwards, but sometimes you will want to dismiss views programmatically – to make the view go away because a button was pressed, for example.

To dismiss another view we need another property wrapper – and yes, I realize that so often the solution to a problem in SwiftUI is to use another property wrapper.

Anyway, this new one is called @Environment, and it allows us to create properties that store values provided to us externally. Is the user in light mode or dark mode? Have they asked for smaller or larger fonts? What timezone are they on? All these and more are values that come from the environment, and in this instance we’re going to ask the environment to dismiss our view.

Yes, we need to ask the environment to dismiss our view, because it might have been presented in any number of different ways. So, we’re effectively saying “hey, figure out how my view was presented, then dismiss it appropriately.”

To try it out add this property to SecondView, which creates a property called dismiss based on a value from the environment:

@Environment(\.dismiss) var dismiss
Now replace the text view in SecondView with this button:

Button("Dismiss") {
    dismiss()
}
Anyway, with that button in place, you should now find you can show and hide the sheet using button presses.


Deleting items using onDelete()

SwiftUI gives us the onDelete() modifier for us to use to control how objects should be deleted from a collection. In practice, this is almost exclusively used with List and ForEach: we create a list of rows that are shown using ForEach, then attach onDelete() to that ForEach so the user can remove rows they don’t want.

This is another place where SwiftUI does a heck of a lot of work on our behalf, but it does have a few interesting quirks as you’ll see.

First, let’s construct an example we can work with: a list that shows numbers, and every time we tap the button a new number appears. Here’s the code for that:

struct ContentView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1

    var body: some View {
        VStack {
            List {
                ForEach(numbers, id: \.self) {
                    Text("Row \($0)")
                }
            }

            Button("Add Number") {
                numbers.append(currentNumber)
                currentNumber += 1
            }
        }
    }
}
Now, you might think that the ForEach isn’t needed – the list is made up of entirely dynamic rows, so we could write this instead:

List(numbers, id: \.self) {
    Text("Row \($0)")
}
That would also work, but here’s our first quirk: the onDelete() modifier only exists on ForEach, so if we want users to delete items from a list we must put the items inside a ForEach. This does mean a small amount of extra code for the times when we have only dynamic rows, but on the flip side it means it’s easier to create lists where only some rows can be deleted.

In order to make onDelete() work, we need to implement a method that will receive a single parameter of type IndexSet. This is a bit like a set of integers, except it’s sorted, and it’s just telling us the positions of all the items in the ForEach that should be removed.

Because our ForEach was created entirely from a single array, we can actually just pass that index set straight to our numbers array – it has a special remove(atOffsets:) method that accepts an index set.

So, add this method to ContentView now:

func removeRows(at offsets: IndexSet) {
    numbers.remove(atOffsets: offsets)
} 
Finally, we can tell SwiftUI to call that method when it wants to delete data from the ForEach, by modifying it to this:

ForEach(numbers, id: \.self) {
    Text("Row \($0)")
}
.onDelete(perform: removeRows)
Now go ahead and run your app, then add a few numbers. When you’re ready, swipe from right to left across any of the rows in your list, and you should find a delete button appears. You can tap that, or you can also use iOS’s swipe to delete functionality by swiping further.

Given how easy that was, I think the result works really well. But SwiftUI has another trick up its sleeve: we can add an Edit/Done button to the navigation bar, that lets users delete several rows more easily.

First, wrap your VStack in a NavigationStack, then add this modifier to the VStack:

.toolbar {
    EditButton()
}
That’s literally all it takes – if you run the app you’ll see you can add some numbers, then tap Edit to start deleting those rows. When you’re ready, tap Done to exit editing mode. Not bad, given how little code it took!


Storing user settings with UserDefaults

Most users pretty much expect apps to store their data so they can create more customized experiences, and as such it’s no surprise that iOS gives us several ways to read and write user data.

One common way to store a small amount of data is called UserDefaults, and it’s great for simple user preferences. There is no specific number attached to “a small amount”, but everything you store in UserDefaults will automatically be loaded when your app launches – if you store a lot in there your app launch will slow down. To give you at least an idea, you should aim to store no more than 512KB in there.

Tip: If you’re thinking “512KB? How much is that?” then let me give you a rough estimate: it’s about as much text as all the chapters you’ve read in this book so far.

UserDefaults is perfect for storing things like when the user last launched the app, which news story they last read, or other passively collected information. Even better, SwiftUI can often wrap up UserDefaults inside a nice and simple property wrapper called @AppStorage – it only supports a subset of functionality right now, but it can be really helpful.

Enough chat – let’s look at some code. Here’s a view with a button that shows a tap count, and increments that count every time the button is tapped:

struct ContentView: View {
    @State private var tapCount = 0

    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}
As this is clearly A Very Important App, we want to save the number of taps that the user made, so when they come back to the app in the future they can pick up where they left off.

To make that happen, we need to write to UserDefaults inside our button’s action closure. So, add this after the tapCount += 1 line:

UserDefaults.standard.set(tapCount, forKey: "Tap")
In just that single line of code you can see three things in action:

We need to use UserDefaults.standard. This is the built-in instance of UserDefaults that is attached to our app, but in more advanced apps you can create your own instances. For example, if you want to share defaults across several app extensions you might create your own UserDefaults instance.
There is a single set() method that accepts any kind of data – integers, Booleans, strings, and more.
We attach a string name to this data, in our case it’s the key “Tap”. This key is case-sensitive, just like regular Swift strings, and it’s important – we need to use the same key to read the data back out of UserDefaults.
Speaking of reading the data back, rather than start with tapCount set to 0 we should instead make it read the value back from UserDefaults like this:

@State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
Notice how that uses exactly the same key name, which ensures it reads the same integer value.

Go ahead and give the app a try and see what you think – you ought to be able tap the button a few times, go back to Xcode, run the app again, and see the number exactly where you left it.

There are two things you can’t see in that code, but both matter. First, what happens if we don’t have the “Tap” key set? This will be the case the very first time the app is run, but as you just saw it works fine – if the key can’t be found it just sends back 0.

Sometimes having a default value like 0 is helpful, but other times it can be confusing. With Booleans, for example, you get back false if boolean(forKey:) can’t find the key you asked for, but is that false a value you set yourself, or does it mean there was no value at all?

Second, it takes iOS a little time to write your data to permanent storage – to actually save that change to the device. They don’t write updates immediately because you might make several back to back, so instead they wait some time then write out all the changes at once. How much time is another number we don’t know, but a couple of seconds ought to do it.

As a result of this, if you tap the button then quickly relaunch the app from Xcode, you’ll find your most recent tap count wasn’t saved. There used to be a way of forcing updates to be written immediately, but at this point it’s worthless – even if the user immediately started the process of terminating your app after making a choice, your defaults data would be written immediately so nothing will be lost.

Now, I mentioned that SwiftUI provides an @AppStorage property wrapper around UserDefaults, and in simple situations like this one it’s really helpful. What it does is let us effectively ignore UserDefaults entirely, and just use @AppStorage rather than @State, like this:

struct ContentView: View {
    @AppStorage("tapCount") private var tapCount = 0

    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}
Again, there are three things I want to point out in there:

Our access to the UserDefaults system is through the @AppStorage property wrapper. This works like @State: when the value changes, it will reinvoked the body property so our UI reflects the new data.
We attach a string name, which is the UserDefaults key where we want to store the data. I’ve used “tapCount”, but it can be anything at all – it doesn’t need to match the property name.
The rest of the property is declared as normal, including providing a default value of 0. That will be used if there is no existing value saved inside UserDefaults.
Clearly using @AppStorage is easier than UserDefaults: it’s one line of code rather than two, and it also means we don’t have to repeat the key name each time. However, right now at least @AppStorage doesn’t make it easy to handle storing complex objects such as Swift structs – perhaps because Apple wants us to remember that storing lots of data in there is a bad idea!

Important: When it comes to you submitting an app to the App Store, Apple asks that you let them know why you're loading and saving data using UserDefaults. This also applies to the @AppStorage property wrapper. It's nothing to worry about, they just want to make sure developers aren't trying to identify users across apps.


Archiving Swift objects with Codable

@AppStorage is great for storing simple settings such as integers and Booleans, but when it comes to complex data – custom Swift types, for example – we need to do a little more work. This is where we need to poke around directly with UserDefaults itself, rather than going through the @AppStorage property wrapper.

Here’s a simple User data structure we can work with:

struct User {
    let firstName: String
    let lastName: String
}
That has two strings, but those aren’t special – they are just pieces of text. The same goes for integer (plain old numbers), Boolean (true or false), and Double (plain old numbers, just with a dot somewhere in there). Even arrays and dictionaries of those values are easy to think about: there’s one string, then another, then a third, and so on.

When working with data like this, Swift gives us a fantastic protocol called Codable: a protocol specifically for archiving and unarchiving data, which is a fancy way of saying “converting objects into plain text and back again.”

We’re going to be looking at Codable much more in future projects, but for now we’re going to keep it as simple as possible: we want to archive a custom type so we can put it into UserDefaults, then unarchive it when it comes back out from UserDefaults.

When working with a type that only has simple properties – strings, integers, Booleans, arrays of strings, and so on – the only thing we need to do to support archiving and unarchiving is add a conformance to Codable, like this:

struct User: Codable {
    let firstName: String
    let lastName: String
}
Swift will automatically generate some code for us that will archive and unarchive User instances for us as needed, but we still need to tell Swift when to archive and what to do with the data.

This part of the process is powered by a new type called JSONEncoder. Its job is to take something that conforms to Codable and send back that object in JavaScript Object Notation (JSON) – the name implies it’s specific to JavaScript, but in practice we all use it because it’s so fast and simple.

The Codable protocol doesn’t require that we use JSON, and in fact other formats are available, but it is by far the most common. In this instance, we don’t actually care what sort of data is used, because it’s just going to be stored in UserDefaults.

To convert our user data into JSON data, we need to call the encode() method on a JSONEncoder. This might throw errors, so it should be called with try or try? to handle errors neatly. For example, if we had a property to store a User instance, like this:

@State private var user = User(firstName: "Taylor", lastName: "Swift")
Then we could create a button that archives the user and save it to UserDefaults like this:

Button("Save User") {
    let encoder = JSONEncoder()

    if let data = try? encoder.encode(user) {
        UserDefaults.standard.set(data, forKey: "UserData")
    }
}
That accesses UserDefaults directly rather than going through @AppStorage, because the @AppStorage property wrapper just doesn’t work here.

That data constant is a new data type called, perhaps confusingly, Data. It’s designed to store any kind of data you can think of, such as strings, images, zip files, and more. Here, though, all we care about is that it’s one of the types of data we can write straight into UserDefaults.

When we’re coming back the other way – when we have JSON data and we want to convert it to Swift Codable types – we should use JSONDecoder rather than JSONEncoder(), but the process is much the same.

That brings us to the end of our project overview, so go ahead and reset your project to its initial state ready to build on.