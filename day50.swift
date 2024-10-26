Project 10, part 2

Today we’re going to be covering two more technique before diving into building the user interface for our app.

Although the fundamentals of today’s work will be familiar to you, there’s still scope for new things as you’ll see. This will become particularly common as we continue to push SwiftUI’s boundaries – everything is easy when your app is easy, but as we venture more into larger apps you’ll find we need to spend more time getting the details right.

But that’s okay. As American tire magnate Harvey Firestone once said, “success is the sum of details.” I hope you can look at Apple’s iOS apps and be inspired by them: their UI is often uncomplicated, but they put a ton of work into getting the details right so the whole experience feels great.

When the user launches your app on their $1000 iPhone, it takes up the full screen. You owe it to them, and to yourself, to make sure you’ve done your best to get things working as smoothly as possible. If Apple can do it, so can we!

Today you have three topics to work through, in which you’ll learn about haptic effects, encoding @Observable classes, and more.


Adding Codable conformance to an @Observable class

If all the properties of a type already conform to Codable, then the type itself can conform to Codable with no extra work – Swift will synthesize the code required to archive and unarchive your type as needed. However, things are a little trickier when working with classes that use the @Observable macro because of the way Swift rewrites our code.

To see the problem in action, we could make a simple observable class that has a single property called name, like this:

@Observable
class User: Codable {
    var name = "Taylor"
}
Now we could write a little SwiftUI code that encodes an instance of our class when a button is pressed, and prints out the resulting text:

struct ContentView: View {
    var body: some View {
        Button("Encode Taylor", action: encodeTaylor)
    }

    func encodeTaylor() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}
What you'll see is unexpected: {"_name":"Taylor","_$observationRegistrar":{}}. Our name property is now _name, there's also an observation registrar instance in the JSON.

Remember, the @Observable macro is quietly rewriting our class so that it can be monitored by SwiftUI, and here that rewriting is leaking – we can see it happening, which might cause all sorts of problems. If you're trying to send a "name" value to a server, it might have no idea what to do with "_name", for example.

To fix this we need to tell Swift exactly how it should encode and decode our data. This is done by nesting an enum inside our class called CodingKeys, and making it have a String raw value and a conformance to the CodingKey protocol. Yes, that's a bit confusing – the enum is called CodingKeys and the protocol is CodingKey, but it does matter.

Inside the enum you need to write one case for each property you want to save, along with a raw value containing the name you want to give it. In our case, that means saying that _name – the underlying storage for our name property – should be written out as the string "name", without an underscore:

@Observable
class User: Codable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }

    var name = "Taylor"
}
And that's it! If you try the code again, you'll see the name property is named correctly, and there's also no more observation registrar in the mix – the result is much cleaner.

This coding key mapping works both ways: when Codable sees name in some JSON, it will automatically be saved in the _name property.


Adding haptic effects

SwiftUI has built-in support for simple haptic effects, which use Apple's Taptic Engine to make the phone vibrate in various ways. We have two options for this in iOS, easy and complete – I'll show you both so you know what's possible, but I think it's fair to say you'll want to stick to the easy option unless you have very specific needs!

Important: These haptic effects only work on physical iPhones – Macs and other devices such as iPad won't vibrate.

Let's start with the easy option. Like sheets and alerts, we tell SwiftUI when to trigger the effect and it takes care of the rest for us.

First, we can write a simple view that adds 1 to a counter whenever a button is pressed:

struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        Button("Tap Count: \(counter)") {
            counter += 1
        }
    }
}
That's all old code, so let's make it more interesting by adding a haptic effect that triggers whenever the button is pressed – add this modifier to the button:

.sensoryFeedback(.increase, trigger: counter)
Try running that on a real device, and you should feel gentle haptic taps whenever you press the button.

.increase is one of the built-in haptic feedback variants, and is best used when you're increasing a value such as a counter. There are lots of others to choose from, including .success, .warning, .error, .start, .stop, and more.

Each of these feedback variants has a different feel, and although it's tempting to go through them all and pick the ones you like the most, please think about how this might be confusing for blind users who rely on haptics to convey information – if your app hits an error but you play the success haptic because you like it a lot, it might cause confusion.

If you want a little more control over your haptic effects, there's an alternative called .impact(), which has two variants: one where you specify how flexible your object is and how strong the effect should be, and one where you specify a weight and intensity.

For example, we could request a middling collision between two soft objects:

.sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
Or we could specify an intense collision between two heavy objects:

.sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
For more advanced haptics, Apple provides us with a whole framework called Core Haptics. This thing feels like a real labor of love by the Apple team behind it, and I think it was one of the real hidden gems introduced in iOS 13 – certainly I pounced on it as soon as I saw the release notes!

Core Haptics lets us create hugely customizable haptics by combining taps, continuous vibrations, parameter curves, and more. I don’t want to go into too much depth here because it’s a bit off topic, but I do at least want to give you an example so you can try it for yourself.

First add this new import near the top of ContentView.swift:

import CoreHaptics
Next, we need to create an instance of CHHapticEngine as a property – this is the actual object that’s responsible for creating vibrations, so we need to create it up front before we want haptic effects.

So, add this property to ContentView:

@State private var engine: CHHapticEngine?
We’re going to create that as soon as our main view appears. When creating the engine you can attach handlers to help resume activity if it gets stopped, such as when the app moves to the background, but here we’re going to keep it simple: if the current device supports haptics we’ll start the engine, and print an error if it fails.

Add this method to ContentView:

