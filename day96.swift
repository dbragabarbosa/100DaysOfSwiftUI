Project 19, part 1

Although all our projects so far work on iPads, we haven’t really taken the time to stop and focus on it in any depth. Well, that changes in our new project because we’re going to be building an app that takes advantage of all the extra space iPads offer, and even takes advantage of the space offered by Max-sized iPhones in landscape orientation.

Even though Apple forked iOS into iPadOS in 2019, iPads and iPhones are almost identical in terms of their software. This means we can write code that works on both platforms at the same time, making only a handful of changes to really make the most of each environment.

When Steve Jobs launched the first iPad back in 2010 he said, “because we already shipped over 75 million iPhones, there are already 75 million users who know how to use the iPad.” This means users benefit from the similarity of the two platforms as well, because they instantly know how to use our apps on iPad thanks to existing usage on iPhone.

Although a custom user interface can look and feel great, never under-estimated the power of this built-in knowledge!

Today you have five topics to work through, in which you’ll learn about split view controllers, binding an alert to an optional, using groups for flexible layout, and more.


SnowSeeker: Introduction

In this project we’re going to create SnowSeeker: an app to let users browse ski resorts around the world, to help them find one suitable for their next holiday.

This will be the first app where we specifically aim to make something that works great on iPad by showing two views side by side, but you’ll also get deep into solving problematic layouts, learn a new way to show sheets and alerts, and more.

As always we have some techniques to cover before getting into the main project, so please create a new iOS project using the App template, calling it SnowSeeker.

Let’s go!


Working with two side by side views in SwiftUI

You’re already familiar with the basic usage of NavigationStack, which allows us to create views like this one:

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Hello, world!")
                .navigationTitle("Primary")
        }
    }
}
That works great on iPhone, but on iPad it's less than ideal – there we have much larger screens to deal with, and having one large view for navigation is a poor use of the space, and also creates quite a jarring experience when new views slide in all the way across.

In these situations, it's a better idea to use a different view for navigation, called NavigationSplitView. This lets us specify either two or three columns of data to show side by side, and iPadOS takes care of showing or hiding them at the right times depending on the exact configuration.

Try it out with this simple code:

NavigationSplitView {
    Text("Primary")
} detail: {
    Text("Content")
}
When you launch the app what you see once again depends on your device and orientation:

On iPhone you'll see Primary.
On iPad in landscape you'll see Primary in a sidebar along the leading edge of your device, and Content filling the rest of the screen.
On iPad in portrait mode you'll see Content filling the screen.
iPadOS does two very clever things here.

First, regardless of your device orientation you'll see a button that shows or hides the primary view, so users can choose what layout they want.

Second, when you activate multi-tasking – if you bring a Safari window alongside, for example – you'll see our app's views adapt so that the Primary view is hidden, because the system recognizes the amount of free space has decreased.

SwiftUI automatically links the primary and secondary views, which means if you have a NavigationLink in the primary view it will automatically load its content in the secondary view:

NavigationSplitView {
    NavigationLink("Primary") {
        Text("New view")
    }
} detail: {
    Text("Content")
}
There are some ways you can customize this split view's behavior.

For example, you can tell iOS to prefer to keep the primary view around when space is partially limited like this:

NavigationSplitView(columnVisibility: .constant(.all)) {
    NavigationLink("Primary") {
        Text("New view")
    }
} detail: {
    Text("Content")
        .navigationTitle("Content View")
}
.navigationSplitViewStyle(.balanced)
That requests that all columns be shown in a balance style, and the result is that iPads in portrait mode will now show the primary view.

Tip: columnVisibility is actually provided as a binding, so you could store your option in some state and update it dynamically.

Second, you can tell the system to prefer the detail view by default, which is helpful on iPhone where the primary view is selected as standard:

NavigationSplitView(preferredCompactColumn: .constant(.detail)) {
Again, you can use that with a binding, so you can change it as your app runs if you want.

Finally, although you can use .toolbar(.hidden, for: .navigationBar) to hide the toolbar in your detail view, be careful because it will hide the button to toggle the sidebar!

Tip: You can even add a third view to NavigationSplitView, which lets you create a sidebar. You’ll see these in apps such as Notes, where you can navigate up from from the list of notes to browse note folders. So, navigation links in the first view control the second view, and navigation links in the second view control the third view – it’s an extra level of organization for times when you need it.


Using alert() and sheet() with optionals

SwiftUI has two ways of creating alerts and sheets, and so far we’ve mostly only used one: a binding to a Boolean that shows the alert or sheet when the Boolean becomes true.

The second option allows us to bind an optional to the alert or sheet. The key is to use an optional Identifiable object as the condition for showing the sheet, and the closure hands you the non-optional value that was used for the condition, so you can use it safely.

To demonstrate this, we could create a trivial User struct that conforms to the Identifiable protocol:

struct User: Identifiable {
    var id = "Taylor Swift"
}
We could then create a property inside ContentView that tracks which user is selected, set to nil by default:

@State private var selectedUser: User? = nil
Now we can change the body of ContentView so that it sets selectedUser to a value when a button is tapped, then displays a sheet when selectedUser is given a value:

Button("Tap Me") {
    selectedUser = User()
}
.sheet(item: $selectedUser) { user in
    Text(user.id)
}
With that simple code, whenever you tap “Tap Me” a sheet saying “Taylor Swift” appears. As soon as the sheet is dismissed, SwiftUI sets selectedUser back to nil.

Alerts have similar functionality, although you need to pass both the Boolean and optional Identifiable value at the same time. This allows you to show the alert when needed, but also benefit from the same optional unwrapping behavior we have with sheets.

First, add a Boolean property to watch:

@State private var isShowingUser = false
Then toggle that Boolean in your button's action:

isShowingUser = true
And finally change your sheet() modifier for this:

.alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
    Button(user.id) { }
}
With that covered, you now know practically all there is to know about sheets and alerts, but there is one last thing I want to sneak in to round out your knowledge.

When we're presenting a sheet, we can add presentation detents to make the sheet take up less than the full screen space. This is done using the presentationDetents() modifier, which accepts a set of sizes to use for the sheet.

For example, we could specify medium and large sizes like this:

Text(selectedUser.id)
    .presentationDetents([.medium, .large])
Because we're specifying two sizes here, the initial size will be used when the sheet is first shown, but iOS will show a little grab handle that lets users pull the sheet up to full size.


Using groups as transparent layout containers

SwiftUI’s Group view might seem odd at first, because it doesn’t actually affect our layout at all. However, it performs an important purpose as a transparent layout container: it gives us the ability to add SwiftUI modifiers to multiple views without changing their layout, or send back multiple views without using @ViewBuilder.

For example, this UserView has a Group containing three text views:

struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Paul")
            Text("Country: England")
            Text("Pets: Luna and Arya")
        }
        .font(.title)
    }
}
That group contains no layout information other than applying a font all three text views, so we don’t know whether the three text views will be stacked vertically, horizontally, or by depth. This is where the transparent layout behavior of Group becomes important: whatever parent places a UserView gets to decide how its text views get arranged.

For example, we could create a ContentView like this:

struct ContentView: View {
    @State private var layoutVertically = false

    var body: some View {
        Button {
            layoutVertically.toggle()
        } label: { 
            if layoutVertically {
                VStack {
                    UserView()
                }
            } else {
                HStack {
                    UserView()
                }
            }
        }
    }
}
That flips between vertical and horizontal layout every time the button is tapped.

You might wonder how often you need to have alternative layouts like this, but the answer might surprise you: it’s really common! You see, this is exactly what you want to happen when trying to write code that works across multiple device sizes – if we want layout to happen vertically when horizontal space is constrained, but horizontally otherwise. Apple provides a very simple solution called size classes, which is a thoroughly vague way of telling us how much space we have for our views.

When I say “thoroughly vague” I mean it: we have only two size classes horizontally and vertically, called “compact” and “regular”. That’s it – that covers all screen sizes from the largest iPad Pro in landscape down to the smallest iPhone in portrait. That doesn’t mean it’s useless – far from it! – just that it only lets us reason about our user interfaces in the broadest terms.

To demonstrate size classes in action, we could create a view that has a property to track the current size class so we can switch between VStack and HStack automatically:

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                UserView()
            }
        } else {
            HStack {
                UserView()
            }
        }
    }
}
Tip: In situations like this, where you have only one view inside a stack and it doesn’t take any parameters, you can pass the view’s initializer directly to the VStack to make your code shorter:

if sizeClass == .compact {
    VStack(content: UserView.init)
} else {
    HStack(content: UserView.init)
}
I know short code isn’t everything, but this technique is pleasingly concise when you’re using this approach to grouped view layout.

What you see when that code runs depends on the device you’re using. For example, an iPhone 15 Pro will have a compact horizontal size class in both portrait and landscape, whereas an iPhone 15 Pro Max will have a regular horizontal size class when in landscape.

Regardless of whether we’re toggling our layout using size classes or buttons, the point is that UserView just doesn’t care – its Group simply groups the text views together without affecting their layout at all, so the layout arrangement UserView is given depends entirely on how it’s used.

