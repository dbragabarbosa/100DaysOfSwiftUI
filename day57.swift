Project 12, part 1

In this technique project we’re going to explore how SwiftData and SwiftUI work together to help us build great apps. I already introduced you to the topic in project 11, but here we’re going to be going into more detail: custom managed object subclasses, ensuring uniqueness, and more.

American entrepreneur Jim Rohn once said, “success is neither magical nor mysterious – success is the natural consequence of consistently applying the basic fundamentals.” SwiftData is absolutely one of those basic fundamentals – you certainly won’t use it in every project, but understanding how it works and how to make the most of it will make you a better app developer.

Today you have three topics to work through, in which you’ll learn how to edit SwiftData objects with SwiftUI, and also how to filter your data using #Predicate, and more.


SwiftData: Introduction

This technique project is going to explore SwiftData in more detail, starting with a summary of some basic techniques then building up to tackling some more complex problems.

As you'll see, SwiftData really pushes hard on advanced features of both Swift and SwiftUI, all to help make it easy for us to store data efficiently. It's not always easy, though, and there are a few places that take quite a bit of thinking to use properly.

We have lots to explore, so please create a fresh project where we can try it out. Call it “SwiftDataProject” and not just “SwiftData” because that will cause Xcode to get confused.

Make sure you do not enable SwiftData for storage. Again, we'll be building this from scratch so you can see how it all works.

All set? Let’s go!


Editing SwiftData model objects

SwiftData's model objects are powered by the same observation system that makes @Observable classes work, which means changes to your model objects are automatically picked up by SwiftUI so that our data and our user interface stay in sync.

This support extends to the @Bindable property wrapper we looked at previously, which means we get delightfully straightforward object editing.

To demonstrate this, we could create a simple User class with a handful of properties. Create a new file called User.swift, add an import at the top for SwiftData, then give it this code:

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
Now we can create a model container and model context for that by adding another import SwiftData in the App struct file then using modelContainer() like this:

WindowGroup {
    ContentView()
}
.modelContainer(for: User.self)
When it comes to editing User objects, we would create a new view called something like EditUserView, then use the @Bindable property wrapper to create bindings for it. So, something like this:

struct EditUserView: View {
    @Bindable var user: User

    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}
That's identical to how we used a regular @Observable class, and yet SwiftData still takes care of automatically writing out all our changes to permanent storage – it's completely transparent to us.

Important: If you want to use Xcode's previews with this, you need to pass a sample object in, which in turn means creating a custom configuration and container. First add an import for SwiftData, then change your preview to this:

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
We could make a really simple user editing app out of this by adding a new user when a button is pressed, then using programmatic navigation to take the app straight to the new user for editing.

Let's build this step by step. First, open ContentView.swift and an import for SwiftData, then add properties to get access to the model context, load all our User objects, then store a path we can bind to a NavigationStack:

@Environment(\.modelContext) var modelContext
@Query(sort: \User.name) var users: [User]
@State private var path = [User]()
Replace the default body property with this:

NavigationStack(path: $path) {
    List(users) { user in
        NavigationLink(value: user) {
            Text(user.name)
        }
    }
    .navigationTitle("Users")
    .navigationDestination(for: User.self) { user in
        EditUserView(user: user)
    }
}
And now we just need a way to add users. If you think about it, adding and editing are very similar, so the easiest thing to do here is to create a new User object with empty properties, insert it into the model context, then immediately navigate to that by adjusting the path property.

Add this extra modifier below the two navigation modifiers:

.toolbar {
    Button("Add User", systemImage: "plus") {
        let user = User(name: "", city: "", joinDate: .now)
        modelContext.insert(user)
        path = [user]
    }
}
And that works! In fact, it's pretty much the same approach Apple's own Notes app takes, although they add the extra step of automatically deleting the note if you exit the editing view without actually adding any text.

As you can see, editing with SwiftData objects is no different from editing regular @Observable classes – just with the added bonus that all our data is loaded and saved neatly!


Filtering @Query using Predicate

You've already seen how @Query can be used to sort SwiftData objects in a particular order, but it can also be used to filter that data using a predicate – a series of tests that get applied to your data, to decide what to return.

The syntax for this is a little odd at first, mostly because this is actually another macro behind the scenes - Swift converts our predicate code into a series of rules it can apply to the underlying database that stores all of SwiftData's objects.

Let's start with something simple, using the same User model we used previously:

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
Now we can add a couple of properties to ContentView that can show all the users we have:

@Environment(\.modelContext) var modelContext
@Query(sort: \User.name) var users: [User]
And finally, we can show all those users in a list, and we'll also add a button to add some sample data easily:

