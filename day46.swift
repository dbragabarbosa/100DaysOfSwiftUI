Project 9, part 4

That’s another project finished, and at this point you’ve had a taste of almost all of SwiftUI’s navigation APIs. Chances are you want to get back to building apps, but please take a moment to pause and review what you’ve learned – you might not use all of it for some time, but it’s important you at least remember what was covered so you can refer back to it later.

So, today you have another review to test what you remember, and also some challenges to get you coding yourself. As always these challenges don’t come with solutions by me, but that’s the point – as American NFL player Troy Polamalu once said, “I’ve always had the mind-set that no one can challenge me better than myself.”

You have free rein to solve them however you want and in whatever time you want, and you might sail through problem-free. On the other hand, perhaps in completing them you’ll spot a few places where your knowledge was a bit shaky – the only way you’ll know is if you try.

Today you should work through the wrap up chapter for project 9, complete its review, then work through all three of its challenges.


Navigation: Wrap up

I hope this technique project helped you feel more comfortable with navigation in SwiftUI, because it lies at the core of practically every app you'll build.

Yes, some bits like Hashable might not make complete sense at first, but for the time being all you really need to know is that it's a requirement – Swift can do most of the work for us when we use structs, so just adding protocols such as Hashable, Codable, and Equatable is usually enough.

Later on we'll be looking at another style of navigation that works better on larger devices, but for now you're done – great job!


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

1. Change project 7 (iExpense) so that it uses NavigationLink for adding new expenses rather than a sheet. (Tip: The dismiss() code works great here, but you might want to add the navigationBarBackButtonHidden() modifier so they have to explicitly choose Cancel.)

2. Try changing project 7 so that it lets users edit their issue name in the navigation title rather than a separate textfield. Which option do you prefer?

3. Return to project 8 (Moonshot), and upgrade it to use NavigationLink(value:). This means adding Hashable conformance, and thinking carefully how to use navigationDestination().