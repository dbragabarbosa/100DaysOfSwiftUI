Project 2, part 1
How did you find yesterday’s challenge day? Unless you’re an undiscovered programming prodigy there’s a good chance you made a few mistakes along the way, and there’s even a good chance your app still has a couple of bugs in that you might not have noticed yet.

And you know what? That’s OK. Donald Knuth – computer science professor emeritus at Stanford – once wrote, “beware of bugs in the above code; I have only proved it correct, not tried it.” And if even Donald Knuth warns people of potential bugs, I think it’s OK if we have a few of our own.

Today we’re moving onto our second project, so it’s back to the overview day so we can look at some new SwiftUI techniques. It’s another easy project, but you’ll be learning so many core SwiftUI techniques that you’ll be using for years to come.

Today you have six topics to work through, and you’ll meet VStack, Image, LinearGradient, and more.

Guess the Flag: Introduction

Using stacks to arrange views

When we return some View for our body, SwiftUI expects to receive back some kind of view that can be displayed on the screen. That might be a navigation view, a form, a text view, a picker, or something else entirely, but it must conform to the View protocol so that it can be drawn on the screen.

If we want to return multiple things neatly arranged then we have various options, but three are particularly useful. They are HStack, VStack, and ZStack, which handle horizontal, vertical, and, er, zepth.

Let’s try it out now. Our default template looks like this:

var body: some View {
    VStack {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Text("Hello, world!")
    }
    .padding()
}
That has a VStack in there already, which means the image appears above the text. However, we could make it simpler, like this:

var body: some View {
    Text("Hello, world!")
    Text("This is another text view")
}
We haven't said it's a VStack, but SwiftUI is figuring it out for us. So, we can choose to place the two text views loosely like that, or in an explicit VStack:

var body: some View {
    VStack {
        Text("Hello, world!")
        Text("This is inside a stack")
    }
}
Yes, the result is the same is here, but there are three important differences:

Being explicit allows us to specify how much space to place between the views.
It also allows us to specify an alignment – whether the view should be placed on the left, right, or center of each other.
If we don't explicitly ask for a vertical stack, SwiftUI is free to arrange those views in a different way – if they were inside a larger view that used horizontal placement, they might also appear horizontally.
By default VStack places some automatic amount of spacing between the two views, but we can control the spacing by providing a parameter when we create the stack, like this:

VStack(spacing: 20) {
    Text("Hello, world!")
    Text("This is inside a stack")
}
By default, VStack aligns its views so they are centered, but you can control that with its alignment property. For example, this aligns the text views to their leading edge, which in a left-to-right language such as English will cause them to be aligned to the left:

VStack(alignment: .leading) {
    Text("Hello, world!")
    Text("This is inside a stack")
}
Alongside VStack we have HStack for arranging things horizontally. This has the same syntax as VStack, including the ability to add spacing and alignment:

HStack(spacing: 20) {
    Text("Hello, world!")
    Text("This is inside a stack")
}
Vertical and horizontal stacks automatically fit their content, and prefer to align themselves to the center of the available space. If you want to change that you can use one or more Spacer views to push the contents of your stack to one side. These automatically take up all remaining space, so if you add one at the end a VStack it will push all your views to the top of the screen:

VStack {
    Text("First")
    Text("Second")
    Text("Third")
    Spacer()
}
If you add more than one spacer they will divide the available space between them. So, for example we could have one third of the space at the top and two thirds at the bottom, like this:

VStack {
    Spacer()
    Text("First")
    Text("Second")
    Text("Third")
    Spacer()
    Spacer()
}
We also have ZStack for arranging things by depth – it makes views that overlap. In the case of our two text views, this will make things rather hard to read:

