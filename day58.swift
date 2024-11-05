Project 12, part 2

Today we’re going to push into more advanced SwiftData techniques – the things that really set apps apart when it comes to functionality and usefulness. Some of these will take a little time to learn, particularly because as we push more into SwiftData you’ll start to see how it relies heavily on macros.

Stick with it! As Maya Angelou said, “all great achievements require time” – it will take some work to understand all that SwiftData is doing for us here, but it will pay off and I feel confident you’ll enjoy using SwiftData and SwiftUI together in your apps.

Today you have three topics to work through, in which you’ll learn about NSPredicate, changing fetch requests dynamically, creating relationships, and more.

At one point you’ll see me say you’ve reached a good point and can move on to the next tutorial, but if you continue beyond that point we’ll explore some more advanced topics. To be quite clear, the extra work is optional: please don’t do it if you’re tight on time, or just want to get the fundamentals down.


Dynamically sorting and filtering @Query with SwiftUI

Now that you've seen a little of how SwiftData's #Predicate works, the next question you're likely to have is "how can I make it work with user input?" The answer is… it's complicated. I'll show you how it's done, and also how the same technique can be used to dynamically adjust sorting, but it's going to take you a little while to remember how it's done – hopefully Apple can improve this in the future!

If we build on the previous SwiftData code we looked at, each user object had a different joinDate property, some in the past and some in the future. We also had a List showing the results of a query:

List(users) { user in
    Text(user.name)
}
What we're going to do is move that list out into a separate view – a view specifically for running the SwiftData query and showing its results, then make it optionally show all users or only users who are joining in the future.

So, create a new SwiftUI view call UsersView, give it a SwiftData import, then move the List code there without moving any of its modifier – just the code shown above.

Now that we're displaying SwiftData results in UsersView, we need to add an @Query property there. This should not use a sort order or predicate – at least not yet. So, add this property there:

@Query var users: [User]
And once you add a modelContainer() modifier to the preview, your UsersView.swift code should look like this:

import SwiftData
import SwiftUI

struct UsersView: View {
    @Query var users: [User]

    var body: some View {
        List(users) { user in
            Text(user.name)
        }
    }
}

#Preview {
    UsersView()
        .modelContainer(for: User.self)
}
Before we're done with this view, we need a way to customize the query that gets run. As things stand, just using @Query var users: [User] means SwiftData will load all the users with no filter or sort order, but really we want to customize one or both of those from ContentView – we want to pass in some data.

This is best done by passing a value into the view using an initializer, then using that to create the query. As I said earlier, our goal is to either show all users, or just show users who are joining in the future. So, we'll accomplish that by passing in a minimum join date, and ensuring that all users join at least after that date.

Add this initializer to UsersView now:

init(minimumJoinDate: Date) {
    _users = Query(filter: #Predicate<User> { user in
        user.joinDate >= minimumJoinDate
    }, sort: \User.name)
}
That's mostly code you're used to, but notice that there's an underscore before users. That's intentional: we aren't trying to change the User array, we're trying to change the SwiftData query that produces the array. The underscore is Swift's way of getting access to that query, which means we're creating the query from whatever date gets passed in.

At this point we're done with UsersView, so now back in ContentView we need to delete the existing @Query property and replace it with code to toggle some kind of Boolean, and pass its current value into UsersView.

First, add this new @State property to ContentView:

@State private var showingUpcomingOnly = false
And now replace the List code in ContentView – again, not including its modifiers – with this:

UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast)
That passes one of two dates into UsersView: when our Boolean property is true we pass in .now so that we only show users who will join after the current time, otherwise we pass in .distantPast, which is at least 2000 years in the past – unless our users include some Roman emperors, they will all have join dates well after this and so all users will be shown.

All that remains now is to add a way to toggle that Boolean inside ContentView – add this to the ContentView toolbar:

Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
    showingUpcomingOnly.toggle()
}
That changes the button's label so that it always reflect what happens when it's next pressed.

That completes all the work, so if you run the app now you'll see you can change the list of users dynamically.

Yes, it's quite a bit of work, but as you can see it works brilliantly and you can apply the same technique to other kinds of filtering too.

This same approach works equally well with sorting data: we can control an array of sort descriptors in ContentView, then pass them into the initializer of UsersView to have them adjust the query.

First, we need to upgrade the UsersView initializer so that it accepts some kind of sort descriptor for our User class. This uses Swift's generics again: the SortDescriptor type needs to know what it's sorting, so we need to specify User inside angle brackets.

Modify the UsersView initializer to this:

