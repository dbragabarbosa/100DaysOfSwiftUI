Milestone: Projects 4-6
It’s time for another consolidation day, and like always we have lots to review, lots to explore in more detail, and a fresh challenge to tackle.

As you know, these challenges are designed for you to complete without much help from me. There are hints, yes, but not much more – how you solve them is down to you, and it’s an opportunity for you to approach the problem however you want.

The goal here isn’t just to have you write more code, although that matters. The goal here is to get you comfortable with a fresh Xcode project – to give you confidence when faced with a new problem that you have the skills to design a solution, and the know-how to actually turn that solution into working code.

My all-time favorite quote from Maya Angelou is this: “you shouldn’t go through life with a catcher’s mitt on both hands – you need to be able to throw something back.”

Well, today is very much a “throw something back” day. The basic project shouldn’t be too hard for you, but there is so much scope here for customization and improvement – I hope you take the opportunity to explore, experiment, and have some fun!

Today you have three topics to work through, one of which of is your challenge.



What you learned
At this point you should really be starting to feel comfortable with how SwiftUI works. I know that for some people it can be a massive mental speed bump, because we lose the ability to control the exact flow of our program and instead need to construct the entire state then just set things in flow. However, you’ve now built four complete projects, and had two deep-dive technique projects, so I hope you’re starting to get a feel for how SwiftUI works.

Although you now have two more apps you can work on if you want, along the way you picked up a number of valuable skills:

How to read numbers from users with Stepper, including using its shorter form when your label is a simple text view.
Letting the user enter dates using DatePicker, including using the displayedComponents parameter to control dates or times.
Working with dates in Swift, using Date, DateComponents, and DateFormatter
How to bring in machine learning to leverage the full power of modern iOS devices.
Building scrolling tables of data using List, in particular how it can create rows directly from arrays of data.
Running code when a view is shown, using onAppear().
Reading files from our app bundle by looking up their path using the Bundle class, including loading strings from there.
Crashing your code with fatalError(), and why that might actually be a good thing.
How to check whether a string is spelled correctly, using UITextChecker.
Creating animations implicitly using the animation() modifier.
Customizing animations with delays and repeats, and choosing between ease-in-ease-out vs spring animations.
Attaching the animation() modifier to bindings, so we can animate changes directly from UI controls.
Using withAnimation() to create explicit animations.
Attaching multiple animation() modifiers to a single view so that we can control the animation stack.
Using DragGesture() to let the user move views around, then snapping them back to their original location.
Using SwiftUI’s built-in transitions, and creating your own.
Yes, that’s a heck of a lot new information in just three projects, but because each topic has been covered in isolation (“how do lists work?”) then again in the context of a real project (“let’s actually use a list here”), I hope it’s all sunk in. If not, don’t be afraid to go back and review earlier chapters – they aren’t going anywhere, and it will all help you master SwiftUI.

Before moving on, I want to add one important thing: even though you might be starting to understand how SwiftUI works, you will still find – perhaps often! – that it’s hard to express exactly what you mean.

Animations are a classic example of this. With animation, we want to say “make that button – that one right there – spin around right now.” And SwiftUI really isn’t designed for such an imperative way of thinking: we can’t just say “make the button spin.”

This goes beyond the mental speed bump I mentioned earlier. You can understand how SwiftUI works, but still be drawing a blank about what it takes to make something happen. This is a particular problem for folks who have prior programming experience, because they are used to the other way of thinking – they have months, years, or perhaps even decades of muscle memory that makes it very easy to solve problems, but only if they get to dictate exactly how everything should behave.

Remember, in SwiftUI all our views – and all our animations – must be a function of our state. That means we don’t tell the button to spin, but instead attach the button’s spin amount to some state, then modify that state as appropriate. Often this becomes frustrating, because we know where we want to get to but don’t know how to get there.

If this hits you during the course, just relax – it’s normal, and you’re not alone. If you’ve fought with something for an hour or two and can’t quite get it right, put it to one side and try the next project, then come back in a week or so. You’ll know more, and have had more practice, plus a fresh mind never hurts.