ZStack {
    Text("Hello, world!")
    Text("This is inside a stack")
}
ZStack doesn’t have the concept of spacing because the views overlap, but it does have alignment. So, if you have one large thing and one small thing inside your ZStack, you can make both views align to the top like this: ZStack(alignment: .top) {.

ZStack draws its contents from top to bottom, back to front. This means if you have an image then some text ZStack will draw them in that order, placing the text on top of the image.

Colors and frames

SwiftUI gives us a range of functionality to render colors, and manages to be both simple and powerful – a difficult combination, but one they really pulled off.

To try this out, let’s create a ZStack with a single text label:

ZStack {
    Text("Your content")
}
If we want to put something behind the text, we need to place it above it in the ZStack. But what if we wanted to put some red behind there – how would we do that?

One option is to use the background() modifier, which can be given a color to draw like this:

ZStack {
    Text("Your content")
}
.background(.red)
That might have done what you expected, but there’s a good chance it was a surprise: only the text view had a background color, even though we’ve asked the whole ZStack to have it.

In fact, there’s no difference between that code and this:

ZStack {
    Text("Your content")
        .background(.red)
}
If you want to fill in red the whole area behind the text, you should place the color into the ZStack – treat it as a whole view, all by itself:

ZStack {
    Color.red
    Text("Your content")
}
In fact, Color.red is a view in its own right, which is why it can be used like shapes and text.

Tip: When we were using the background() modifier, SwiftUI was able to figure out that .red actually meant Color.red. When we’re using the color as a free-standing view Swift has no context to help it figure out what .red means so we need to be specific that we mean Color.red.

Colors automatically take up all the space available, but you can also use the frame() modifier to ask for specific sizes. For example, we could ask for a 200x200 red square like this:

Color.red
    .frame(width: 200, height: 200)
You can also specify minimum and maximum widths and heights, depending on the layout you want. For example, we could say we want a color that is no more than 200 points high, but for its width must be at least 200 points wide but can stretch to fill all the available width that’s not used by other stuff:

Color.red
    .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
SwiftUI gives us a number of built-in colors to work with, such as Color.blue, Color.green, Color.indigo, and more. We also have some semantic colors: colors that don’t say what hue they contain, but instead describe their purpose.

For example, Color.primary is the default color of text in SwiftUI, and will be either black or white depending on whether the user’s device is running in light mode or dark mode. There’s also Color.secondary, which is also black or white depending on the device, but now has slight transparency so that a little of the color behind it shines through.

If you need something specific, you can create custom colors by passing in values between 0 and 1 for red, green, and blue, like this:

Color(red: 1, green: 0.8, blue: 0)
Even when taking up the full screen, you’ll see that using Color.red will leave some space white.

How much space is white depends on your device, but on iPhones with Face ID – iPhone 15, for example – you’ll find that both the dynamic island area (the capsule-shaped area at the top) and the home indicator (the horizontal stripe at the bottom) are left uncolored.

This space is left intentionally blank, because Apple doesn’t want important content to get obscured by other UI features or by any rounded corners on your device. So, the remaining part – that whole middle space – is called the safe area, and you can draw into it freely without worrying that it might be clipped by the notch on an iPhone.

If you want your content to go under the safe area, you can use the .ignoresSafeArea() modifier to specify which screen edges you want to run up to, or specify nothing to automatically go edge to edge. For example, this creates a ZStack which fills the screen edge to edge with red then draws some text on top:

ZStack {
    Color.red
    Text("Your content")
}
.ignoresSafeArea()    
It is critical that no important content be placed outside the safe area, because it might be hard if not impossible for the user to see. Some views, such as List, allow content to scroll outside the safe area but then add extra insets so the user can scroll things into view.

If your content is just decorative – like our background color here – then extending it outside the safe area is okay.

Before we’re done, there’s one more thing I want to mention: as well as using fixed colors such as .red and .green, the background() modifier can also accept materials. These apply a frosted glass effect over whatever comes below them, which allows us to create some beautiful depth effects.

To see this in action, we could build up our ZStack so that it has two colors inside a VStack, so they split the available space between them. Then, we’ll attach a couple of modifiers to our text view so that it has a gray color, with an ultra thin material behind it:

ZStack {
    VStack(spacing: 0) {
        Color.red
        Color.blue
    }   

    Text("Your content")
        .foregroundStyle(.secondary)
        .padding(50)
        .background(.ultraThinMaterial)
}
.ignoresSafeArea()
That uses the thinnest material, which is means we’re letting a lot of the background colors shine through our frosted glass effect. iOS automatically adapts the effect based on whether the user has light or dark mode enabled – our material will either be light-colored or dark-colored, as appropriate.

There are other material thicknesses available depending on what effect you want, but there’s something even neater I want to show to you. It’s subtle, though, so I’d like you to click the tiny magnifying glass icon at the bottom of your SwiftUI preview so you can get a super close-up look at the “Your content” text.

You might notice the text isn't just gray, but instead allows a little of the red and blue background colors to come through. It’s not a lot, just a hint, but when used effectively this provides a really beautiful effect to make sure text stands out regardless of the background behind it. iOS calls this effect vibrancy, and it’s used a lot throughout the system.

Gradients

SwiftUI gives us four kinds of gradients to work with, and like colors most of them are also views that can be drawn in our UI.

Gradients are made up of several components:

An array of colors to show
Size and direction information
The type of gradient to use
For example, a linear gradient goes in one direction, so we provide it with a start and end point like this:

LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
We can also provide that with gradient stops, which let you specify both a color and how far along the gradient the color should be used. For example, we could specify that our gradient should be white from the start up to 45% of the available space, then black from 55% of the available space onwards:

LinearGradient(stops: [
    Gradient.Stop(color: .white, location: 0.45),
    Gradient.Stop(color: .black, location: 0.55),
], startPoint: .top, endPoint: .bottom)
That will create a much sharper gradient – it will be compressed into a small space in the center.

Tip: Swift knows we’re creating gradient stops here, so as a shortcut we can just write .init rather than Gradient.Stop, like this:

LinearGradient(stops: [
    .init(color: .white, location: 0.45),
    .init(color: .black, location: 0.55),
], startPoint: .top, endPoint: .bottom)
As an alternative, radial gradients move outward in a circle shape, so instead of specifying a direction we specify a start and end radius – how far from the center of the circle the color should start and stop changing. For example:

RadialGradient(colors: [.blue, .black], center: .center, startRadius: 20, endRadius: 200)
The last gradient that's also a view is called an angular gradient, although you might have heard it referred to elsewhere as a conic or conical gradient. This cycles colors around a circle rather than radiating outward, and can create some beautiful effects.

For example, this cycles through a range of colors in a single gradient, centered on the middle of the gradient:

AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
All of these gradient types can have stops provided rather than simple colors. Plus, they can also work as standalone views in your layouts, or be used as part of a modifier – you can use them as the background for a text view, for example.

SwiftUI provides a fourth type of gradient that's simpler than these first three – you don't get any control over it, and you also can use them only as backgrounds and foreground styles rather than individual views.

This gradient is created by simply adding .gradient after any color – SwiftUI will automatically convert your color into a very gentle linear gradient. Try it like this:

Text("Your content")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundStyle(.white)
    .background(.red.gradient)
This kind of gradient is so subtle, but it can really help elevate your design with almost no work – you'll see I use these a lot!

Buttons and images

We’ve looked at SwiftUI’s buttons briefly previously, but they are remarkably flexible and can adapt to a huge range of use cases.

The simplest way to make a button is one we’ve looked at previously: when it just contains some text you pass in the title of the button, along with a closure that should be run when the button is tapped:

Button("Delete selection") {
    print("Now deleting…")
}
Of course, that could be any function rather than just a closure, so this kind of thing is fine:

struct ContentView: View {
    var body: some View {
        Button("Delete selection", action: executeDelete)
    }

    func executeDelete() {
        print("Now deleting…")
    }
}
There are a few different ways we can customize the way buttons look. First, we can attach a role to the button, which iOS can use to adjust its appearance both visually and for screen readers. For example, we could say that our Delete button has a destructive role like this:

Button("Delete selection", role: .destructive, action: executeDelete)
Second, we can use one of the built-in styles for buttons: .bordered and .borderedProminent. These can be used by themselves, or in combination with a role:

VStack {
    Button("Button 1") { }
        .buttonStyle(.bordered)
    Button("Button 2", role: .destructive) { }
        .buttonStyle(.bordered)
    Button("Button 3") { }
        .buttonStyle(.borderedProminent)
    Button("Button 4", role: .destructive) { }
        .buttonStyle(.borderedProminent)
}
If you want to customize the colors used for a bordered button, use the tint() modifier like this:

Button("Button 3") { }
    .buttonStyle(.borderedProminent)
    .tint(.mint)
Important: Apple explicitly recommends against using too many prominent buttons, because when everything is prominent nothing is.

If you want something completely custom, you can pass a custom label using a second trailing closure:

Button {
    print("Button was tapped")
} label: {
    Text("Tap me!")
        .padding()
        .foregroundStyle(.white)
        .background(.red)
}
SwiftUI has a dedicated Image type for handling pictures in your apps, and there are three main ways you will create them:

Image("pencil") will load an image called “Pencil” that you have added to your project.
Image(decorative: "pencil") will load the same image, but won’t read it out for users who have enabled the screen reader. This is useful for images that don’t convey additional important information.
Image(systemName: "pencil") will load the pencil icon that is built into iOS. This uses Apple’s SF Symbols icon collection, and you can search for icons you like – download Apple’s free SF Symbols app from the web to see the full set.
By default the screen reader will read your image name if it is enabled, so make sure you give your images clear names if you want to avoid confusing the user. Or, if they don’t actually add information that isn’t already elsewhere on the screen, use the Image(decorative:) initializer.

Because the longer form of buttons can have any kind of views inside them, you can use images like this:

Button {
    print("Edit button was tapped")
} label: { 
    Image(systemName: "pencil")
}
If you want both text and image at the same time, you have two options. The first is provide them both to the Button directly, like this:

Button("Edit", systemImage: "pencil") {
    print("Edit button was tapped")
}
But if you want something more custom, SwiftUI has a dedicated type called Label.

Button {
    print("Edit button was tapped")
} label: {
    Label("Edit", systemImage: "pencil")
        .padding()
        .foregroundStyle(.white)
        .background(.red)
}
Both of those will show both a pencil icon and the word “Edit” side by side, which on the surface sounds exactly the same as what we’d get by using a simple HStack. However, SwiftUI is really smart: it will automatically decide whether to show the icon, the text, or both depending on how they are being used in our layout, which makes this option a great choice.

Showing alert messages

If something important happens, a common way of notifying the user is using an alert – a pop up window that contains a title, message, and one or two buttons depending on what you need.

But think about it: when should an alert be shown and how? Views are a function of our program state, and alerts aren’t an exception to that. So, rather than saying “show the alert”, we instead create our alert and set the conditions under which it should be shown.

A basic SwiftUI alert has a title and a button that dismisses it, but the more interesting part is how we present that alert: we don’t assign the alert to a variable then write something like myAlert.show(), because that would be back to the old “series of events” way of thinking.

Instead, we create some state that tracks whether our alert is showing, like this:

@State private var showingAlert = false
We then attach our alert somewhere to our user interface, telling it to use that state to determine whether the alert is presented or not. SwiftUI will watch showingAlert, and as soon as it becomes true it will show the alert.

Putting that all together, here’s some example code that shows an alert when a button is tapped:

struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
}
That attaches the alert to the button, but honestly it doesn’t matter where the alert() modifier is used – all we’re doing is saying that an alert exists and is shown when showingAlert is true.

