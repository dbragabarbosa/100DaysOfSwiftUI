Project 11, part 4

After a few days of following along with me making a project, it’s time for you to step out of your comfort zone and start writing your own code. Once again, these are challenges I’m setting you based on everything you’ve learned so far, which means they are absolutely within your grasp if you set your mind to it.

Amy Morin, a social worker turned author, once said “the more you practice tolerating discomfort, the more confidence you'll gain in your ability to accept new challenges.” This is the underlying goal in all these challenges: giving you a little nudge to try something yourself, to figure out what works, and – bluntly – to screw up a few times before you figure out the right solution.

There is value in getting things right, but there’s just as much value in getting things wrong. Embrace that – learn to tolerate the discomfort that goes hand-in-hand with writing fresh code yourself – and you’ll be a great developer.

Today you should work through the wrap up chapter for project 11, complete its review, then work through all three of its challenges.

Bookworm: Wrap up

Congratulations on finishing another SwiftUI project! With technologies like SwiftData at your side, you’re now capable of building some serious apps that interact with the user and – most importantly – remember what they entered. Although we only scratched the surface or SwiftData, it’s capable of a lot more and I expect Apple to keep expanding the link between SwiftData and SwiftUI in future updates. In the meantime, the very next project focuses deeply on SwiftData – there’s lots to explore!

As for the other things you learned, you’ve now even more of SwiftUI’s property wrappers, and I hope you’re getting a sense for which one to choose and when. @Binding is particularly useful when building custom UI components, because its ability to share data between views is just so useful.

There’s one last thing I’d like to leave you with, and it’s something you might not even have noticed. When we built a star rating component, we created something that became a user-interactive control just like Button and Slider. However, we didn’t stop to consider how it works with accessibility and that’s a problem: Button, Slider, and others work great of the box, but as soon as we start creating our own components we need to step in and do that work ourselves.

Building apps that are accessible for everyone is something everyone needs to take seriously, which is why I’ve dedicated a whole technique project to it in the future – we’re going to be looking back at the previous projects we’ve made and seeing how we can improve them.

Anyway, first things first – you have a new review and some challenges. Good luck!

Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

Right now it’s possible to select no title, author, or genre for books, which causes a problem for the detail view. Please fix this, either by forcing defaults, validating the form, or showing a default picture for unknown genres – you can choose.
Modify ContentView so that books rated as 1 star are highlighted somehow, such as having their name shown in red.
Add a new “date” attribute to the Book class, assigning Date.now to it so it gets the current date and time, then format that nicely somewhere in DetailView.