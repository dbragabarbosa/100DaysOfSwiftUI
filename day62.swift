Project 13, part 1
This is the first of two projects that start looking at how we push beyond the boundaries of SwiftUI so that we can connect it to Apple’s other frameworks. Apple has provided approaches for us to do this, but it takes a little thinking – it’s very different from the regular SwiftUI code you’ve been writing so far, and it’s even quite different from the kind of code UIKit developers are used to!

Don’t worry, we’ll be tackling it step by step. I’ll provide the tutorials and a project to work towards; all you need to do is bring your brain and the willpower to push through. Remember, as the writer John Ortberg says, “if you want to walk on water, you have to get out of the boat”!

Today you have four topics to work through, in which you’ll learn about responding to state changes, showing confirmation dialogs, and more.


Instafilter: Introduction

In this project we’re going to build an app that lets the user import photos from their library, then modify them using various image effects. We’ll cover a number of new techniques, but at the center of it all are one useful app development skill – using Apple’s Core Image framework – and one important SwiftUI skill – integrating with UIKit. There are other things too, but those two are the big takeaways.

Core Image is Apple’s high-performance framework for manipulating images, and it’s extraordinarily powerful. Apple has designed dozens of example image filters for us, providing things like blurs, color shifts, pixellation, and more, and all are optimized to take full advantage of the graphics processing unit (GPU) on iOS devices.

Tip: Although you can run your Core Image app in the simulator, don’t be surprised if most things are really slow – you’ll only get great performance when you run on a physical device.

As for integrating with UIKit, you might wonder why this is needed – after all, SwiftUI is designed to replace UIKit, right? Well, sort of. Before SwiftUI launched, almost every iOS app was built with UIKit, which means that there are probably several billion lines of UIKit code out there. So, if you want to integrate SwiftUI into an existing project you’ll need to learn how to make the two work well together.

But there’s another reason, and I’m hoping it won’t always be a reason: many parts of Apple’s frameworks don’t have SwiftUI wrappers yet, which means if you want to integrate MapKit, Safari, or other important APIs, you need to know how to wrap their code for use with SwiftUI. I’ll be honest, the code required to make this work isn’t pretty, but at this point in your SwiftUI career you’re more than ready for it.

As always we have some techniques to cover before we get into the project, so please create a new iOS app using the App template, naming it “Instafilter”.