init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
    _users = Query(filter: #Predicate<User> { user in
        user.joinDate >= minimumJoinDate
    }, sort: sortOrder)
}
You'll also need to update your preview code to pass in a sample sort order, so that your code compiles properly:

UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
    .modelContainer(for: User.self)
Back in ContentView we another new property to store the current sort order. We'll make this use name then join date, which seems like a sensible default:

@State private var sortOrder = [
    SortDescriptor(\User.name),
    SortDescriptor(\User.joinDate),
]
We can then pass that into UsersView just like we did with the join date:

UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
And finally we need a way to adjust that array dynamically. One option is to use a Picker showing two options: Sort by Name, and Sort by Join Date. That in itself isn't tricky, but how do we attach a SortDescriptor array to each option?

The answer lies in a useful modifier called tag(), which lets us attach specific values of our choosing to each picker option. Here that means we can literally make the tag of each option its own SortDescriptor array, and SwiftUI will assign that tag to the sortOrder property automatically.

Try adding this to the toolbar:

Picker("Sort", selection: $sortOrder) {
    Text("Sort by Name")
        .tag([
            SortDescriptor(\User.name),
            SortDescriptor(\User.joinDate),
        ])

    Text("Sort by Join Date")
        .tag([
            SortDescriptor(\User.joinDate),
            SortDescriptor(\User.name)
        ])
}
When you run the app now, chances are you won't see what you expected. Depending on which device you're using, rather than showing "Sort" as a menu with options inside, you'll either see:

Three dots in a circle, and pressing that reveals the options.
"Sort by Name" shown directly in the navigation bar, and tapping that lets you change to Join Date.
Both options aren't great, but I want to use this chance to introduce another useful SwiftUI view called Menu. This lets you create menus in the navigation bar, and you can place buttons, pickers, and more inside there.

In this case, if we wrap our current Picker code with a Menu, we'll get a much better result. Try this:

Menu("Sort", systemImage: "arrow.up.arrow.down") {
    // current picker code
}
Try it again and you'll see it's much better, and more important both our dynamic filtering and sorting now work great!


Relationships with SwiftData, SwiftUI, and @Query

SwiftData allows us to create models that reference each other, for example saying that a School model has an array of many Student objects, or an Employee model stores a Manager object.

These are called relationships, and they come in all sorts of forms. SwiftData does a good job of forming these relationships automatically as long as you tell it what you want, although there's still some room for surprises!

Let's try them out now. We already have the following User model:

