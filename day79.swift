Project 16, part 1
In this project you’re going to be learning a really great mix of features from both Swift and SwiftUI; it will really help push your skills forward and give you the flexibility to create powerful apps. Yes, even here at 79 days through our 100 there are still lots of new things to learn – as Lily Tomlin said, “the road to success is always under construction”!

Be warned, though: this is quite a long project. I've tried to break it down into smaller, simpler days to help make it easier to follow, but don't feel discouraged if you're thinking there's a lot to learn – there is a lot!

Today you have three topics to work through, in which you’ll learn about list selection, tab views, and more.


Hot Prospects: Introduction

In this project we’re going to build Hot Prospects, which is an app to track who you meet at conferences. You’ve probably seen apps like it before: it will show a QR code that stores your attendee information, then others can scan that code to add you to their list of possible leads for later follow up.

That might sound easy enough, but along the way we’re going to cover stacks of really important new techniques: creating tab bars and context menus, sharing custom data using the environment, show notifications on the lock screen, and more. The resulting app is awesome, but what you learn along the way will be particularly useful!

As always we have lots of techniques to cover before we get into the implementation of our project, so please start by creating a new iOS project using the App template, naming it HotProspects.

Let’s get to it!


Letting users select items in a List

It's common to place a NavigationLink inside a List row so that users can tap on a row and see more information, but sometimes you want more control – you want tapping to merely select an item, so you can take some kind of action later.

First, here's a simple List that has no selection, and just shows several strings:

struct ContentView: View {
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]

    var body: some View {
        List(users, id: \.self) { user in
            Text(user)
        }
    }
}
Making that work with selection takes three steps, starting with creating some state to store whatever row is tapped. As our list shows strings, this means making the selected value be an optional string – nothing will be selected by default, but it will contain a user's name when their row is tapped on.

So, we'd need to add this property to the view:

@State private var selection: String?
Next, we need to tell our list to update that state when a row is tapped. This is a two-way binding, which means tapping a row updates the property, but also updating the property will select the row.

Here's how that looks:

List(users, id: \.self, selection: $selection) { user in
    Text(user)
}
And third, we can now go ahead and use that selection somehow. For example, we could show some text below the list if there's a selection:

if let selection {
    Text("You selected \(selection)")
}
If you want to upgrade this to handle multiple selection, you need to change the selection property so that it stores a set of values. This can be empty by default, to mean nothing is selected:

@State private var selection = Set<String>()
And when it comes to displaying the selection, we can call formatted() on the set to display all the names as a single string:

if selection.isEmpty == false {
    Text("You selected \(selection.formatted())")
}
Of course, the real challenge here is how you enable multiple selections, because tapping on one row will automatically unselect the previous row.

iOS does have a fairly hidden gesture for activating multi-select mode: if you swipe horizontally on your data using two fingers, it will activate. If you're using the simulator, you need to hold down the Option key to enable two-finger mode, then also hold down the Shift key to enable swiping, and now swipe from left to right on the list.

Although both of those work, neither are terribly obvious. A better idea is to add an EditButton, which automatically handles enabling or disabling editing and therefore also enables or disables multi-select mode. So, put this somewhere in your layout:

EditButton()
Now you should be able to enter and exit multi-select mode freely, then tap checkboxes next to each list row to add it to your selection. What you then do with your selection is up to you!


Creating tabs with TabView and tabItem()

Navigation stacks are great for letting us create hierarchical stacks of views that let users drill down into data, but they don’t work so well for showing unrelated data. For that we need to use SwiftUI’s TabView, which creates a button strip across the bottom of the screen, where tapping each button shows a different view.

Placing tabs inside a TabView is as simple as listing them out one by one, like this:

TabView {
    Text("Tab 1")
    Text("Tab 2")
}
However, in practice you will always want to customize the way the tabs are shown – in the code above the tab bar will be an empty gray space. Although you can tap on the left and right parts of that gray space to activate the two tabs, it’s a pretty terrible user experience.

Instead, it’s a better idea to attach the tabItem() modifier to each view that’s inside a TabView. This lets you customize the way the view is shown in the tab bar, providing an image and some text to show next to it like this:

TabView {
    Text("Tab 1")
        .tabItem {
            Label("One", systemImage: "star")
        }

    Text("Tab 2")
        .tabItem {
            Label("Two", systemImage: "circle")
        }
}
As well as letting the user switch views by tapping on their tab item, SwiftUI also allows us to control the current view programmatically using state. This takes four steps:

Create an @State property to track the tab that is currently showing.
Modify that property to a new value whenever we want to jump to a different tab.
Pass that as a binding into the TabView, so it will be tracked automatically.
Tell SwiftUI which tab should be shown for each value of that property.
The first three of those are simple enough, so let’s get them out of the way. First, we need some state to track the current tab, so add this as a property to ContentView:

@State private var selectedTab = "One"
Second, we need to modify that somewhere, which will ask SwiftUI to switch tabs. In our little demo we could make our text be a button instead, like this:

Button("Show Tab 2") {
    selectedTab = "Two"
}
.tabItem {
    Label("One", systemImage: "star")
}
Third, we need to bind the selection of the TabView to $selectedTab. This is passed as a parameter when we create the TabView, so update your code to this:

TabView(selection: $selectedTab) {
Now for the interesting part: when we say selectedTab = "Two" how does SwiftUI know which tab that represents? You might think that the tabs could be treated as an array, in which case the second tab would be at index 1, but that causes all sorts of problems: what if we move that tab to a different position in the tab view?

At a deeper level, it also breaks one of the core SwiftUI concepts: that we should be able to compose views freely. If our button was able to say "go to the second tab in the array", it means it has intimate knowledge of how its parent, the TabView, is configured – it has to know the exact tab structure of its parent.

This is A Very Bad Idea, and so SwiftUI offers a better solution: we can attach a unique identifier to each view, and use that for the selected tab. These identifiers are called tags, and are attached using the tag() modifier like this:

Text("Tab 2")
    .tabItem {
        Image(systemName: "circle")
        Text("Two")
    }
    .tag("Two")
So, our entire view would be this:

struct ContentView: View {
    @State private var selectedTab = "One"

    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")

            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}
And now that code works: you can switch between tabs by pressing on their tab items, or by activating our button in the first tab.

Of course, just using “One” and “Two” isn’t ideal – those values are fixed and so it solves the problem of views being moved around, but they aren’t easy to remember. Fortunately, you can use whatever values you like instead: give each view a string tag that is unique and reflects its purpose, then use that for your @State property. This is much easier to work with in the long term, and is recommended over integers.

Tip: It’s common to want to use NavigationStack and TabView at the same time, but you should be careful: TabView should be the parent view, with the tabs inside it having a NavigationStack as necessary, rather than the other way around.