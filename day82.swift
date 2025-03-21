Project 16, part 4

It’s time to start putting your new techniques into action, and this project is so big it takes three implementation days to complete. But this is day 82, so you’ve shown you have the willpower to make amazing things – as the aviation pioneer Amelia Earhart once said, “the most difficult thing is the decision to act, the rest is merely tenacity.”

Today we're going to return to SwiftData, because this app is a great candidate for storing data there. I know you might think we're just repeating old stuff, but trust me: repetition is one of the most important parts of learning, and I left quite a few days between today and the previous SwiftData material specifically because adding that extra space helps re-enforcement. (If you're curious, it's a technique called spaced repetition – it works!)

Anyway, enough chat – you have lots to get through today, so let’s get on to the code.

Today you have three topics to work through, in which we'll cover tab views, SwiftData filtering, and more.


Building our tab bar

This app is going to display four SwiftUI views inside a tab bar: one to show everyone that you met, one to show people you have contacted, another to show people you haven’t contacted, and a final one showing your personal information for others to scan.

Those first three views are variations on the same concept, but the last one is quite different. As a result, we can represent all our UI with just three views: one to display people, one to show our data, and one to bring all the others together using TabView.

So, our first step will be to create placeholder views for our tabs that we can come back and fill in later. Press Cmd+N to make a new SwiftUI view and call it “ProspectsView”, then create another SwiftUI view called “MeView”. You can leave both of them with the default “Hello, World!” text view; it doesn’t matter for now.

For now, what matters is ContentView, because that’s where we’re going to store our TabView that contains all the other views in our UI. We’re going to add some more logic here shortly, but for now this is just going to be a TabView with three instances of ProspectsView and one MeView. Each of those views will have a tabItem() modifier with an image that I picked out from SF Symbols and some text.

Replace the body of your current ContentView with this:

TabView {
    ProspectsView()
        .tabItem {
            Label("Everyone", systemImage: "person.3")
        }
    ProspectsView()
        .tabItem {
            Label("Contacted", systemImage: "checkmark.circle")
        }
    ProspectsView()
        .tabItem {
            Label("Uncontacted", systemImage: "questionmark.diamond")
        }
    MeView()
        .tabItem {
            Label("Me", systemImage: "person.crop.square")
        }
}
If you run the app now you’ll see a neat tab bar across the bottom of the screen, allowing us to tap through each of our four views.

Now, obviously creating three instances of ProspectsView will be weird in practice because they’ll just be identical, but we can fix that by customizing each view. Remember, we want the first one to show every person you’ve met, the second to show people you have contacted, and the third to show people you haven’t contacted, and we can represent that with an enum plus a property on ProspectsView.

So, add this enum inside ProspectsView now:

enum FilterType {
    case none, contacted, uncontacted
}
Now we can use that to allow each instance of ProspectsView to be slightly different by giving it a new property:

let filter: FilterType
This will immediately break ContentView and its preview because they need to provide a value for that property when creating ProspectsView, but first let’s use it to customize each of the three views just a little by giving them a navigation bar title.

Start by adding this computed property to ProspectsView:

var title: String {
    switch filter {
    case .none:
        "Everyone"
    case .contacted:
        "Contacted people"
    case .uncontacted:
        "Uncontacted people"
    }
}
Now replace the default “Hello, World!” body text with this:

NavigationStack {
    Text("Hello, World!")
        .navigationTitle(title)
}
That at least makes each of the ProspectsView instances look slightly different so we can be sure the tabs are working correctly.

To make our code compile again we need to make sure that every ProspectsView initializer is called with a filter. So, change your preview code to this:

ProspectsView(filter: .none)
Then change the three ProspectsView instances in ContentView so they have filter: .none, filter: .contacted, and filter: .uncontacted respectively.

If you run the app now you’ll see it’s looking better. Now let's bring in some data…


Storing our data with SwiftData

Lots of apps are great candidates for SwiftData, and most of the time it takes surprisingly little work to get it all set up.

