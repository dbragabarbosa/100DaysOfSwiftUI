Project 17, part 1

When Apple introduced the iPhone X they ditched something that had been present since the earliest days of the iPhone: the home button. That simple piece of hardware had been there since the original launch as a way to help users get back to the home screen regardless of what they were doing and what app they were using – it made the whole device much less scary.

But as we became accustomed to working with increasingly large panes of glass, Apple started to rely more heavily on gestures: we gained gesture recognizers, the ability to swipe to terminate apps, pull down and pull up menus for system features, and more.

But with iPhone X Apple really took things to the next level, because without the home button almost everything became a gesture. Apple even gave a talk at WWDC18 to encourage developers to think more about gestures, and there Chan Karunamuni from Apple’s human interface design team said something really important about gestures: “when it's feeling really good, sometimes people even say it feels natural, or magical.”

Do you want to build apps that feel natural? Of course you do. This new app we’re building is going to rely heavily on gestures, and after only a few seconds of using it you’ll be using the gestures at light speed. That’s exactly what we’re aiming for: gestures that feel so natural that you struggle to imagine them working any other way.

Today you have three topics to work through, in which you’ll learn about gestures, hit testing, and more.


Flashzilla: Introduction

In this project we’re going to build an app that helps users learn things using flashcards – cards with one thing written on such as “to buy”, and another thing written on the other side, such as “comprar”. Of course, this is a digital app so we don’t need to worry about “the other side”, and can instead just make the detail for the flash card appear when it’s tapped.

The name for this project is actually the name of my first ever app for iOS – an app I shipped so long ago it was written for iPhoneOS because the iPad hadn’t been announced yet. Apple actually rejected the app during app review because it had “Flash” in its product name, and at the time Apple were really keen to have Flash nowhere near their App Store! How times have changed…

Anyway, we have lots of interesting things to learn in this project, including gestures, timers, and more, so please create a new iOS project using the App template, naming it Flashzilla. As always we have some techniques to cover before we get into building the real thing, so let’s get started…


How to use gestures in SwiftUI

SwiftUI gives us lots of gestures for working with views, and does a great job of taking away most of the hard work so we can focus on the parts that matter. We already used onTapGesture() in an earlier project, but there are several others, and there are also interesting ways of combining gestures together that are worth trying out.

I’m going to skip past the simple onTapGesture() because we’ve covered it previously, but before we try bigger things I do want to add that you can pass a count parameter to these to make them handle double taps, triple taps, and more, like this:

Text("Hello, World!")
    .onTapGesture(count: 2) {
        print("Double tapped!")
    }
Okay, let’s look at something more interesting than simple taps. For handling long presses you can use onLongPressGesture(), like this:

Text("Hello, World!")
    .onLongPressGesture {
        print("Long pressed!")
    }
Like tap gestures, long press gestures are also customizable. For example, you can specify a minimum duration for the press, so your action closure only triggers after a specific number of seconds have passed. For example, this will trigger only after two seconds:

Text("Hello, World!")
    .onLongPressGesture(minimumDuration: 2) {
        print("Long pressed!")
    }
You can even add a second closure that triggers whenever the state of the gesture has changed. This will be given a single Boolean parameter as input, and it will work like this:

As soon as you press down the change closure will be called with its parameter set to true.
If you release before the gesture has been recognized (so, if you release after 1 second when using a 2-second recognizer), the change closure will be called with its parameter set to false.
If you hold down for the full length of the recognizer, then the change closure will be called with its parameter set to false (because the gesture is no longer in flight), and your completion closure will be called too.
Use code like this to try it out for yourself:

Text("Hello, World!")
    .onLongPressGesture(minimumDuration: 1) {
        print("Long pressed!")
    } onPressingChanged: { inProgress in
        print("In progress: \(inProgress)!")
    }
For more advanced gestures you should use the gesture() modifier with one of the gesture structs: DragGesture, LongPressGesture, MagnifyGesture, RotateGesture, and TapGesture. These all have special modifiers, usually onEnded() and often onChanged() too, and you can use them to take action when the gestures are in-flight (for onChanged()) or completed (for onEnded()).

As an example, we could attach a magnify gesture to a view so that pinching in and out scales the view up and down. This can be done by creating two @State properties to store the scale amount, using that inside a scaleEffect() modifier, then setting those values in the gesture, like this:

struct ContentView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0

    var body: some View {
        Text("Hello, World!")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification - 1
                    }
                    .onEnded { value in
                        finalAmount += currentAmount 
                        currentAmount = 0
                    }
            )
    }
}
Exactly the same approach can be taken for rotating views using RotateGesture, except now we’re using the rotationEffect() modifier:

struct ContentView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero

    var body: some View {
        Text("Hello, World!")
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        currentAmount = value.rotation
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = .zero
                    }
            )
    }
}
Where things start to get more interesting is when gestures clash – when you have two or more gestures that might be recognized at the same time, such as if you have one gesture attached to a view and the same gesture attached to its parent.

For example, this attaches an onTapGesture() to a text view and its parent:

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .onTapGesture {
            print("VStack tapped")
        }
    }
}
In this situation SwiftUI will always give the child’s gesture priority, which means when you tap the text view above you’ll see “Text tapped”. However, if you want to change that you can use the highPriorityGesture() modifier to force the parent’s gesture to trigger instead, like this:

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded {
                    print("VStack tapped")
                }
        )
    }
}
Alternatively, you can use the simultaneousGesture() modifier to tell SwiftUI you want both the parent and child gestures to trigger at the same time, like this:

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    print("VStack tapped")
                }
        )
    }
}
That will print both “Text tapped” and “VStack tapped”.

Finally, SwiftUI lets us create gesture sequences, where one gesture will only become active if another gesture has first succeeded. This takes a little more thinking because the gestures need to be able to reference each other, so you can’t just attach them directly to a view.

Here’s an example that shows gesture sequencing, where you can drag a circle around but only if you long press on it first:

struct ContentView: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}
Gestures are a really great way to make fluid, interesting user interfaces, but make sure you show users how they work otherwise they can just be confusing!


Disabling user interactivity with allowsHitTesting()

SwiftUI has an advanced hit testing algorithm that uses both the frame of a view and often also its contents. For example, if you add a tap gesture to a text view then all parts of the text view are tappable – you can’t tap through the text if you happen to press exactly where a space is. On the other hand, if you attach the same gesture to a circle then SwiftUI will ignore the transparent parts of the circle.

To demonstrate this, here’s a circle overlapping a rectangle using a ZStack, both with onTapGesture() modifiers:

ZStack {
    Rectangle()
        .fill(.blue)
        .frame(width: 300, height: 300)
        .onTapGesture {
            print("Rectangle tapped!")
        }

    Circle()
        .fill(.red)
        .frame(width: 300, height: 300)
        .onTapGesture {
            print("Circle tapped!")
        }
}
If you try that out, you’ll find that tapping inside the circle prints “Circle tapped”, but on the rectangle behind the circle prints “Rectangle tapped” – even though the circle actually has the same frame as the rectangle.

SwiftUI lets us control user interactivity in two useful ways, the first of which is the allowsHitTesting() modifier. When this is attached to a view with its parameter set to false, the view isn’t even considered tappable. That doesn’t mean it’s inert, though, just that it doesn’t catch any taps – things behind the view will get tapped instead.

Try adding it to our circle like this:

Circle()
    .fill(.red)
    .frame(width: 300, height: 300)
    .onTapGesture {
        print("Circle tapped!")
    }
    .allowsHitTesting(false)
Now tapping the circle will always print “Rectangle tapped!”, because the circle will refuses to respond to taps.

The other useful way of controlling user interactivity is with the contentShape() modifier, which lets us specify the tappable shape for something. By default the tappable shape for a circle is a circle of the same size, but you can specify a different shape instead like this:

Circle()
    .fill(.red)
    .frame(width: 300, height: 300)
    .contentShape(.rect)
    .onTapGesture {
        print("Circle tapped!")
    }
Where the contentShape() modifier really becomes useful is when you tap actions attached to stacks with spacers, because by default SwiftUI won’t trigger actions when a stack spacer is tapped.

Here’s an example you can try out:

VStack {
    Text("Hello")
    Spacer().frame(height: 100)
    Text("World")
}
.onTapGesture {
    print("VStack tapped!")
}
If you run that you’ll find you can tap the “Hello” label and the “World” label, but not the space in between. However, if we use contentShape(.rect) on the VStack then the whole area for the stack becomes tappable, including the spacer:

VStack {
    Text("Hello")
    Spacer().frame(height: 100)
    Text("World")
}
.contentShape(.rect)
.onTapGesture {
    print("VStack tapped!")
}