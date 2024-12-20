Project 13, part 6

This was a difficult project, mostly because as soon as we bring in Core Image we need to deal with the quirks and complexities of Apple's older frameworks.

Like it or not, you’re going to need to know about Apple's older frameworks for the foreseeable future because they aren't going away. Remember, there are hundreds of millions of lines of code out there all written without SwiftUI, and if you intend to get a job building iOS apps then you’ll need to broaden your horizons at some point.

Today is a challenge day, so it’s time for you to read the wrap up chapter, take the test for this project, then complete the three challenges. As the astronaut John Young said, “the greatest enemy of progress is the illusion of knowledge” – it’s much better to take the time to challenge yourself now than assume you know it all, only to find later on that those things you “knew” weren’t quite right!

Today you should work through the wrap up chapter for project 13, complete its review, then work through all three of its challenges.


Instafilter: Wrap up

We covered a lot of ground in this tutorial, not least seeing how we can lean on powerful frameworks like Core Image to introduce impressive graphical effects. Yes, it never quite made the smooth leap to Swift – you need to know it’s quirks if you want to make the most of it. Still, you’re through the worst of it now, so hopefully you can try using it in your own code!

At the same time, we also learned some great SwiftUI stuff, including confirmation dialogs, onChange(), ContentUnavailableView, and App Store reviews, all of which are super common and will continue to be useful for years to come.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

Try making the Slider and Change Filter buttons disabled if there is no image selected.
Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
Explore the range of available Core Image filters, and add any three of your choosing to the app.