In our app we have a TabView that contains three instances of ProspectsView, and we want all three of those to work as different views on the same shared data. In SwiftData terms, this means they all access the same model context, but using slightly different queries.

So, start by making a new Swift file called Prospect.swift, replacing its Foundation import with SwiftData, then giving it this code:

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
}
Once you have that, just type in below the isContacted property to have Xcode autocomplete the initializer for you.

Remember, SwiftData's @Model macro can only be used on a class, but it means we can share instances of that object in several views to have them all kept up to date automatically.

Now that we have something to store, we can tell SwiftData to create a model container for it. This means going to HotProspectsApp.swift, giving it an import for SwiftData, then adding the modelContainer(for:) modifier like this:

WindowGroup {
    ContentView()
}
.modelContainer(for: Prospect.self)
That creates storage for our Prospect class, but also places a shared SwiftData model context into every SwiftUI view in our app, all with one line of code.

We want all our ProspectsView instances to share that model data, so they are all pointing to the same underlying data. This means adding two properties: one to access the model context that was just created for us, and one to perform a query for Prospect objects.

So, go ahead and open ProspectsView.swift, give it an import for SwiftData, then add these two new properties to the ProspectsView struct:

@Query(sort: \Prospect.name) var prospects: [Prospect]
@Environment(\.modelContext) var modelContext
Tip: If you intend to use Xcode's previews, add modelContainer(for: Prospect.self) to your preview code.

That really is all it takes – I don’t think there’s a way SwiftData could make this any easier.

Soon we’re going to be adding code to add prospects by scanning QR codes, but for now we’re going to add a navigation bar item that just adds test data and shows it on-screen.

Change the body property of ProspectsView to this:

NavigationStack {
    Text("People: \(prospects.count)")
        .navigationTitle(title)
        .toolbar {
            Button("Scan", systemImage: "qrcode.viewfinder") {
                let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                modelContext.insert(prospect)
            }
        }
}
Now you’ll see a “Scan” button on the first three views of our tab view, and tapping it adds a person to all three simultaneously – you’ll see the count increment no matter which button you tap.


Dynamically filtering our SwiftData query

Our basic SwiftData query looks like this:

@Query(sort: \Prospect.name) var prospects: [Prospect]
By default that will load all Prospect model objects, sorting them by name, and while that's fine for the Everyone tab, it's not enough for the other two.

In our app, we have three instances of ProspectsView that vary only according to the FilterType property that gets passed in from our tab view. We’re already using that to set the title of each view, but we can also use it to filter our query.

Yes, we already have a default query in place, but if we add an initializer we can override that when a filter is set.

Add this initializer to ProspectsView now:

init(filter: FilterType) {
    self.filter = filter

    if filter != .none {
        let showContactedOnly = filter == .contacted

        _prospects = Query(filter: #Predicate {
            $0.isContacted == showContactedOnly
        }, sort: [SortDescriptor(\Prospect.name)])
    }
}
We've looked at creating queries manually previously, but there is one line that really stands out:

let showContactedOnly = filter == .contacted 
If that made you do a double take, break it down into two parts. First, this check:

filter == .contacted 
That will return true if filter is equal to .contacted, or false otherwise. And now this part:

let showContactedOnly =
That will assign the result of filter == .contacted to a new constant called showContactedOnly. So, if we read the whole line, it means "set showContactedOnly to true if our filter is set to .contacted." This makes our SwiftData predicate easy, because we can compare that constant directly against isContacted.

With that initializer in place, we can now create a List to loop over the resulting array. This will show both the title and email address for each prospect using a VStack – replace the existing text view in ProspectsView with this:

List(prospects) { prospect in
    VStack(alignment: .leading) {
        Text(prospect.name)
            .font(.headline)
        Text(prospect.emailAddress)
            .foregroundStyle(.secondary)
    }
}

If you run the app again you’ll see things are starting to look much better.