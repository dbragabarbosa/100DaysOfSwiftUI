Project 16, part 2
Today you’re going to tackle a tricky concept in the form of Swift’s Result type, but to balance things out we’re also going to cover two easier ones too so hopefully you don’t find today too much work.

Swift’s Result type is designed to solve the problem when you know thing A might be true or thing B might be true, but exactly one can be true at any given time. If you imagine those as Boolean properties, then each has two states (true and false), but together they have four states:

A is false and B is false
A is true and B is false
A is false and B is true
A is true and B is true
If you know for sure that options 1 and 4 are never possible – that either A or B must be true but they can’t both be true – then you can immediately halve the complexity of your logic.

American author Ursula K Le Guin once said that “the only thing that makes life possible is permanent, intolerable uncertainty; not knowing what comes next.” The absolute opposite is true of good software: the more certainty we can enforce and the more constraints we can apply, the safer our code is and the more work the Swift compiler can do on our behalf.

So, although Result requires you to think about escaping closures being passed in as parameters, the pay off is smarter, simpler, safer good – totally worth it.

Today you have three topics to work through, in which you’ll learn about Result, image interpolation, and context menus.


Understanding Swift’s Result type

Swift provides a special type called Result that allows us to encapsulate either a successful value or some kind of error type, all in a single piece of data. So, in the same way that an optional might hold a string or might hold nothing at all, for example, Result might hold a string or might hold an error. The syntax for using it is a little odd at first, but it does have an important part to play in our projects.

To see Result in action, we could start by writing a method that downloads an array of data readings from a server, like this:

struct ContentView: View {
    @State private var output = ""

    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }

    func fetchReadings() async {
        do {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings"
        } catch {
            print("Download error")
        }
    }
}
That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if we just want to cancel the work because it’s no longer needed?

Well, we can get all that by using Result, and it’s actually available through an API you’ve met previously: Task. We could rewrite the above code to this:

func fetchReadings() async {
    let fetchTask = Task {
        let url = URL(string: "https://hws.dev/readings.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let readings = try JSONDecoder().decode([Double].self, from: data)
        return "Found \(readings.count) readings"
    }
}
We’ve used Task before to launch pieces of work, but here we’ve given the Task object the name of fetchTask – that’s what gives us the extra flexibility to pass it around, or cancel it if needed. And notice how our Task closure returns a value now? That value gets stored in our Task instance so that we can read it in the future when we’re ready.

More importantly, that Task might have thrown an error if the network fetch failed, or if the data decoding failed, and that’s where Result comes in: the result of our task might be a string saying “Found 10000 readings”, but it might also contain an error. The only way to find out is to look inside – it’s very similar to optionals.

To read the result from a Task, read its result property like this:

let result = await fetchTask.result
Notice how we haven’t used try to read the Result out? That’s because Result holds it inside itself – an error might have been thrown, but we don’t have to worry about it now unless we want to.

If you look at the type of result, you’ll see it’s a Result<String, Error> – if it succeeded it will contain a string, but it might also have failed and will contain an error.

You can read the successful value directly from the Result if you want, but you’ll need to make sure and handle errors appropriately, like this:

do {
    output = try result.get()
} catch {
    output = "Error: \(error.localizedDescription)"
}
Alternatively, you can switch on the Result, and write code to check for both the success and failure cases. Each of those cases have their values inside (the string for success, and an error for failure), so Swift lets us read those values out using a specially crafted case match:

switch result {
    case .success(let str):
        output = str
    case .failure(let error):
        output = "Error: \(error.localizedDescription)"
}
Regardless of how you handle it, the advantage of Result is that it lets us store the whole success or failure of some work in a single value, pass that around wherever we need, and read the error only when we’re ready.


Controlling image interpolation in SwiftUI

What happens if you make a SwiftUI Image view that stretches its content to be larger than its original size? By default, we get image interpolation, which is where iOS blends the pixels so smoothly you might not even realize they have been stretched at all. There’s a performance cost to this of course, but most of the time it’s not worth worrying about.

However, there is one place where image interpolation causes a problem, and that’s when you’re dealing with precise pixels. As an example, the files for this project on GitHub contain a little cartoon alien image called example@3x.png – it’s taken from the Kenney Platform Art Deluxe bundle at https://kenney.nl/assets/platformer-art-deluxe and is available under the public domain.

Go ahead and add that graphic to your asset catalog, then change your ContentView struct to this:

Image(.example)
    .resizable()
    .scaledToFit()
    .background(.black)
That renders the alien character against a black background to make it easier to see, and because it’s resizable SwiftUI will stretch it up to fill all available space.

Take a close look at the edges of the colors: they look jagged, but also blurry. The jagged part comes from the original image because it’s only 66x92 pixels in size, but the blurry part is where SwiftUI is trying to blend the pixels as they are stretched to make the stretching less obvious.

Often this blending works great, but it struggles here because the source picture is small (and therefore needs a lot of blending to be shown at the size we want), and also because the image has lots of solid colors so the blended pixels stand out quite obviously.

For situations just like this one, SwiftUI gives us the interpolation() modifier that lets us control how pixel blending is applied. There are multiple levels to this, but realistically we only care about one: .none. This turns off image interpolation entirely, so rather than blending pixels they just get scaled up with sharp edges.

So, modify your image to this:

Image(.example)
    .interpolation(.none)    
    .resizable()
    .scaledToFit()
    .background(.black)
Now you’ll see the alien character retains its pixellated look, which not only is particularly popular in retro games but is also important for line art that would look wrong when blurred.


Creating context menus

When the user taps a button or a navigation link, it’s pretty clear that SwiftUI should trigger the default action for those views. But what if they press and hold on something? On older iPhones users could trigger a 3D Touch by pressing hard on something, but the principle is the same: the user wants more options for whatever they are interacting with.

SwiftUI lets us attach context menus to objects to provide this extra functionality, all done using the contextMenu() modifier. You can pass this a selection of buttons and they’ll be shown in order, so we could build a simple context menu to control a view’s background color like this:

struct ContentView: View {
    @State private var backgroundColor = Color.red

    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)

            Text("Change Color")
                .padding()
                .contextMenu {
                    Button("Red") {
                        backgroundColor = .red
                    }

                    Button("Green") {
                        backgroundColor = .green
                    }

                    Button("Blue") {
                        backgroundColor = .blue
                    }
                }
        }
    }
}
Just like TabView, each item in a context menu can have text and an image attached to it using a Label view.

For example, we could use one of Apple’s SF Symbols like this:

Button("Red", systemImage: "checkmark.circle.fill") {
    backgroundColor = .red
}
Apple really likes these menu items to look somewhat uniform across apps, so if you were to try adding a foregroundStyle() modifier to the above code it would be ignore – trying to color menu items randomly just won’t work.

If you really want that item to appear red, which as you should know means destructive, you should use a button role instead:

Button("Red", systemImage: "checkmark.circle.fill", role: .destructive) {
    backgroundColor = .red
}
I have a few tips for you when working with context menus, to help ensure you give your users the best experience:

If you’re going to use them, use them in lots of places – it can be frustrating to press and hold on something only to find nothing happens.
Keep your list of options as short as you can – aim for three or less.
Don’t repeat options the user can already see elsewhere in your UI.
Remember, context menus are by their nature hidden, so please think twice before hiding important actions in a context menu.