Project 10, part 4

Every new project we work on here introduces new concepts to you in isolation and then again in the context of a real app, with the goal being that showing you the same thing twice in different circumstances helps it sink deeper into your long-term memory.

But today, with our app finished, it’s time for another important part of the long-term process: a test of what you remember, and some challenges to help push you further. Like it or not, this step matters – as the astronaut John Young once said, “the greatest enemy of progress is the illusion of knowledge.”

Trust me on this: knowing you understand something is way better than thinking you understand it. This is why I keep drilling the essentials into you: I want you to get so bored with Form that you could almost write this course yourself. I want you to see Codable and know exactly what it means and how it works behind the scenes, and never to think to yourself that it’s somehow magic.

All these foundations we’re building here are going to last you for years, and it means everything you build on top – everything you learn or create in the future – isn’t built on top of half understanding something you read once, but is instead something you can have real, lasting confidence about.

Today you should work through the wrap up chapter for project 10, complete its review, then work through all three of its challenges.


Cupcake Corner: Wrap up

Hopefully this project has shown you how to take the skills you know – SwiftUI’s forms, pickers, steppers, and navigation – and build them into an app that sends all the user’s data off to a server and processes the response.

You might not realize this yet, but the skills you learned in this project are the most important skills for the vast majority of iOS developers: take user data, send it to a server, and process the response probably accounts for half the non-trivial apps in existence. Yes, what data gets sent and how it’s used to update the UI varies massively, but the concepts are identical.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.
For a more challenging task, try updating the Order class so it saves data such as the user's delivery address to UserDefaults. This takes a little thinking, because @AppStorage won't work here, and you'll find getters and setters cause problems with Codable support. Can you find a middle ground?