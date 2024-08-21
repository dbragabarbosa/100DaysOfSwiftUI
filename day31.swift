Project 5, part 3

Dwayne “The Rock” Johnson once said, “success isn't always about greatness, it's about consistency. Consistent hard work leads to success; greatness will come.”

Obviously I want to get you towards SwiftUI greatness as fast and effectively as possible, but that takes a lot of consistency from you. To be fair, it is already day 31 and you keep coming back, so you’re fulfilling your part of the deal – well done!

With another project done, it’s time for you to take matters into your own hands. Yes, this is the “hard work” part of the project, where you need to complete some challenges without my help, and also pass a test to make sure what you’re learning is sinking in.

You can do this!

Today you should work through the wrap up chapter for project 5, complete its review, then work through all three of its challenges.



Word Scramble: Wrap up

This project was a last chance to review the fundamentals of SwiftUI before we move on to greater things with the next app. Still, we managed to cover some useful new things, not least List, onAppear, Bundle, fatalError(), UITextChecker, and more, and you have another app you can extend if you want to.

One thing I want to pick out before we finish is my use of fatalError(). If you read code from my own projects on GitHub, or read some of my more advanced tutorials, you’ll see that I rely on fatalError() a lot as a way of forcing code to shut down when something impossible has happened. The key to this technique – the thing that stops it from being recklessly dangerous – is knowing when a specific condition ought to be impossible. That comes with time and practice: there is no one quick list of all the places it’s a good idea to use fatalError(), and instead you’ll figure it out with experience.



Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:

Disallow answers that are shorter than three letters or are just our start word.
Add a toolbar button that calls startGame(), so users can restart with a new word whenever they want to.
Put a text view somewhere so you can track and show the player’s score for a given root word. How you calculate score is down to you, but something involving number of words and their letter count would be reasonable.