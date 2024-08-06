Project 3, part 2

Albert Einstein once said, “any fool can know; the point is to understand,” and this project was specifically about giving you a deeper understanding of what makes SwiftUI tick. After all, you’ll be spending the next 76 days working with it, so it’s a good idea to make sure your foundations are rock solid before moving on.

I could have said to you “SwiftUI uses structs for views” or “SwiftUI uses some View a lot”, and in fact did say exactly that to begin with when it was all you needed to know. But now that you’re progressing beyond the basics, it’s important to feel comfortable with what you’re using – to eliminate the nagging sense that you don’t quite get what something is for when you look at your code.

So much of Swift was built specifically for SwiftUI, so don’t be worried if you’re looking at some of the features and thinking they are way beyond your level. If you think about it, they were well above everyone’s level until Swift shipped with them!

Today you should work through the wrap up chapter for project 3, complete its review, then work through all three of its challenges.



Views and modifiers: Wrap up

These technique projects are designed to dive deep into specific SwiftUI topics, and I hope you’ve learned a lot about views and modifiers here – why SwiftUI uses structs for views, why some View is so useful, how modifier order matters, and much more.

Views and modifiers are the fundamental building blocks of any SwiftUI app, which is why I wanted to focus on them so early in this course. View composition is particularly key, as it allows to build small, reusable views that can be assembled like bricks into larger user interfaces.

Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:

Go back to project 1 and use a conditional modifier to change the total amount text view to red if the user selects a 0% tip.
Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view.