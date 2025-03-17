Project 16, part 3

Today we’ll be looking at three important features: list row swipe actions in SwiftUI, notifications in iOS, and Swift package dependencies in Xcode. These are three more really key features for app developers to master, and I hope you’ll find that all of them are relatively easy to learn.

List row swipe actions – those buttons that appear when you swipe on a row in iOS – allow us to add extra actions for rows in our layouts. This is a great way to avoid adding clutter to your UI, but I want you to exercise caution when doing so. Scott Belsky, previously a VP at Adobe and now venture capitalist, once said that there’s one rule for designing a good user experience: “more options, more problems.”

So, by all means add extra functionality to your UI, but always think about discoverability. After all, if the user can’t find your actions they might as well not exist!

Today you have three topics to work through, in which you’ll learn about swipe actions, local notifications, Swift package dependencies.


Adding custom row swipe actions to a List

iOS apps have had “swipe to delete” functionality for as long as I can remember, but in more recent years they’ve grown in power so that list rows can have multiple buttons, often on either side of the row. We get this full functionality in SwiftUI using the swipeActions() modifier, which lets us register one or more buttons on one or both sides of a list row.

By default buttons will be placed on the right edge of the row, and won’t have any color, so this will show a single gray button when you swipe from right to left:

List {
    Text("Taylor Swift")
        .swipeActions {
            Button("Send message", systemImage: "message") {
                print("Hi")
            }
        }
}
You can customize the edge where your buttons are placed by providing an edge parameter to your swipeActions() modifier, and you can customize the color of your buttons either by adding a tint() modifier to them with a color of your choosing, or by attaching a button role.

So, this will display one button on either side of our row:

List {
    Text("Taylor Swift")
        .swipeActions {
            Button("Delete", systemImage: "minus.circle", role: .destructive) {
                print("Deleting")
            }
        }
        .swipeActions(edge: .leading) {
            Button("Pin", systemImage: "pin") {
                print("Pinning")
            }
            .tint(.orange)
        }
}
Like context menus, swipe actions are by their very nature hidden to the user by default, so it’s important not to hide important functionality in them. We’ll be using them both in this app, which should hopefully give you the chance to compare and contrast them directly!


Scheduling local notifications

iOS has a framework called UserNotifications that does pretty much exactly what you expect: lets us create notifications to the user that can be shown on the lock screen. We have two types of notifications to work with, and they differ depending on where they were created: local notifications are ones we schedule locally, and remote notifications (commonly called push notifications) are sent from a server somewhere.

Remote notifications require a server to work, because you send your message to Apple’s push notification service (APNS), which then forwards it to users. But local notifications are nice and easy in comparison, because we can send any message at any time as long as the user allows it.

To try this out, start by adding an extra import near the top of ContentView.swift:

import UserNotifications
Next we’re going to put in some basic structure that we’ll fill in with local notifications code. Using local notifications requires asking the user for permission, then actually registering the notification we want to show. We’ll place each of those actions into separate buttons inside a VStack, so please put this inside your ContentView struct now:

VStack {
    Button("Request Permission") {
        // first
    }

    Button("Schedule Notification") {
        // second
    }
}
OK, that’s our setup complete so let’s turn our focus to the first of two important pieces of work: requesting authorization to show alerts. Notifications can take a variety of forms, but the most common thing to do is ask for permission to show alerts, badges, and sounds – that doesn’t mean we need to use all of them at the same time, but asking permission up front means we can be selective later on.

When we tell iOS what kinds of notifications we want, it will show a prompt to the user so they have the final say on what our app can do. When they make their choice, a closure we provide will get called and tell us whether the request was successful or not.

So, replace the // first comment with this:

UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
    if success {
        print("All set!")
    } else if let error {
        print(error.localizedDescription)
    }
}
If the user grants permission, then we’re all clear to start scheduling notifications. Even though notifications might seem simple, Apple breaks them down into three parts to give it maximum flexibility:

The content is what should be shown, and can be a title, subtitle, sound, image, and so on.
The trigger determines when the notification should be shown, and can be a number of seconds from now, a date and time in the future, or a location.
The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
When you’re just learning notifications the easiest trigger type to use is UNTimeIntervalNotificationTrigger, which lets us request a notification to be shown in a certain number of seconds from now. So, replace the // second comment with this:

let content = UNMutableNotificationContent()
content.title = "Feed the cat"
content.subtitle = "It looks hungry"
content.sound = UNNotificationSound.default

