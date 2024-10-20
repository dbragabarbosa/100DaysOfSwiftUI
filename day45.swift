Project 9, part 3

Today we’re going to complete your knowledge of SwiftUI navigation by looking at the customization options available to us: customizing the navigation bar appearance, placing toolbar buttons in exact locations, and also letting users edit the navigation title.

Of the three, the middle one is the most important because it comes in two variants: we can either force exact positions of buttons, or we can semantic locations that allow SwiftUI to place the buttons where they make sense for the current platform – and also apply extra styling as appropriate.

A Steve Jobs quote I love is, "Some people think design means how it looks. But of course, if you dig deeper, it's really how it works." This is the power of a declarative layout system like SwiftUI: by giving extra information to the system, by describing the role something has, SwiftUI takes care of making it work the correct way automatically – it's much easier than trying to do it all ourselves.

Today you have three topics to work through, where you’ll learn about custom navigation bar appearances, hiding the back button, toolbar placements, , and more.


Customizing the navigation bar appearance

iOS likes its navigation bars to look a very particular way, but we do have some limited control over its styling.

First, you've seen how we can use large or inline navigation title styles, giving us large or small text at the top. So, this will use a small title at the top:

NavigationStack {
    List(0..<100) { i in
        Text("Row \(i)")
    }
    .navigationTitle("Title goes here")
    .navigationBarTitleDisplayMode(.inline)
}
You'll see the navigation bar at the top is invisible by default, but as soon as you scroll up a little it gets a solid gray background so that its title stands out clearly from the contents of the list.

SwiftUI lets us customize that just a little: we can specify an alternative color to be used for that background. Remember, this is only visible when the list scrolls under the navigation bar, so you won't see it at first.

To try it out, add this below navigationBarTitleDisplayMode():

.toolbarBackground(.blue)
When you run the app and scroll a little, you'll see the navigation bar becomes a solid blue color. You'll also see the title might be hard to read, because it will be black text in light mode.

You can fix that by adding another modifier below the previous one, forcing the navigation bar to use dark mode at all times, which in turn means the title text will be white:

.toolbarColorScheme(.dark)
Tip: Later on you'll meet other kinds of toolbars. Those two modifiers affect all bars, but if you want to just modify the navigation bar you should add for: .navigationBar as a second parameter to both of them.

There's one last way to customize the navigation bar: you can hide it, either always or based on the current state in your app.

To do that, add the toolbar() modifier set to .hidden, either for all bars or just the navigation bar:

.toolbar(.hidden, for: .navigationBar)
Hiding the toolbar won't stop you from navigating to new views, but it might cause scrolling views to go under system information such as the clock – be careful!


Placing toolbar buttons in exact locations

If you place buttons in a NavigationStack toolbar, SwiftUI will place them automatically based on the platform your code is running on. We're building iOS apps here, so that means our buttons will be placed in the right-hand side of the navigation bar in languages that are read left-to-right, such as English.

You can customize this if you want, using ToolbarItem. This goes around your toolbar buttons, allowing you to place them exactly where you want by choosing from one of several options.

For example, we can ask for a left-hand placement like this:

NavigationStack {
    Text("Hello, world!")
    .toolbar {
        ToolbarItem(placement: .topBarLeading) {
            Button("Tap Me") {
                // button action here
            }
        }
    }
}
Although that works well, usually it's better to use one of the semantic options – placement that have specific meaning, rather than relying just on their location. These include:

.confirmationAction, when you want users to agree to something, such as agreeing to terms of service.
.destructiveAction, when the user needs to make a choice to destroy whatever it is they are working with, such as confirming they want to remove some data they created.
.cancellationAction, when the user needs to back out of changes they have made, such as discarding changes they have made.
.navigation, which is used for buttons that make the user move between data, such as going back and forward in a web browser.
These semantic placements come with two important benefits. First, because iOS has extra information about what your buttons do, it can add extra styling – a confirmation button can be rendered in bold, for example. Second, these positions automatically adapt on other platforms, so your button will always appear in the correct place on iOS, macOS, watchOS, and more.

Tip: If you need the user to decide between saving a change or discarding it, you might want to add the navigationBarBackButtonHidden() modifier so that they can't tap Back to exit without making a choice.

If you want multiple buttons using the same placement, you can either repeat ToolbarItem like this:

.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        Button("Tap Me") {
            // button action here
        }
    }

    ToolbarItem(placement: .topBarLeading) {
        Button("Or Tap Me") {
            // button action here
        }
    }
}
Or you can use ToolbarItemGroup, like this:

.toolbar {
    ToolbarItemGroup(placement: .topBarLeading) {
        Button("Tap Me") {
            // button action here
        }

        Button("Tap Me 2") {
            // button action here
        }
    }
}
Both should produce the same result.


Making your navigation title editable

The basic navigationTitle() modifier lets us display a string in the navigation bar, like this:

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Hello, world!")
                .navigationTitle("SwiftUI")
        }
    }
}
But if you're using the .inline title display mode, you can also pass a binding to navigationTitle(). This will then be displayed as usual, but with an important addition: iOS will show a small arrow next to your title, that reveals a "Rename" button to change the title.

Here's how that looks in code:

struct ContentView: View {
    @State private var title = "SwiftUI"

    var body: some View {
        NavigationStack {
            Text("Hello, world!")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
This is great for times when that title reflects the name of something entered by the user, because it means you don't need to add an extra textfield to your layout.