@Model
class User {
    var name: String
    var city: String
    var joinDate: Date

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
We could extend that to say that each User can have an array of jobs attached to them – tasks they need to complete as part of their work. To do that, we first need to create a new Job model, like this:

@Model
class Job {
    var name: String
    var priority: Int
    var owner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
Notice how I've made the owner property refer directly to the User model – I've told SwiftData explicitly that the two models are linked together.

And now we can adjust the User model to create the jobs array:

var jobs = [Job]()
So, jobs have an owner, and users have an array of jobs – the relationship goes both ways, which is usually a good idea because it makes your data easier to work with.

That array will start working immediately: SwiftData will load all the jobs for a user when they are first requested, so if they are never used at all it will just skip that work.

Even better, the next time our app launches SwiftData will silently add the jobs property to all its existing users, giving them an empty array by default. This is called a migration: when we add or delete properties in our models, as our needs evolve over time. SwiftData can do simple migrations like this one automatically, but as you progress further you'll learn how you can create custom migrations to handle bigger model changes.

Tip: When we used the modelContainer() modifier in our App struct, we passed in User.self so that SwiftData knew to set up storage for that model. We don't need to add Job.self there because SwiftData can see there's a relationship between the two, so it takes care of both automatically.

You don't need to change the @Query you use to load your data, just go ahead and use the array like normal. For example, we could show a list of users and their job count like this:

List(users) { user in
    HStack {
        Text(user.name)

        Spacer()

        Text(String(user.jobs.count))
            .fontWeight(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}
If you want to see it work with some actual data, you can either create a SwiftUI view to create new Job instances for the selected user, but for testing purposes we can take a little shortcut and add some sample data.

First add a property to access the active SwiftData model context:

@Environment(\.modelContext) var modelContext
And now add a method such as this one, to create some sample data:

func addSample() {
    let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
    let job1 = Job(name: "Organize sock drawer", priority: 3)
    let job2 = Job(name: "Make plans with Alex", priority: 4)

    modelContext.insert(user1)

    user1.jobs.append(job1)
    user1.jobs.append(job2)
}
Again, notice how almost all that code is just regular Swift – only one line actually relates to SwiftData.

I encourage you to try experimenting here a little bit. Your starting point should always be to assume that working with your data is just like working with a regular @Observable class – just let SwiftData do its thing until you have a reason to do otherwise!

There is one small catch, though, and it's worth covering before we move on: we've linked User and Job so that one user can have lots of jobs to do, but what happens if we delete a user?

The answer is that all their jobs remain intact – they don't get deleted. This is a smart move from SwiftData, because you don't get any surprise data loss.

If you specifically want all a user's job objects to be deleted at the same time, we need to tell SwiftData that. This is done using an @Relationship macro, providing it with a delete rule that describes how Job objects should be handled when their owning User is deleted.

The default delete rule is called .nullify, which means the owner property of each Job object gets set to nil, marking that they have no owner. We're going to change that to be .cascade, which means deleting a User should automatically delete all their Job objects. It's called cascade because the delete keeps going for all related objects – if our Job object had a locations relationship, for example, then those would also be deleted, and so on.

So, change the jobs property in User to this:

@Relationship(deleteRule: .cascade) var jobs = [Job]()
And now we're being explicit, which means we don't leave any hidden Job objects around when deleting a user – much better!


Syncing SwiftData with CloudKit

SwiftData can sync all your user's data with iCloud, and best of all it often takes absolutely no code.

Before you start, there's an important warning: syncing data to iCloud requires an active Apple developer account. If you don't have one, the following will not work.

Still here? Okay, in order to sync data from local SwiftData storage up to iCloud, you need to enable the iCloud capability for your app. We haven't customized our app capabilities before, so this step is new.

First, click the "SwiftDataTest" app icon at the top of your project navigator. This should be directly above the SwiftDataTest group.

Second, select "SwiftDataTest" under the "TARGETS" list. You should see a bunch of tabs appear: General, Signing & Capabilities, Resource Tags, Info, and more. We want Signing & Capabilities, so please select that now.

Third, press "+ CAPABILITY" and select iCloud, which should make iCloud appear in the list of active capabilities – you'll see three services are possible, a "CloudKit Console" button, and more.

Fourth, check the box marked CloudKit, which is what allows our app to store SwiftData information in iCloud. You'll also need to press the + button to add a new CloudKit container, which configures where the data is actually stored in iCloud. You should use your app's bundle ID prefix with "iCloud." here, for example iCloud.com.hackingwithswift.swiftdatatest.

Fifth, press "+ CAPABILITY" again, then add the Background Modes capability. This has a whole bunch of configuration options, but you only need to check the "Remote Notifications" box – that allows the app to be notified when data changes in iCloud, so it can be synchronized locally.

And that's it – your app is all set to use iCloud for synchronizing SwiftData.

Perhaps.

You see, SwiftData with iCloud has a requirement that local SwiftData does not: all properties must be optional or have default values, and all relationship must be optional. The first of those is a small annoyance, but the second is a much bigger annoyance – it can be quite disruptive for your code.

However, they are requirements and not merely suggestions. So, in the case of Job we'd need to adjust its properties to this:

var name: String = "None"
var priority: Int = 1
var owner: User?
And for User, we'd need to use this:

var name: String = "Anonymous"
var city: String = "Unknown"
var joinDate: Date = Date.now
@Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]()
Important: If you don't make these changes, iCloud will simply not work. If you look through Xcode's log – and CloudKit loves to write to Xcode's log – and scroll near the very top, SwiftData should try to warn you when any properties have stopped iCloud syncing from working correctly.

Once you've adjusted your models, you now need to change any code to handle the optionality correctly. For example, adding jobs to a user might use optional chaining like this:

user1.jobs?.append(job1)
user1.jobs?.append(job2)
And reading the count of a user's jobs might use optional chaining and nil coalescing, like this:

Text(String(user.jobs?.count ?? 0))
I'm not a particularly big fan of scattering that kind of code everywhere around a project, so if I'm using jobs regularly I'd much rather create a read-only computed property called unwrappedJobs or similar – something that either returns jobs if it has a value, or an empty array otherwise, like this:

var unwrappedJobs: [Job] {
    jobs ?? []
}
It's a small thing, but it does help smooth over the rest of your code, and making it read-only prevents you trying to change a missing array by accident.

Important: Although the simulator is created at testing local SwiftData applications, it's pretty terrible at testing iCloud – you might find your data isn't synchronized correctly, quickly, or even at all. Please use a real device to avoid problems!