Project 9, part 2

Today we’re going to be continuing our look at SwiftUI’s navigation by moving beyond the basics – how to handle programmatic navigation, but also how to load and save navigation paths so you can restore your app's state.

That last part is a small but important part of app development, but sadly too many developers just don't take the time to get it right. Think about it: you use an app for a while, you navigate to something precise, and then you leave the app for a while to do something else. Wouldn't it be nice if things just came back as they were when you relaunched the app later on, even if "later on" actually means a few days later?

This is just one of today's topics, and I hope you take the time to get it right. As Ralph Waldo Emerson once said, “we aim above the mark to hit the mark – it's always a good thing to do the best you can, because if you fall short you'll still be in a great place!

Anyway, enough chat – let’s get to it!

Today you have four topics to work through, in which you’ll learn about programmatic navigation, NavigationPath, Codable support, and more.


Programmatic navigation with NavigationStack

Programmatic navigation allows us to move from one view to another just using code, rather than waiting for the user to take a specific action. For example, maybe your app is busy processing some user input and you want to navigate to a result screen when that work is finished – you want the navigation to happen automatically when you say so, rather than as a direct response to user input.

In SwiftUI this is done by binding the path of a NavigationStack to an array of whatever data you're navigating with. So, we might start with this:

struct ContentView: View {
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // more code to come
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}
That does two important things:

It creates an @State property to store an array of integers.
It binds that property to the path of our NavigationStack, meaning that changing the array will automatically navigate to whatever is in the array, but also changes the array as the user presses Back in the navigation bar.
So, we could replace the // more code to come with buttons such as these:

Button("Show 32") {
    path = [32]
}

Button("Show 64") {
    path.append(64)
}
In the first button we're setting the whole array so that it just contains the number 32. If anything else happened to be in the array it will be removed, meaning that the NavigationStack will return to its original state before navigating to the number 32.

In the second button we're appending 64, meaning that it will be added to whatever we were navigating to. So, if our array already contained 32, we'd now have three views in the stack: the original view (called the "root" view), then something to show the number 32, and finally something to show the number 64.

You can also push multiple values at the same time, like this:

Button("Show 32 then 64") {
    path = [32, 64]
}
That will present a view for 32 then a view for 64, so the user needs to tap Back twice to get back to the root view.

You can mix user navigation and programmatic navigation as much as you want – SwiftUI will take care of making sure your path array stays in sync with whatever data you show, regardless of how it's shown.


Navigating to different data types using NavigationPath

Navigating to different data types takes one of two forms. The simplest is when you're using navigationDestination() with different data types but you aren't tracking the exact path that's being shown, because here things are straightforward: just add navigationDestination() multiple times, once for each type of data you want.

For example, we could show five numbers and five strings and navigate to them differently:

NavigationStack {
    List {
        ForEach(0..<5) { i in
            NavigationLink("Select Number: \(i)", value: i)
        }

        ForEach(0..<5) { i in
            NavigationLink("Select String: \(i)", value: String(i))
        }
    }
    .navigationDestination(for: Int.self) { selection in
        Text("You selected the number \(selection)")
    }
    .navigationDestination(for: String.self) { selection in
        Text("You selected the string \(selection)")
    }
}
However, things are more complicated when you want to add in programmatic navigation, because you need to be able to bind some data to the navigation stack's path. Previously I showed you how to do this with an array of integers, but now we might have integers or strings so we can't use a simple array any more.

SwiftUI's solution is a special type called NavigationPath, which is able to hold a variety of data types in a single path. In practice it works very similarly to an array – we can make a property using it, like this:

@State private var path = NavigationPath()
Bind that to a NavigationStack:

NavigationStack(path: $path) {
Then push things to it programmatically, for example with toolbar buttons:

.toolbar {
    Button("Push 556") {
        path.append(556)
    }

    Button("Push Hello") {
        path.append("Hello")
    }
}
If you want to feel fancy, NavigationPath is what we call a type-eraser – it stores any kind of Hashable data without exposing exactly what type of data each item is.


How to make a NavigationStack return to its root view programmatically

It's common to be several levels deep in a NavigationStack, then to decide you want to return to the beginning. For example, perhaps your user is placing an order, and has worked their way through screens showing their basket, asking for shipping details, asking for payment details, then confirming the order, but when they are done you want to go back to the very start – back to the root view of your NavigationStack.

To demonstrate this, we can create a little sandbox that can push to new views endlessly by generating new random numbers each time.

First, here's our DetailView that shows its current number as its title, and has a button that pushes to a new random number whenever it's pressed:

struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}
And now we can present that from our ContentView, starting with an initial value of 0 but navigating to a new DetailView every time a new integer is shown:

struct ContentView: View {
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}
When you run that back you'll see you can keep pushing your way through views endlessly – you can go 20, 50, or even 500 views deep if you like.

Now, if you're 10 views deep in there and decide you want to return home you have two options:

If you're using a simple array for your path, like we're doing in the code above, you can call removeAll() on that array to remove everything in your path, going back to the root view.
If you're using NavigationPath for your path, you can set it to a new, empty instance of NavigationPath, like this: path = NavigationPath().
However, there's a bigger problem: how you can do that from the subview, when you don't have access to the original path property?

Here you have two options: either store your path in an external class that uses @Observable, or bring in a new property wrapper called @Binding. I've already demonstrated @Observable previously, so let's focus on @Binding here.

You've seen how @State lets us create some storage inside our view, so we can modify values while our app is running. The @Binding property wrapper lets us pass an @State property into another view and modify it from there – we can share an @State property in several places, and changing it in one place will change it everywhere.

In our current code, that means adding a new property to DetailView to get access to the navigation path array:

@Binding var path: [Int]
And now we need to pass that in from both places in ContentView where DetailView is used, like this:

DetailView(number: 0, path: $path)
    .navigationDestination(for: Int.self) { i in
        DetailView(number: i, path: $path)
    }
As you can see, we're passing in $path because we want to pass the binding in – we want DetailView to be able to read and write the path.

And now we can add a toolbar to DetailView to manipulate the path array:

.toolbar {
    Button("Home") {
        path.removeAll()
    }
}
And if you're using NavigationPath you'd use this:

.toolbar {
    Button("Home") {
        path = NavigationPath()
    }
}
Sharing a binding like this is common – it's exactly how TextField, Stepper, and other controls work. In fact, we'll look at @Binding again in project 11 when we create our own custom component, because it's really helpful.


How to save NavigationStack paths using Codable

You can save and load the navigation stack path using Codable in one of two ways, depending on what kind of path you have:

If you're using NavigationPath to store the active path of your NavigationStack, SwiftUI provides two helpers to make saving and loading your paths easier.
If you're using a homogenous array – e.g. [Int] or [String] – then you don't need those helpers, and you can load or save your data freely.
The techniques are very similar, so I'll cover them both here.

Both rely on storing your path outside your view, so that all the loading and saving of path data happens invisibly – an external class just takes care of it automatically. To be more precise, every time our path data changes – whether that's an array of integers or strings, or a NavigationPath object – we need to save the new path so it's preserved for the future, and we'll also load that data back from disk when the class is initialized.

Here's how that class would look when our path data is stored as an array of integers:

@Observable
class PathStore {
    var path: [Int] {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
                path = decoded
                return
            }
        }

        // Still here? Start with an empty path.
        path = []
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(path)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
If you're using NavigationPath, you need only four small changes.

First, the path property needs to have the type NavigationPath rather than [Int]:

var path: NavigationPath {
    didSet {
        save()
    }
}
Second, when we decode our JSON in the initializer we need to decode to a specific type, then use the decoded data to create a new NavigationPath:

if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
    path = NavigationPath(decoded)
    return
}
Third, if decoding fails we should assign a new, empty NavigationPath instance to the path property at the end of the initializer:

path = NavigationPath()
And finally, the save() method needs to write the Codable representation of our navigation path. This is where things diverge just a little more from using a simple array, because NavigationPath doesn't require that its data types conform to Codable – it only needs Hashable conformance. As a result, Swift can't verify at compile time that there is a valid Codable representation of the navigation path, so we need to request it and see what comes back.

That means adding a check at the start of the save() method, which attempts to retrieve the Codable navigation path and bails out immediately if we get nothing back:

guard let representation = path.codable else { return }
That will either return the data ready to be encoded to JSON, or return nil if at least one object in the path cannot be encoded.

Finally, we convert that Codable representation to JSON instead of the original Int array:

let data = try JSONEncoder().encode(representation)
Here's how the complete class looks:

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        // Still here? Start with an empty path.
        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
Now you can go ahead and write your SwiftUI code as normal, making sure to bind the path of your NavigationStack to the path property of a PathStore instance. For example, this lets you show views with random integers attached – you can push as many views as you like, then quit and relaunch the app to get it exactly back as you left it:

struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}