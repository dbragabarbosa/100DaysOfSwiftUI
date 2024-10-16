Project 8, part 4
You’ve now finished Moonshot, which is the first of our projects that started to get difficult – it took longer to explain, we used custom SwiftUI layouts, and I even snuck in a few advanced Swift features. Not all our future projects are going to be difficult, but it’s certainly going to be the case that they are more complex; there is more to them, which means the resulting apps are more interesting, and also more representative of real-world app building.

As the complexity rises so do the odds of making mistakes, and Swift is pretty unforgiving here – as you will undoubtedly have seen by now, even one small mistake on line 20 can result in a random error appearing on line 5, and this can be disheartening.

Well, I hope today’s quote will inspire you. I’ve chosen it specially for today for reasons best left to the reader, but it’s this: don’t panic! These sorts of problems are common, and the easiest way to solve them right now is to comment out whatever code you most recently added, and keep doing so until your code works. You can then slowly re-introduce code until you find the part that causes your compile to break, then fix it.

So, don’t panic – you can do this!

Today you should work through the wrap up chapter for project 8, complete its review, then work through all three of its challenges.


Moonshot: Wrap up

This app is the most complex one we’ve built so far. Yes, there are multiple views, but we also strayed away from lists and forms and into our own scrolling layouts, using containerRelativeFrame() to get precise sizes to make the most of our space.

But this was also the most complex Swift code we’ve written so far – generics are an incredibly powerful feature, and once you add in constraints you open up a huge range of functionality that lets you save time while also gaining flexibility.

You’re also now starting to see how useful Codable is: its ability to decode a hierarchy of data in one pass is invaluable, which is why it’s central to so many Swift apps.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

Add the launch date to MissionView, below the mission badge. You might choose to format this differently given that more space is available, but it’s down to you.
Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in MissionView is a great candidate, but if you followed my styling then you could also move the Rectangle dividers out too.
For a tough challenge, add a toolbar item to ContentView that toggles between showing missions as a grid and as a list.