// show this notification five seconds from now
let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

// choose a random identifier
let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

// add our notification request
UNUserNotificationCenter.current().add(request)
If you run your app now, press the first button to request notification permission, then press the second to add an actual notification.

Now for the important part: once your notification has been added press Cmd+L in the simulator to lock the screen. After a few seconds have passed the device should wake up with a sound, and show our message – nice!


Adding Swift package dependencies in Xcode

Everything we’ve been coding so far is stuff we’ve built from scratch, so you can see exactly how it works and apply those skills to your own projects. Sometimes, though, writing something from scratch is risky: perhaps the code is complex, perhaps it’s easy to get wrong, perhaps it changes often, or any other myriad of reasons, which is why dependencies exist – the ability to fetch third-party code and use it in our projects.

Xcode comes with a dependency manager built in, called Swift Package Manager (SPM). You can tell Xcode the URL of some code that’s stored online, and it will download it for you. You can even tell it what version to download, which means if the remote code changes sometime in the future you can be sure it won’t break your existing code.

To try this out, I created a simple Swift package that you can import into any project. This adds a small extension to Swift’s Sequence type (which Array, Set, Dictionary, and even ranges all conform to) that pulls out a number of random items at the same time.

Anyway, the first step is to add the package to our project: go to the File menu and choose Add Package Dependencies. For the URL enter https://github.com/twostraws/SamplePackage, which is where the code for my example package is stored. Xcode will fetch the package, read its configuration, and show you options asking which version you want to use. The default will be “Version – Up to Next Major”, which is the most common one to use and means if the author of the package updates it in the future then as long as they don’t introduce breaking changes Xcode will update the package to use the new versions.

The reason this is possible is because most developers have agreed a system of semantic versioning (SemVer) for their code. If you look at a version like 1.5.3, then the 1 is considered the major number, the 5 is considered the minor number, and the 3 is considered the patch number. If developers follow SemVer correctly, then they should:

Change the patch number when fixing a bug as long as it doesn’t break any APIs or add features.
Change the minor number when they added features that don’t break any APIs.
Change the major number when they do break APIs.
This is why “Up to Next Major” works so well, because it should mean you get new bug fixes and features over time, but won’t accidentally switch to a version that breaks your code.

Anyway, we’re done with our package, so click Add Package twice to make Xcode add it to the project. You should see it appear in the project navigator, under “Swift Package Dependencies”.

To try it out, open ContentView.swift and add this import to the top:

import SamplePackage
Yes, that external dependency is now a module we can import anywhere we need it.

And now we can try it in our view. For example, we could simulate a simple lottery by making a range of numbers from 1 through 60, picking 7 of them, converting them to strings, then joining them into a single string. To be concise, this will need some code you haven’t seen before so I’m going to break it down.

First, replace your current ContentView with this:

struct ContentView: View {        
    var body: some View {
        Text(results)
    }
}
Yes, that won’t work because it’s missing results, but we’re going to fill that in now.

First, creating a range of numbers from 1 through 60 can be done by adding this property to ContentView:

let possibleNumbers = 1...60
Second, we’re going to create a computed property called results that picks seven numbers from there and makes them into a single string, so add this property too:

var results: String {
    // more code to come
}
Inside there we’re going to select seven random numbers from our range, which can be done using the extension you got from my SamplePackage framework. This provides a random() method that accepts an integer and will return up to that number of random elements from your sequence, in a random order. Lottery numbers are usually arranged from smallest to largest, so we’re going to sort them.

So, add this line of code in place of // more code to come:

let selected = possibleNumbers.random(7).sorted()
Next, we need to convert that array of integers into strings. This only takes one line of code in Swift, because sequences have a map() method that lets us convert an array of one type into an array of another type by applying a function to each element. In our case, we want to initialize a new string from each integer, so we can use String.init as the function we want to call.

So, add this line after the previous one:

let strings = selected.map(String.init)
At this point strings is an array of strings containing the seven random numbers from our range, so the last step is to join them all together into a single string. Add this final line to the property now:

return strings.formatted()
And that completes our code: the text view will show the value inside results, which will go ahead and pick random numbers, sort them, stringify them, then join them with commas.

PS: You can read the source code for my simple extension right inside Xcode – just open the Sources > SamplePackage group and look for SamplePackage.swift. You’ll see it doesn’t do much!

That finishes our final technique required for this project, so please reset your code to its original state.