func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    do {
        engine = try CHHapticEngine()
        try engine?.start()
    } catch {
        print("There was an error creating the engine: \(error.localizedDescription)")
    }
}
Now for the fun part: we can configure parameters that control how strong the haptic should be (.hapticIntensity) and how “sharp” it is (.hapticSharpness), then put those into a haptic event with a relative time offset. “Sharpness” is an odd term, but it will make more sense once you’ve tried it out – a sharpness value of 0 really does feel dull compared to a value of 1. As for the relative time, this lets us create lots of haptic events in a single sequence.

Add this method to ContentView now:

func complexSuccess() {
    // make sure that the device supports haptics
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()

    // create one intense, sharp tap
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)

    // convert those events into a pattern and play it immediately
    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try engine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
    } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
    }
}
To try out our custom haptics, modify the body property of ContentView to this:

Button("Tap Me", action: complexSuccess)
    .onAppear(perform: prepareHaptics)
Adding onAppear() makes sure the haptics system is started so the tap gesture works correctly.

If you want to experiment with haptics further, replace the let intensity, let sharpness, and let event lines with whatever haptics you want. For example, if you replace those three lines with this next code you’ll get several taps of increasing then decreasing intensity and sharpness:

for i in stride(from: 0, to: 1, by: 0.1) {
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
    events.append(event)
}

for i in stride(from: 0, to: 1, by: 0.1) {
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
    events.append(event)
}
Core Haptics is great fun to experiment with, but given how much more work it takes I think you're likely to stick with the built-in effects as much as possible!

That brings us to the end of the overview for this project, so please put ContentView.swift back to its original state so we can begin building the main project.


Taking basic order details

The first step in this project will be to create an ordering screen that takes the basic details of an order: how many cupcakes they want, what kind they want, and whether there are any special customizations.

Before we get into the UI, we need to start by defining the data model. Previously we’ve mixed structs and classes to get the right result, but here we’re going to take a different solution: we’re going to have a single class that stores all our data, which will be passed from screen to screen. This means all screens in our app share the same data, which will work really well as you’ll see.

For now this class won’t need many properties:

The type of cakes, plus a static array of all possible options.
How many cakes the user wants to order.
Whether the user wants to make special requests, which will show or hide extra options in our UI.
Whether the user wants extra frosting on their cakes.
Whether the user wants to add sprinkles on their cakes.
Each of those need to update the UI when changed, which means we need to make sure the class uses the @Observable macro.

So, please make a new Swift file called Order.swift, change its Foundation import for SwiftUI, and give it this code:

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false
    var extraFrosting = false
    var addSprinkles = false
}
We can now create a single instance of that inside ContentView by adding this property:

@State private var order = Order()
That’s the only place the order will be created – every other screen in our app will be passed that property so they all work with the same data.

We’re going to build the UI for this screen in three sections, starting with cupcake type and quantity. This first section will show a picker letting users choose from Vanilla, Strawberry, Chocolate and Rainbow cakes, then a stepper with the range 3 through 20 to choose the amount. All that will be wrapped inside a form, which is itself inside a navigation stack so we can set a title.

There’s a small speed bump here: our cupcake topping list is an array of strings, but we’re storing the user’s selection as an integer – how can we match the two? One easy solution is to use the indices property of the array, which gives us a position of each item that we can then use with as an array index. This is a bad idea for mutable arrays because the order of your array can change at any time, but here our array order won’t ever change so it’s safe.

Put this into the body of ContentView now:

NavigationStack {
    Form {
        Section {
            Picker("Select your cake type", selection: $order.type) {
                ForEach(Order.types.indices, id: \.self) {
                    Text(Order.types[$0])
                }
            }

            Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
        }
    }
    .navigationTitle("Cupcake Corner")
}
The second section of our form will hold three toggle switches bound to specialRequestEnabled, extraFrosting, and addSprinkles respectively. However, the second and third switches should only be visible when the first one is enabled, so we’ll wrap then in a condition.

Add this second section now:

Section {
    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

    if order.specialRequestEnabled {
        Toggle("Add extra frosting", isOn: $order.extraFrosting)

        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
    }
}
Go ahead and run the app again, and try it out.

However, there’s a bug, and it’s one of our own making: if we enable special requests then enable one or both of “extra frosting” and “extra sprinkles”, then disable the special requests, our previous special request selection stays active. This means if we re-enable special requests, the previous special requests are still active.

This kind of problem isn’t hard to work around if every layer of your code is aware of it – if the app, your server, your database, and so on are all programmed to ignore the values of extraFrosting and addSprinkles when specialRequestEnabled is set to false. However, a better idea – a safer idea – is to make sure that both extraFrosting and addSprinkles are reset to false when specialRequestEnabled is set to false.

We can make this happen by adding a didSet property observer to specialRequestEnabled. Add this now:

var specialRequestEnabled = false {
    didSet {
        if specialRequestEnabled == false {
            extraFrosting = false
            addSprinkles = false
        }
    }
}
Our third section is the easiest, because it’s just going to be a NavigationLink pointing to the next screen. We don’t have a second screen, but we can add it quickly enough: create a new SwiftUI view called “AddressView”, and give it an order property like this:

struct AddressView: View {
    var order: Order

    var body: some View {
        Text("Hello World")
    }
}

#Preview {
    AddressView(order: Order())
}
We’ll make that more useful shortly, but for now it means we can return to ContentView.swift and add the final section for our form. This will create a NavigationLink that points to an AddressView, passing in the current order object.

Please add this final section now:

Section {
    NavigationLink("Delivery details") {
        AddressView(order: order)
    }
}
That completes our first screen, so give it a try one last time before we move on – you should be able to select your cake type, choose a quantity, and toggle all the switches just fine.