NavigationStack {
    List(users) { user in
        Text(user.name)
    }
    .navigationTitle("Users")
    .toolbar {
        Button("Add Samples", systemImage: "plus") {
            let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
            let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
            let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
            let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

            modelContext.insert(first)
            modelContext.insert(second)
            modelContext.insert(third)
            modelContext.insert(fourth)
        }
    }
}
Tip: Those join dates represent some number of days in the past or future, which gives us some interesting data to work with.

When working with sample data like this, it's helpful to be able to delete existing data before adding the sample data. To do that, add the following code before the let first = line:

try? modelContext.delete(model: User.self)
That tells SwiftData to tell all existing model objects of the the type User, which means the database is clear before we add the sample users.

To finish our little sample app, we just need to make sure the App struct uses the modelContainer() modifier to set up SwiftData correctly:

WindowGroup {
    ContentView()
}
.modelContainer(for: User.self)
Now go ahead and run the app, then press the + button to insert four users.

You can see they appear in alphabetical order, because that's what we asked for in our @Query property.

Now let's try filtering that data, so that we only show users whose name contains a capital R. To do this we pass a filter parameter into @Query, like this:

@Query(filter: #Predicate<User> { user in
    user.name.contains("R")
}, sort: \User.name) var users: [User]
Let's break that down:

The filter starts with #Predicate<User>, which means we're writing a predicate (a fancy word for a test we're going to apply).
That predicate gives us a single user instance to check. In practice that will be called once for each user loaded by SwiftData, and we need to return true if that user should be included in the results.
Our test checks whether the user's name contains the capital letter R. If it does, the user will be included in the results, otherwise they won't.
So, when you run the code now you'll see that both Rosa and Roy appear in our list, but Ed and Johnny are left off because their names don't contain a capital R. The contains() method is case-sensitive: it considers capital R and lowercase R to be difference, which is why it didn't find the "r" in "Ed Sheeran".

That works great for a simple test of predicates, but it's very rare users actually care about capital letters – they usually just want to write a few letters, and look for that match anywhere in the results, ignoring case.

For this purpose, iOS gives us a separate method localizedStandardContains(). This also takes a string to search for, except it automatically ignores letter case, so it's a much better option when you're trying to filter by user text.

Here's how it looks:

@Query(filter: #Predicate<User> { user in
    user.name.localizedStandardContains("R")
}, sort: \User.name) var users: [User]
In our little test data that means we'll see three out of the four users, because those three have a letter "r" somewhere in their name.

Now let's go a step further: let's upgrade our filter so that it matches people who have an "R" in their name and who live in London:

@Query(filter: #Predicate<User> { user in
    user.name.localizedStandardContains("R") &&
    user.city == "London"
}, sort: \User.name) var users: [User]
That uses Swift's "logical and" operator, which means both sides of the condition must be true in order for the whole condition to be true – the user's name must contain an "R" and they must live in London.

If we only had the first check for the letter R, then Ed, Rosa, and Roy would match. If we only had the second check for living in London, then Ed, Roy, and Johnny would match. Putting both together means that only Ed and Roy match, because they are the only two with an R somewhere in their name who also live in London.

You can add more and more checks like this, but using && gets a bit confusing. Fortunately, these predicates support a limited subset of Swift expressions that make reading a little easier.

For example, we could rewrite our current predicate to this:

@Query(filter: #Predicate<User> { user in
    if user.name.localizedStandardContains("R") {
        if user.city == "London" {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}, sort: \User.name) var users: [User]
Now, you might be thinking that's a little verbose – that could remove both else blocks and just end with return true, because if the user actually matched the predicate the return true would already have been hit.

Here's how that would look:

@Query(filter: #Predicate<User> { user in
    if user.name.localizedStandardContains("R") {
        if user.city == "London" {
            return true
        }
    }

    return false
}, sort: \User.name) var users: [User]
Sadly that code isn't actually valid, because even though it looks like we're executing pure Swift code it's important you remember that doesn't actually happen – the #Predicate macro actually rewrites our code to be a series of tests it can apply on the database, which doesn't use Swift internally.

To see what's happening internally, press undo a few times to get the original version with two else blocks. Now right-click on #Predicate and select Expand Macro, and you'll see a huge amount of code appears. Remember, this is the actual code that gets built and run – it's what our #Predicate gets converted into.

So, that's just a little of how #Predicate works, and why some predicates you might try just don't quite work how you expect – this stuff looks easy, but it's really complex behind the scenes!