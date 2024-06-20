Project 1, part three

You just finished building your first SwiftUI app, and all being well you were surprised by how easy it was. You might even be wondering why I spent so long talking about structs, closures, optionals, and more, when really we ended up doing some fairly simple code.

Well, first keep in mind that this is only the first project, and I kept it deliberately simple so you can get moving quickly with your own code. Trust me, things will get more complex – in fact tomorrow you’ll be set free with your own project, so don’t get too comfortable!

Second, though, you have been using advanced features. In fact, without realizing it you’ve actually been using all the most advanced features Swift has to offer. We’ve actually been using closures all the time – just look at code like this:

Picker("Tip percentage", selection: $tipPercentage) {
    ForEach(tipPercentages, id: \.self) {
        Text($0, format: .percent)
    }
}
Did you notice that $0 in there? That’s shorthand syntax for closure parameters, because we’re inside a closure.

Anyway, now that the app is complete it’s time for a quick recap what you learned, a short test to make sure you’ve understood what was taught, then your first challenges – exercises designed to get you writing your own code as quickly as possible.

I do not provide the answers to these challenges. This is intentional: I want you to figure it out by yourself rather than just looking at someone else’s work. As Marvin Phillips said, “the difference between try and triumph is a little umph.”

Today you should work through the wrap up chapter for project 1, complete its review, then work through all three of its challenges.



WeSplit: Wrap up

You’ve reached the end of your first SwiftUI app: good job! We’ve covered a lot of ground, but I’ve also tried to go nice and slowly to make sure it all sinks in – we’ve got lots more to cover in future projects, so taking a little extra time now is okay.

In this project you learn about the basic structure of SwiftUI apps, how to build forms and sections, creating navigation stacks and navigation bar titles, how to store program state with the @State and @FocusState property wrappers, how to create user interface controls like TextField and Picker, and how to create views in a loop using ForEach. Even better, you have a real project to show off for your efforts.

Review what you learned
Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:

Add a header to the third section, saying “Amount per person”
Add another section showing the total amount for the check – i.e., the original amount plus tip value, without dividing by the number of people.
Change the tip percentage picker to show a new screen rather than using a segmented control, and give it a wider range of options – everything from 0% to 100%. Tip: use the range 0..<101 for your range rather than a fixed array.