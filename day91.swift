Project 17, part 6

With another app finished it’s time for you to review what you learned and also take on some challenges to make sure you really understand what was covered – two things that are easily skipped over, but two things that are central to great learning.

US president John F. Kennedy once said, “things do not happen – things are made to happen,” which really gets to the heart of these challenges. You need to step up the plate and write code yourself – make things happen yourself – because otherwise all you have is an idea. And as Steve Jobs said, “ideas without action aren't ideas – they're regrets.”

Today you should work through the wrap up chapter for project 17, complete its review, then work through all three of its challenges.



Flashzilla: Wrap up

This was another big project, but also another one where we covered some really great techniques like gestures, hit testing, timers, and more. When these features work together we can do remarkable things in our apps, providing an experience to users that is seamless and delightful.

You also saw once again the importance of ensuring accessibility in our apps. It’s easy to get carried away with cool gestures and more, but then forget that straying from standard UI also means we need to up our game when it comes to VoiceOver and more. Anyone can make a good idea, but to make a great app means you’ve taken into account the needs of everyone.


Challenge
One of the best ways to learn is to write your own code as often as possible, so here are some ways you should try extending this app to make sure you fully understand what’s going on.

When adding a card, the text fields keep their current text. Fix that so that the textfields clear themselves after a card is added.
If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: think about the way we set offset back to 0 immediately, even though the card hasn’t animated yet. You might solve this with a ternary within a ternary, but a custom modifier will be cleaner.)
For a harder challenge: when the users gets an answer wrong, add that card back into the array so the user can try it again. Doing this successfully means rethinking the ForEach loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.
Still thirsty for more? Try upgrading our loading and saving code in two ways:

Make it use an alternative approach to saving data, e.g. documents JSON rather than UserDefaults, or SwiftData – this is generally a good idea, so you should get practice with this.
Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!