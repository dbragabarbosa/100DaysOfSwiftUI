Project 2, part 3

In this project you’ve learned about images, stacks, gradients, buttons, and more, along with a whole host of new modifiers to help bring your UI designs to life.

All of these skills will come in useful in your own SwiftUI apps – not maybe or might, but will. As Dr Seuss said, “the more that you read, the more things you will know; the more that you learn, the more places you'll go.” And that’s what this course is about: giving you the ability to go anywhere with SwiftUI, and build whatever apps help you reach your goals.

Before we move on to the next topic, it’s time to pause and review: did you fully understand everything you learned? That means another test, but it also means three more coding challenges to make sure you’re writing your own code as often as possible.

Today you should work through the wrap up chapter for project 2, complete its review, then work through all three of its challenges.


Guess the Flag: Wrap up

That’s another SwiftUI app completed, including lots of important new techniques. You’ll use VStack, HStack, and ZStack in almost every project you make, and you’ll find you can quickly build complex layouts by combining them together.

Many people find SwiftUI’s way of showing alerts a little odd at first: creating it, adding a condition, then simply triggering that condition at some point in the future seems like a lot more work than just asking the alert to show itself. But like I said, it’s important that our views always be a reflection of our program state, and that rules out us just showing alerts whenever we want to.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:

Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label.
When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game.