Key points
There are three things I want to discuss in more detail before we move on. Again, this is really just to make sure you’ve fully understood certain key concepts before we move on, and I hope it helps give you a sense of how Swift and SwiftUI are actually working underneath.

Ranges with ForEach and List
As I’ve said several times, when we create views in a loop SwiftUI needs to understand how to identify each item uniquely so that it can animate data coming and going. This in itself isn’t complex, but there’s a particular usage that throws people off, and that’s ranges.

First, let’s look at some code:

ForEach(0..<5) {
    Text("Row \($0)")
}
That loops from 0 to 5, printing out some text each time. SwiftUI can be sure that every item is unique because it’s counting over a range, and ranges don’t have duplicated values.

In fact, if you look at the SwiftUI code behind our ForEach you’ll see it’s actually this:

public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content)
The view builder – the thing that actually assembles our views – will be given one integer from the range, and is expected to send back some view content that can be rendered.

Now try writing this:

ForEach(0...5) {
   Text("Row \($0)")
}
That counts from 0 through 5, meaning that it will create six views. Or at least it would create six views if it actually worked – that code doesn’t compile.

Look again at the type of data ForEach wants: Range<Int>. That’s a range of integers, but it’s a very specific range – there’s a second, very similar type called ClosedRange<Int>, and that’s what’s causing the problem.

When we write 0..<5 we get a Range<Int>, but when we write 0...5 we get a ClosedRange<Int>. Even though it looks similar to us, Swift considers these two range types to be different and so we can’t use a closed range with ForEach – it just isn’t possible right now, although I hope that will change.

What makes a string?
From our perspective, it’s easy to imagine a string as being a fairly trivial thing: there’s one letter, then another letter, then a third, a fourth, and so on, perhaps with some punctuation scattered in there. But in practice, strings are some of the most complex features in Swift, and it’s worth taking a minute to understand what’s happening.

First, you might have noticed that code such as this isn’t allowed:

let name = "Paul"
let firstLetter = name[0]
That attempts to read the first letter of the string “Paul”. If we asked a human to “run” that code, they’d say “P”, which makes sense because that’s the first letter.

However, in practice strings are much more complicated than single letters: many emoji are made up of several characters back to back to describe what they contain. For example a simple thumbs up emoji comes in a variety of skin colors, which is achieved through a base emoji (thumbs up) then a skin tone modifier (light through dark). That ends up being multiple individual characters, but we see a single one: a thumbs up emoji with a particular color.

If Swift treated those characters individually, then reading the first letter would read the thumbs up emoji without a skin tone, and reading the second letter would read the skin tone without the thumbs up – the former would be acceptable but not quite as the sender expected, and the latter would just be weird.

Now think about code like this:

print(name.count)
That will print out how many characters are in our test string, which again seems easy enough. But as we’ve just seen, some individual characters are actually supposed to be grouped together to create a combined meaning, which means count can’t just return how many characters the string has. Instead, it needs to start from the first letter and count through every unique letter (taking into account all the modifiers that join together) to produce a total.

It’s not fast, but it’s guaranteed to be correct. If nothing else, that’s what I want you to take away from strings: they can be a bit tricky sometimes, but Swift is doing a huge amount of work on our behalf to make sure we don’t make mistakes by accident. This does mean more code from us when using simple strings, but it also means we get automatic support for advanced strings – including any emoji you can think of – in the future.

Flat app bundles
In Word Scramble we looked for start.txt in our bundle, then loaded it in for use in the game. I explained then that all iOS, macOS, tvOS, and watchOS apps ship as bundles that combine their binary file (the compiled Swift program), their Info.plist, their asset catalog, and more.

One thing I didn’t mention is how those bundles get built, and in particular I want to mention asset catalogs and loose files.

First, asset catalogs are where we’ve been storing images that we want to use in our app, and they are more than just a fancy way of organizing pictures. In fact, when Xcode builds our asset catalog it goes through all our pictures and optimizes them for iOS devices, then puts the result into a compiled asset catalog that can be loaded efficiently. As you progress further with asset catalogs you’ll learn that they can handle vector assets, colors, textures, and much more – they are versatile things!

