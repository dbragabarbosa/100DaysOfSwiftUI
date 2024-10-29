Project 11, part 1

Today we’re starting another new project, and this is where things really start to get serious because you’ll be learning one important new Swift skill, one important new SwiftUI skill, and one important app development skill, all of which will come in useful as we build the project.

The app development skill you’ll be learning is one of Apple’s frameworks: SwiftData. It’s responsible for managing objects in a database, including reading, writing, filtering, sorting, and more, and it’s hugely important in app development for iOS, macOS, and beyond. Previously we wrote our data straight to UserDefaults, but that was just a short-term thing to help you along with your learning – SwiftData is the real deal, used by countless thousands of apps.

Canadian software developer Rob Pike (creator of the Go programming language, member of the team that developed Unix, co-creator of UTF-8, and also published author) wrote this about data:

“Data dominates. If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming.”

This is often shortened to “write stupid code that uses smart objects,” and as you’ll see objects don’t get much smarter than when they are backed by SwiftData!

Today you have four topics to work through, in which you’ll learn about @Binding, TextEditor, SwiftData, and more.


Bookworm: Introduction

In this project we’re going to build an app to track which books you’ve read and what you thought of them, and it’s going to follow a similar theme to project 10: let’s take all the skills you’ve already mastered, then add some bonus new skills that take them all to a new level.

This time you’re going to meet SwiftData, which is Apple’s framework for working with databases. This project will serve as an introduction for SwiftData, but we’ll be going into much more detail soon.

At the same time, we’re also going to build our first custom user interface component – a star rating widget where the user can tap to leave a score for each book. This will mean introducing you to another property wrapper, called @Binding – trust me, it will all make sense.

As usual we’re going to start with a walkthrough of all the new techniques you need for this project, so please create a new iOS app called Bookworm, using the App template.

Important: I know it’s tempting, but please don't touch the storage options, even though I know there's a SwiftData option in there. It adds a whole bunch of unhelpful code to your project, and you’ll just need to delete it in order to follow along.


Creating a custom component with @Binding

You’ve already seen how SwiftUI’s @State property wrapper lets us work with local value types, and how @Bindable lets us make bindings to properties inside observable classes. Well, there’s a third option with a rather confusing name: @Binding. This lets us share a simple @State property of one view with another, so they both point to the same integer, string, Boolean, and so on.

Think about it: when we create a toggle switch we send in some sort of Boolean property that can be changed, like this:

@State private var rememberMe = false

var body: some View {
    Toggle("Remember Me", isOn: $rememberMe)
}
So, the toggle needs to change our Boolean when the user interacts with it, but how does it remember what value it should change?

That’s where @Binding comes in: it lets us store a single mutable value in a view that actually points to some other value from elsewhere. In the case of Toggle, the switch changes its own local binding to a Boolean, but behind the scenes that’s actually manipulating the @State property in our view – they are both reading and writing the same Boolean.

The difference between @Bindable and @Binding will be awfully confusing at first, but it will sink eventually.

To be clear, @Bindable is used when you're accessing a shared class that uses the @Observable macro: You create it using @State in one view, so you have bindings available there, but you use @Bindable when sharing it with other views so SwiftUI can create bindings there too.

On the other hand, @Binding is used when you have a simple, value type piece of data rather than a separate class. For example, you have an @State property that stores a Boolean, a Double, an array of strings, etc, and you want to pass that around. That doesn't use the @Observable macro, so we can't use @Bindable. Instead, we use @Binding, so we can share that Boolean or integer in several places.

This behavior makes @Binding extremely important for whenever you want to create a custom user interface component. At their core, UI components are just SwiftUI views like everything else, but @Binding is what sets them apart: while they might have their local @State properties, they also expose @Binding properties that let them interface directly with other views.

To demonstrate this, we’re going to look at the code it takes to create a custom button that stays down when pressed. Our basic implementation will all be stuff you’ve seen before: a button with some padding, a linear gradient for the background, a Capsule clip shape, and so on – add this to ContentView.swift now:

struct PushButton: View {
    let title: String
    @State var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.white)
        .clipShape(.capsule)
        .shadow(radius: isOn ? 0 : 5)
    }
}
The only vaguely exciting thing in there is that I used properties for the two gradient colors so they can be customized by whatever creates the button.

We can now create one of those buttons as part of our main user interface, like this:

struct ContentView: View {
    @State private var rememberMe = false

    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}
That has a text view below the button so we can track the state of the button – try running your code and see how it works.

What you’ll find is that tapping the button does indeed affect the way it appears, but our text view doesn’t reflect that change – it always says “Off”. Clearly something is changing because the button’s appearance changes when it’s pressed, but that change isn’t being reflected in ContentView.

