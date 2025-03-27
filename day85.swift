Project 16, part 7

The British mathematician Isaac Newton once said, “if I have seen further it is by standing on the shoulders of giants.” That’s a pretty humble view to take for someone who is one of the most influential scientists of all time!

I think the same is very much true of working with Apple’s APIs. Could I have written Create ML myself? Or UIKit? Or MapKit, or Core Image, or UserNotifications? Maybe one of them, and perhaps if I had a lot of help two of them, but it’s pretty unlikely.

Fortunately, I don’t need to, and neither do you: Apple’s vast collection of APIs means we too are standing on the shoulders of giants. Even things like handling dates well is a huge amount of work, but it’s something we don’t need to worry about because Apple already solved it for us.

So, seize this amazing opportunity! Build something great that combines two, three, or more frameworks and then add your own customizations on top. It’s those final steps that really set your app apart from the pack, and where you add your own value.


Hot Prospects: Wrap up

This was our largest project yet, but the end result is another really useful app that could easily form the starting point for a real conference. Along the way we also learned about custom environment objects, TabView, Result, image interpolation, context menus, local notifications, Swift package dependencies, and so much more – it’s been packed!

We’ve explored several of Apple’s other frameworks now – Core ML, MapKit, Core Image, and now UserNotifications – so I hope you’re getting a sense of just how much we can build just by relying on all the work Apple has already done for us.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
Add an editing screen, so users can adjust the name and email address of someone they scanned previously. (Tip: Use the simple form of NavigationLink rather than navigationDestination(), to avoid your list selection code confusing the navigation link.)
Allow users to customize the way contacts are sorted – by name or by most recent.