Take a close look at the alert() modifier:

alert("Important message", isPresented: $showingAlert)
The first part is the alert title, which is straightforward enough, but there’s also another two-way data binding because SwiftUI will automatically set showingAlert back to false when the alert is dismissed.

Now look at the button:

Button("OK") { }
That’s an empty closure, meaning that we aren’t assigning any functionality to run when the button is pressed. That doesn’t matter, though, because any button inside an alert will automatically dismiss the alert – that closure is there to let us add any extra functionality beyond just dismissing the alert.

You can add more buttons to your alert, and this is a particularly good place to add roles to make sure it’s clear what each button does:

.alert("Important message", isPresented: $showingAlert) {
    Button("Delete", role: .destructive) { }
    Button("Cancel", role: .cancel) { }
}
And finally, you can add message text to go alongside your title with a second trailing closure, like this:

Button("Show Alert") {
    showingAlert = true
}
.alert("Important message", isPresented: $showingAlert) {
    Button("OK", role: .cancel) { }
} message: {
    Text("Please read this.")
}
This is the final part of the overview for this project, so it’s almost time to get started with the real code. If you want to save the examples you’ve programmed you should copy your project directory somewhere else.

When you’re ready, put ContentView.swift back to the way it started when you first made the project, so we have a clean slate to work from.