What’s happening here is that we’ve defined a one-way flow of data: ContentView has its rememberMe Boolean, which gets used to create a PushButton – the button has an initial value provided by ContentView. However, once the button was created it takes over control of the value: it toggles the isOn property between true or false internally to the button, but doesn’t pass that change back on to ContentView.

This is a problem, because we now have two sources of truth: ContentView is storing one value, and PushButton another. Fortunately, this is where @Binding comes in: it allows us to create a two-way connection between PushButton and whatever is using it, so that when one value changes the other does too.

To switch over to @Binding we need to make just two changes. First, in PushButton change its isOn property to this:

@Binding var isOn: Bool
And second, in ContentView change the way we create the button to this:

PushButton(title: "Remember Me", isOn: $rememberMe)
That adds a dollar sign before rememberMe – we’re passing in the binding itself, not the Boolean inside it.

Now run the code again, and you’ll find that everything works as expected: toggling the button now correctly updates the text view as well.

This is the power of @Binding: as far as the button is concerned it’s just toggling a Boolean – it has no idea that something else is monitoring that Boolean and acting upon changes.


Accepting multi-line text input with TextEditor

We’ve used SwiftUI’s TextField view several times already, and it’s great for times when the user wants to enter short pieces of text. However, for longer pieces of text you might want to switch over to using a TextEditor view instead: it also expects to be given a two-way binding to a text string, but it has the additional benefit of allowing multiple lines of text – it’s better for giving users a large amount of space to work with.

Mostly because it has nothing special in the way of configuration options, using TextEditor is actually easier than using TextField – you can’t adjust its style or add placeholder text, you just bind it to a string. However, you do need to be careful to make sure it doesn’t go outside the safe area, otherwise typing will be tricky; embed it in a NavigationStack, a Form, or similar.

For example, we could create the world’s simplest notes app by combining TextEditor with @AppStorage, like this:

struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
Tip: @AppStorage is not designed to store secure information, so never use it for anything private.

Now, there's a reason I said you might want to switch over to using a TextEditor as opposed to saying you should: SwiftUI provides a third option that works better in some situations.

When we create a TextField, we can optionally provide an axis it can grow along. This means the textfield starts out as a regular, single-line text field, but as the user types it can grow, just like the iMessage text box does.

Here's how that looks:

struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextField("Enter your text", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
It's worth trying out to see what you think.

You'll use both of these approaches at some point, but at different times. While I love the way TextField automatically expands, sometimes it's just helpful to be able to show a large text space to your user so they know up front they can type a lot in there.

Tip: SwiftUI often changes the way things look once they are inside a Form, so make sure and try them both inside and outside a Form to see how they vary.


Introduction to SwiftData and SwiftUI

SwiftUI is a powerful, modern framework for building great apps on all of Apple's platforms, and SwiftData is a powerful, modern framework for storing, querying, and filtering data. Wouldn't it be nice if they just fitted together somehow?

Well, not only do they work together brilliantly, but they take such little code that you'll barely believe the results – you can create remarkable things in just a few minutes.

First, the basics: SwiftData is an object graph and persistence framework, which is a fancy way of saying it lets us define objects and properties of those objects, then lets us read and write them from permanent storage.

On the surface this sounds like using Codable and UserDefaults, but it’s much more advanced than that: SwiftData is capable of sorting and filtering of our data, and can work with much larger data – there’s effectively no limit to how much data it can store. Even better, SwiftData implements all sorts of more advanced functionality for when you really need to lean on it: iCloud syncing, lazy loading of data, undo and redo, and much more.

In this project we’re going to be using only a small amount of SwiftData’s power, but that will expand soon enough – I just want to give you a taste of it at first.

When you created your Xcode project I asked you to not enable SwiftData support, because although it gets some of the boring set up code out of the way it also adds a whole bunch of extra example code that is just pointless and just needs to be deleted.

So, instead you’re going to learn how to set up SwiftData by hand. It takes three steps, starting with us defining the data we want to use in our app.

Previously we described data by creating a Swift file called something like Student.swift, then giving it this code:

@Observable
class Student {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
We can turn that into a SwiftData object – something that it can save in its database, sync with iCloud, search, sort, and more – by making two very small changes.

First we need to add another import at the top of the file:

import SwiftData
That tells Swift we want to bring in all the functionality from SwiftData.

And now we want to change this:

@Observable
class Student {
To this:

@Model
class Student {
…and that's it. That's literally all it takes to give SwiftData all the information it needs to load and save students. It can also now query them, delete them, link them with other objects, and more.

This class is called a SwiftData model: it defines some kind of data we want to work with in our apps. Behind the scenes, @Model builds on top of the same observation system that @Observable uses, which means it works really well with SwiftUI.

Now that we've defined the data we want to work with, we can proceed to the second step of setting up SwiftData: writing a little Swift code to load that model. This code will tell SwiftData to prepare some storage for us on the iPhone, which is where it will read and write Student objects.

This work is best done in the App struct. Every project has one of these, including all the projects we've made so far, and it acts as the launch pad for the whole app we're running.

As this project is called Bookworm, our App struct will be inside the file BookwormApp.swift. It should look like this:

import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
You can see it looks a bit like our regular view code: we still have an import SwiftUI, we still use a struct to create a custom type, and there's our ContentView right there. The rest is new, and really we care about two parts:

The @main line tells Swift this is what launches our app. Internally this is what bootstraps the whole program when the user launches our app from the iOS Home Screen.
The WindowGroup part tells SwiftUI that our app can be displayed in many windows. This doesn't do much on iPhone, but on iPad and macOS it becomes a lot more important.
This is where we need to tell SwiftData to setup all its storage for us to use, which again takes two very small changes.

First, we need to add import SwiftData next to import SwiftUI. I'm a big fan of sorting my imports alphabetically, but it's not required.

Second, we need to add a modifier to the WindowGroup so that SwiftData is available everywhere in our app:

.modelContainer(for: Student.self)    
A model container is SwiftData's name for where it stores its data. The first time your app runs this means SwiftData has to create the underlying database file, but in future runs it will load the database it made previously.

At this point you've seen how to create data models using @Model, and you've seen how to create a model container using the modelContainer() modifier. The third part of the puzzle is called the model context, which is effectively the “live” version of your data – when you load objects and change them, those changes only exist in memory until they are saved. So, the job of the model context is to let us work with all our data in memory, which is much faster than constantly reading and writing data to disk.

Every SwiftData app needs a model context to work with, and we've already created ours – it's created automatically when we use the modelContainer() modifier. SwiftData automatically creates one model context for us, called the main context, and stores it in SwiftUI's environment,

That completes all our SwiftData configuration, so now it's time for the fun part: reading data, and writing it too.

Retrieving information from SwiftData is done using a query – we describe what we want, how it should sorted, and whether any filters should be used, and SwiftData sends back all the matching data. We need to make sure that this query stays up to date over time, so that as students are created or removed our UI stays synchronized.

SwiftUI has a solution for this, and – you guessed it – it’s another property wrapper. This time it’s called @Query and it's available as soon as you add import SwiftData to a file.

So, add an import for SwiftData at the top of ContentView.swift, then add this property to the ContentView struct:

@Query var students: [Student]
That looks like a regular Student array, but just adding @Query to the start is enough to make SwiftData loads students from its model container – it automatically finds the main context that was placed into the environment, and queries the container through there. We haven't specified which students to load, or how to sort the results, so we'll just get all of them.

From there, we can start using students like a regular Swift array – put this code into your view body:

NavigationStack {
    List(students) { student in
        Text(student.name)
    }
    .navigationTitle("Classroom")
}
You can run the code if you want to, but there isn’t really much point – the list will be empty because we haven’t added any data yet, so our database is empty. To fix that we’re going to create a button below our list that adds a new random student every time it’s tapped, but first we need a new property to access the model context that was created earlier.

Add this property to ContentView now:

@Environment(\.modelContext) var modelContext
With that in place, the next step is add a button that generates random students and saves them in the model context. To help the students stand out, we’ll assign random names by creating firstNames and lastNames arrays, then using randomElement() to pick one of each.

Start by adding this toolbar to the your List:

.toolbar {
    Button("Add") {
        let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
        let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

        let chosenFirstName = firstNames.randomElement()!
        let chosenLastName = lastNames.randomElement()!

        // more code to come
    }
}
Note: Inevitably there are people that will complain about me force unwrapping those calls to randomElement(), but we literally just hand-created the arrays to have values – it will always succeed. If you desperately hate force unwraps, perhaps replace them with nil coalescing and default values.

Now for the interesting part: we’re going to create a Student object. Add this in place of the // more code to come comment:

let student = Student(id: UUID(), name: "\(chosenFirstName) \(chosenLastName)")
Finally we need to ask our model context to add that student, which means it will be saved. Add this final line to the button’s action:

modelContext.insert(student)
At last, you should now be able to run the app and try it out – click the Add button a few times to generate some random students, and you should see them slide somewhere into our list. Even better, if you relaunch the app you’ll find your students are still there, because SwiftData automatically saved them.

Now, you might think this was an awful lot of learning for not a lot of result, but you now know what models, model containers, and model contexts are, and you've seen how to insert and query data. We’ll be looking at SwiftData more later on in this project, as well in the future, but for now you’ve come far.

This was the last part of the overview for this project, so please go ahead and reset your project ready for the real work to begin. That means resetting ContentView.swift, BookwormApp.swift, and also deleting Student.swift.