Second, loose assets are for all the other kinds of media in our app – text files, JSON, XML, movies, and more. If you have lots of these files you can make groups inside Xcode to organize them, but at build time that all goes away: all those files get put into a single directory called your resource directory. This happens so that when we ask the bundle to find the URL for “start.txt” it doesn’t need to search through all the directories in our app bundle, but instead can look in just one place because all the files are there.

This creates an interesting problem, and it’s one you’re guaranteed to hit sooner or later: because all your loose files from everywhere in your Xcode project end up getting placed in one resource directory, you can’t use the same asset filename twice anywhere in your project. It doesn’t matter what groups the files are in, or how far they seem apart in your Xcode project: if you have two files called start.txt in your project, your build will fail because Xcode can’t put them both into the same directory.



Challenge
Before we proceed onto more complex projects, it’s important you have lots of time to stop and use what you already have. So, today you have a new project to make entirely by yourself, with no help from me other than some hints below. Are you ready?

Your goal is to build an “edutainment” app for kids to help them practice multiplication tables – “what is 7 x 8?” and so on. Edutainment apps are educational at their core, but ideally have enough playfulness about them to make kids want to play.

Breaking it down:

The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 2 to 12.
The player should be able to select how many questions they want to be asked: 5, 10, or 20.
You should randomly generate as many questions as they asked for, within the difficulty range they asked for.
If you want to go fully down the “education” route then this is going to be some steppers, a text field and a couple of buttons. I would suggest that’s a good place to start, just to make sure you have the basics covered.

Once you have that, it’s down to you how far you want to take the app down the “entertainment” route – you could throw away fixed controls like Stepper entirely if you wanted, and instead rely on colorful buttons to get the same result.

This is one of those challenges that is best approached step by step: get something working first, then improve it as far as you want. Maybe you’re happy with a simple app, or maybe you really want to spend some time crafting a fun design. It’s down to you!

Important: It’s really easy to get sucked into these challenges and spend hours fighting with a particular bug that only exists because you wanted to get an exact effect. Don’t overload yourself with work, because you’ll just burn out! Instead, start with the simplest possible code that works, then build up slowly.

If you have lots of time on your hands, you could use something like Kenney’s Animal Pack (which is public domain, by the way!) to add a fun theme to make it into a real game. Don’t be afraid to add some animations, too – it needs to appeal to kids 9 and under, so bright and colorful is a good idea!

To solve this challenge you’ll need to draw on skills you learned in all the projects so far, but if you start small and work your way forward you stand the best chance of success. At its core this isn’t a complicated app, so get the basics right and expand only if you have the time.

At the very least, you should:

Start with an App template, then add some state to determine whether the game is active or whether you’re asking for settings.
Generate a range of questions based on the user’s settings.
Show the player how many questions they got correct at the end of the game, then offer to let them play again.
Once you have your code working, try and see if you can break up your layouts into new SwiftUI views rather than putting everything in ContentView. This requires passing data between views, which isn’t something we’ve covered in detail yet, so in the meantime send data using closures – the button action from your settings view would call a function passed in by the parent view that starts the game with the user’s settings, for example.

I’m going to provide some hints below, but I suggest you try to complete as much of the challenge as you can before reading them.

Hints:

You should generate all your questions as soon as your game starts, storing them as an array of questions.
Those questions should probably be their own Swift struct, Question, storing the text and the answer.
When it comes to asking questions, use another state property called questionNumber or similar, which is an integer pointing at some position in your question array.
You can get user input either using buttons on the screen, like a calculator, or using a number pad text field – whichever you prefer.
If you intend to pass a closure into a view’s initializer for later use, Xcode will force you to mark it as @escaping. This means “will be used outside of the current method.”

At its simplest, this is not a hard app to build. Get that core right – get the fundamental logic of what you’re trying to do – then think about how to bring it to life. Yes, I know that part is the fun part, but ultimately this app needs to be useful, and it’s better to get the core working than try for everything at once and find you get bored part-way through.