Before I'm done, I want to mention that SwiftUI does provide a view that goes some way towards making this behavior easier. It's called ViewThatFits, and you can provide it with several different layouts – it will automatically try each one in order until it finds one that can be fitted into the available space.

For example, this will attempt to show a 500x200 rectangle by default, but if that can't fit into the available space it will show a 200x200 circle instead:

ViewThatFits {
    Rectangle()
        .frame(width: 500, height: 200)

    Circle()
        .frame(width: 200, height: 200)
}
If you can use ViewThatFits then you should, because if you show the same view in several different forms then SwiftUI will correctly preserve that view's state as the layout changes. However, it does limit how much control you get!


Making a SwiftUI view searchable

iOS can add a search bar to our views using the searchable() modifier, and we can bind a string property to it to filter our data as the user types.

To see how this works, try this simple example:

struct ContentView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Text("Searching for \(searchText)")
                .searchable(text: $searchText, prompt: "Look for something")
                .navigationTitle("Searching")
        }
    }
}
Important: You need to make sure your view is inside a NavigationStack, otherwise iOS won’t have anywhere to put the search box.

When you run that code example, you should see a search bar you can type into, and whatever you type will be shown in the view below.

In practice, searchable() is best used with some kind of data filtering. Remember, SwiftUI will reinvoke your body property when an @State property changes, so you could use a computed property to handle the actual filtering:

struct ContentView: View {
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]

    var filteredNames: [String] {
        if searchText.isEmpty {
            allNames
        } else {
            allNames.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredNames, id: \.self) { name in
                Text(name)
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }
}
When you run that, iOS might automatically hide the search bar at the very top of the list – you’ll need to pull down gently to reveal it, which matches the way other iOS apps work. iOS doesn’t require that we make our lists searchable, but it really makes a huge difference to users!

Tip: localizedStandardContains() is the best way to search for things based on user input, because it automatically ignores case and accents such as the é in café.


Sharing @Observable objects through SwiftUI's environment
Swift's @Observable macro combined with @State makes it straightforward to create and use data in our apps, and previously we've looked at how to pass values between different views. However, sometimes you need the same object to be shared across many places in your app, and for that we need to turn to SwiftUI's environment.

To see how this works, let's start with some code you should already know. This creates a small Player class that can be observed by SwiftUI:

@Observable
class Player {
    var name = "Anonymous"
    var highScore = 0
}
We can then show their high score in a small view such as this:

struct HighScoreView: View {
    var player: Player

    var body: some View {
        Text("Your high score: \(player.highScore)")
    }
}
That expects to be given a Player value, so we might write code such as this:

struct ContentView: View {
    @State private var player = Player()

    var body: some View {
        VStack {
            Text("Welcome!")
            HighScoreView(player: player)
        }
    }
}
This is all old code: it shows passing a value into a subview directly, so it can be used there.

Usually, though, we have more complex needs: what if that object needs to be shared in many places? Or what if view A needs to pass it to be view B, which needs to pass it view C, which needs to pass it view D? You can easily see how that would be pretty tedious to code.

SwiftUI has a better solution for these problems: we can place our object into the environment, then use the @Environment property wrapper to read it back out.

This takes two small changes to our code. First, we no longer pass a value directly into HighScoreView, and instead use the environment() modifier to place our object into the environment:

VStack {
    Text("Welcome!")
    HighScoreView()
}
.environment(player)
Important: This modifier is designed for classes that use the @Observable macro. Behind the scenes, one of the things the macro does is add conformance to a protocol called Observable (without the @!), and that's what the modifier is looking for.

Once an object has been placed into the environment, any subview can read it back out. In the case of our HighScoreView, we'd need to modify its player property to this:

@Environment(Player.self) var player
Just like with other kinds of observed state, HighScoreView will automatically be reloaded when its properties change. Be careful, though: your app will crash if you say an environment object will be in the environment and isn't.

Although this mostly works well, there is one place where there's a problem and you'll almost certainly hit it: when trying to use an @Environment value as a binding.

Note: If you're reading this after iOS 18 was released, I sincerely hope Apple has resolved this issue, but right now I'm using iOS 17 and it's an issue.

You can see the problem with code like this:

struct HighScoreView: View {
    @Environment(Player.self) var player

    var body: some View {
        Stepper("High score: \(player.highScore)", value: $player.highScore)
    }
}
That attempts to bind the player's highScore property to a stepper. If we had made the player instance using @State this would be allowed just fine, but that doesn't work with @Environment.

Apple's solution for this – at least right now – is to use @Bindable directly inside the body property, like this:

@Bindable var player = player
That effectively means, "create a copy of my player property locally, then wrap it in some bindings I can use." It's a bit ugly, to be honest, and again I hope by the time you read this it's no longer needed!
