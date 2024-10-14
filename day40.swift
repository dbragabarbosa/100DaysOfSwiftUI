Project 8, part 2

Today we’re going to be working through the first part of our application, and in particular we’re going to be getting our data right. I realize that data isn’t terribly exciting, but as your skills grow you’ll start to see how data really defines what your app can do – no matter what fancy designs you add, or what slick animations you introduce, if your data isn’t right your app just won’t work.

Along the way you’re going to meet an important Swift feature called generics. This is a feature I definitely class as well outside of beginner Swift, but as you’ll see generics let us create highly reusable code with only a little extra thinking.

Reusable code is important, because it helps us accomplish bigger and better results with less work. However, as Ralph Johnson once said, “before software can be reusable it first has to be usable” – as nice as generics are, we’ll only start using them once we’ve solved the problem the easier way first.

Today you have three topics to work through, in which you’ll get more hands-on experience with Codable, take generics for a test drive, and more.



Loading a specific kind of Codable data

In this app we’re going to load two different kinds of JSON into Swift structs: one for astronauts, and one for missions. Making this happen in a way that is easy to maintain and doesn’t clutter our code takes some thinking, but we’ll work towards it step by step.

First, drag in the two JSON files for this project. These are available in the GitHub repository for this book, under “project8-files” – look for astronauts.json and missions.json, then drag them into your project navigator. While we’re adding assets, you should also copy all the images into your asset catalog – these are in the “Images” subfolder. The images of astronauts and mission badges were all created by NASA, so under Title 17, Chapter 1, Section 105 of the US Code they are available for us to use under a public domain license.

If you look in astronauts.json, you’ll see each astronaut is defined by three fields: an ID (“grissom”, “white”, “chaffee”, etc), their name (“Virgil I. "Gus" Grissom”, etc), and a short description that has been copied from Wikipedia. If you intend to use the text in your own shipping projects, it’s important that you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA available from here: https://creativecommons.org/licenses/by-sa/3.0.

Let’s convert that astronaut data into a Swift struct now – press Cmd+N to make a new file, choose Swift file, then name it Astronaut.swift. Give it this code:

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
As you can see, I’ve made that conform to Codable so we can create instances of this struct straight from JSON, but also Identifiable so we can use arrays of astronauts inside ForEach and more – that id field will do just fine.

Next we want to convert astronauts.json into a dictionary of Astronaut instances, which means we need to use Bundle to find the path to the file, load that into an instance of Data, and pass it through a JSONDecoder. Previously we put this into a method on ContentView, but here I’d like to show you a better way: we’re going to write an extension on Bundle to do it all in one centralized place.

Create another new Swift file, this time called Bundle-Decodable.swift. This will mostly use code you’ve seen before, but there’s one small difference: previously we used String(contentsOf:) to load files into a string, but because Codable uses Data we are instead going to use Data(contentsOf:). It works in just the same way as String(contentsOf:): give it a file URL to load, and it either returns its contents or throws an error.

Add this to Bundle-Decodable.swift now:

extension Bundle {
    func decode(_ file: String) -> [String: Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
We'll come back to that in a moment, but as you can see it makes liberal use of fatalError(): if the file can’t be found, loaded, or decoded the app will crash. As before, though, this will never actually happen unless you’ve made a mistake, for example if you forgot to copy the JSON file into your project.

Now, you might wonder why we used an extension here rather than a method, but the reason is about to become clear as we load that JSON into our content view. Add this property to the ContentView struct now:

let astronauts = Bundle.main.decode("astronauts.json")
Yes, that’s all it takes. Sure, all we’ve done is just moved code out of ContentView and into an extension, but there’s nothing wrong with that – anything we can do to help our views stay small and focused is a good thing.

If you want to double check that your JSON is loaded correctly, modify the default body property to this:

Text(String(astronauts.count))
That should display 32 rather than “Hello World”.

Before we're done, I want to go back to our little extension and look at it a little more closely. The code we have is perfectly fine for this app, but if you want to use it in the future I'd recommend adding some extra code to help you diagnose problems.

Replace the second part of the method with this:

let decoder = JSONDecoder()

do {
    return try decoder.decode([String: Astronaut].self, from: data)
} catch DecodingError.keyNotFound(let key, let context) {
    fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
} catch DecodingError.typeMismatch(_, let context) {
    fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
} catch DecodingError.valueNotFound(let type, let context) {
    fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
} catch DecodingError.dataCorrupted(_) {
    fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
} catch {
    fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
}
It's not a big change, but it means the method will now tell you what went wrong with decoding – it's great for times when your Swift code and JSON file don't quite match up!

Using generics to load any kind of Codable data

We added a Bundle extension for loading one specific type of JSON data from our app bundle, but now we have a second type: missions.json. This contains slightly more complex JSON:

Every mission has an ID number, which means we can use Identifiable easily.
Every mission has a description, which is a free text string taken from Wikipedia.
Every mission has an array of crew, where each crew member has a name and role.
All but one missions has a launch date. Sadly, Apollo 1 never launched because a launch rehearsal cabin fire destroyed the command module and killed the crew.
Let’s start converting that to code. Crew roles need to be represented as their own struct, storing the name string and role string. So, create a new Swift file called Mission.swift and give it this code:

struct CrewRole: Codable {
    let name: String
    let role: String
}
As for the missions, this will be an ID integer, an array of CrewRole, and a description string. But what about the launch date – we might have one, but we also might not have one. What should that be?

Well, think about it: how does Swift represent this “maybe, maybe not” elsewhere? How would we store “might be a string, might be nothing at all”? I hope the answer is clear: we use optionals. In fact, if we mark a property as optional Codable will automatically skip over it if the value is missing from our input JSON.

So, add this second struct to Mission.swift now:

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
Before we look at how to load JSON into that, I want to demonstrate one more thing: our CrewRole struct was made specifically to hold data about missions, and as a result we can actually put the CrewRole struct inside the Mission struct like this:

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
This is called a nested struct, and is simply one struct placed inside of another. This won’t affect our code in this project, but elsewhere it’s useful to help keep your code organized: rather than saying CrewRole you’d write Mission.CrewRole. If you can imagine a project with several hundred custom types, adding this extra context can really help!

Now let’s think about how we can load missions.json into an array of Mission structs. We already added a Bundle extension that loads some JSON file into a dictionary of Astronaut structs, so we could very easily copy and paste that, then tweak it so it loads missions rather than astronauts. However, there’s a better solution: we can leverage Swift’s generics system.

Generics allow us to write code that is capable of working with a variety of different types. In this project, we wrote the Bundle extension to work with dictionary of astronauts, but really we want to be able to handle dictionaries of astronauts, arrays of missions, or potentially lots of other things.

To make a method generic, we give it a placeholder for certain types. This is written in angle brackets (< and >) after the method name but before its parameters, like this:

func decode<T>(_ file: String) -> [String: Astronaut] {
We can use anything for that placeholder – we could have written “Type”, “TypeOfThing”, or even “Fish”; it doesn’t matter. “T” is a bit of a convention in coding, as a short-hand placeholder for “type”.

Inside the method, we can now use “T” everywhere we would use [String: Astronaut] – it is literally a placeholder for the type we want to work with. So, rather than returning [String: Astronaut] we would use this:

func decode<T>(_ file: String) -> T {
Be very careful: There is a big difference between T and [T]. Remember, T is a placeholder for whatever type we ask for, so if we say “decode our dictionary of astronauts,” then T becomes [String: Astronaut]. If we attempt to return [T] from decode() then we would actually be returning [[String: Astronaut]] – an array of dictionaries of astronauts!

Towards the middle of the decode() method there’s another place where [String: Astronaut] is used:

return try decoder.decode([String: Astronaut].self, from: data)
Again, please change that to T, like this:

return try decoder.decode(T.self, from: data)
So, what we’ve said is that decode() will be used with some sort of type, such as [String: Astronaut], and it should attempt to decode the file it has loaded to be that type.

If you try compiling this code, you’ll see an error in Xcode: “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”. What it means is that T could be anything: it could be a dictionary of astronauts, or it could be a dictionary of something else entirely. The problem is that Swift can’t be sure the type we’re working with conforms to the Codable protocol, so rather than take a risk it’s refusing to build our code.

Fortunately we can fix this with a constraint: we can tell Swift that T can be whatever we want, as long as that thing conforms to Codable. That way Swift knows it’s safe to use, and will make sure we don’t try to use the method with a type that doesn’t conform to Codable.

To add the constraint, change the method signature to this:

func decode<T: Codable>(_ file: String) -> T {
If you try compiling again, you’ll see that things still aren’t working, but now it’s for a different reason: “Generic parameter 'T' could not be inferred”, over in the astronauts property of ContentView. This line worked fine before, but there has been an important change now: before decode() would always return a dictionary of astronauts, but now it returns anything we want as long as it conforms to Codable.

We know it will still return a dictionary of astronauts because the actual underlying data hasn’t changed, but Swift doesn’t know that. Our problem is that decode() can return any type that conforms to Codable, but Swift needs more information – it wants to know exactly what type it will be.

So, to fix this we need to use a type annotation so Swift knows exactly what astronauts will be:

let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
Finally – after all that work! – we can now also load mission.json into another property in ContentView. Please add this below astronauts:

let missions: [Mission] = Bundle.main.decode("missions.json")
And that is the power of generics: we can use the same decode() method to load any JSON from our bundle into any Swift type that conforms to Codable – we don’t need half a dozen variants of the same method.

Before we’re done, there’s one last thing I’d like to explain. Earlier you saw the message “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”, and you might have wondered what Decodable was – after all, we’ve been using Codable everywhere. Well, behind the scenes, Codable is just an alias for two separate protocols: Encodable and Decodable. You can use Codable if you want, or you can use Encodable and Decodable if you prefer being specific – it’s down to you.



Formatting our mission view

Now that we have all our data in place, we can look at the design for our first screen: a grid of all the missions, next to their mission badges.

The assets we added earlier contain pictures named “apollo1@2x.png” and similar, which means they are accessible in the asset catalog as “apollo1”, “apollo12”, and so on. Our Mission struct has an id integer providing the number part, so we could use string interpolation such as "apollo\(mission.id)" to get our image name and "Apollo \(mission.id)" to get the formatted display name of the mission.

Here, though, we’re going to take a different approach: we’re going to add some computed properties to the Mission struct to send that same data back. The result will be the same – “apollo1” and “Apollo 1” – but now the code is in one place: our Mission struct. This means any other views can use the same data without having to repeat our string interpolation code, which in turn means if we change the way these things are formatted – i.e., we change the image names to “apollo-1” or something – then we can just change the property in Mission and have all our code update.

So, please add these two properties to the Mission struct now:

var displayName: String {
    "Apollo \(id)"
}

var image: String {
    "apollo\(id)"
}
With those two in place we can now take a first pass at filling in ContentView: it will have a NavigationStack with a title, a LazyVGrid using our missions array as input, and each row inside there will be a NavigationLink containing the image, name, and launch date of the mission. The only small complexity in there is that our launch date is an optional string, so we need to use nil coalescing to make sure there’s a value for the text view to display.

First, add this property to ContentView to define an adaptive column layout:

let columns = [
    GridItem(.adaptive(minimum: 150))
]
And now replace your existing body property with this:

NavigationStack {
    ScrollView {
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                NavigationLink {
                    Text("Detail view")
                } label: {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)

                        VStack {
                            Text(mission.displayName)
                                .font(.headline)
                            Text(mission.launchDate ?? "N/A")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    .navigationTitle("Moonshot")
}
I know it looks pretty ugly, but we’ll fix it right up in just a moment. First, let’s focus on what we have so far: a scrolling, vertical grid that uses resizable(), scaledToFit(), and frame() to make the image occupy a 100x100 space while also maintaining its original aspect ratio.

Run the program now, and apart from the scrappy layout changes you’ll notice the dates aren’t great – although we can look at “1968-12-21” and understand it’s the 21st of December 1968, it’s still an unnatural date format for almost everyone. We can do better than this!

Swift’s JSONDecoder type has a property called dateDecodingStrategy, which determines how it should decode dates. We can provide that with a DateFormatter instance that describes how our dates are formatted. In this instance, our dates are written as year-month-day, which in the world of DateFormat is written as “y-MM-dd” – that means “a year, then a dash, then a zero-padded month, then a dash, then a zero-padded day”, with “zero-padded” meaning that January is written as “01” rather than “1”.

Warning: Date formats are case sensitive! mm means “zero-padded minute” and MM means “zero-padded month.”

So, open Bundle-Decodable.swift and add this code directly after let decoder = JSONDecoder():

let formatter = DateFormatter()
formatter.dateFormat = "y-MM-dd"
decoder.dateDecodingStrategy = .formatted(formatter)
That tells the decoder to parse dates in the exact format we expect.

Tip: When working with dates it is often a good idea to be specific about your time zone, otherwise the user’s own time zone is used when parsing the date and time. However, we’re also going to be displaying the date in the user’s time zone, so there’s no problem here.

If you run the code now… things will look exactly the same. Yes, nothing has changed, but that’s OK: nothing has changed because Swift doesn’t realize that launchDate is a date. After all, we declared it like this:

let launchDate: String?
Now that our decoding code understands how our dates are formatted, we can change that property to be an optional Date:

let launchDate: Date?
…and now our code won’t even compile!

The problem now is this line of code in ContentView.swift:

Text(mission.launchDate ?? "N/A")
That attempts to use an optional Date inside a text view, or replace it with “N/A” if the date is empty. This is another place where a computed property works better: we can ask the mission itself to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back “N/A” for missing dates.

This uses the same formatted() method we’ve used previously, so this should be somewhat familiar for you. Add this computed property to Mission now:

var formattedLaunchDate: String {
    launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
}
And now replace the broken text view in ContentView with this:

Text(mission.formattedLaunchDate)
With that change our dates will be rendered in a much more natural way, and, even better, will be rendered in whatever way is region-appropriate for the user – what you see isn’t necessarily what I see.

Now let’s focus on the bigger problem: our layout is pretty dull!

To spruce it up a little, I want to introduce you to two useful features: how to share custom app colors easily, and how to force a dark theme for our app.

First, colors. There are two ways to do this, and both are useful: you can add colors to your asset catalog with specific names, or you can add them as Swift extensions. They both have their advantages – using the asset catalog lets you work visually, but using code makes it easier to monitor changes using something like GitHub.

Of the two I prefer the code approach, because it makes it easier to track changes when you're working in teams, so we're going to place our color names into Swift as extensions.

If we make these extensions on Color we can use them in a handful of places in SwiftUI, but Swift gives us a better option with only a little more code. You see, Color conforms to a bigger protocol called ShapeStyle that is what lets us use colors, gradients, materials, and more as if they were the same thing.

This ShapeStyle protocol is what the background() modifier uses, so what we really want to do is extend Color but do so in a way that all the SwiftUI modifiers using ShapeStyle work too. This can be done with a very precise extension that literally says “we want to add functionality to ShapeStyle, but only for times when it’s being used as a color.”

To try this out, make a new Swift file called Color-Theme.swift, change its Foundation import for SwiftUI, then give it this code:

extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
That adds two new colors called darkBackground and lightBackground, each with precise values for red, green, and blue. But more importantly they place those inside a very specific extension that allows us to use those colors everywhere SwiftUI expects a ShapeStyle.

I want to put those new colors into action immediately. First, find the VStack containing the mission name and launch date – it should already have .frame(maxWidth: .infinity) on there, but I’d like you to change its modifier order to this:

.padding(.vertical)
.frame(maxWidth: .infinity)
.background(.lightBackground)
Next, I want to make the outer VStack – the one that is the whole label for our NavigationLink – look more like a box in our grid, which means drawing a line around it and clipping the shape just a little. To get that effect, add these modifiers to the end of it:

.clipShape(.rect(cornerRadius: 10))
.overlay(
    RoundedRectangle(cornerRadius: 10)
        .stroke(.lightBackground)
)
Third, we need to add a little padding to get things away from their edges just a touch. That means adding some simple padding to the mission images, directly after their 100x100 frame:

.padding()
Then also adding some horizontal and bottom padding to the grid:

.padding([.horizontal, .bottom])
Important: This should be added to the LazyVGrid, not to the ScrollView. If you pad the scroll view you’re also padding its scrollbars, which will look odd.

Now we can replace the white background with the custom background color we created earlier – add this modifier to the ScrollView, after its navigationTitle() modifier:

.background(.darkBackground)
At this point our custom layout is almost done, but to finish up we’re going to look at the remaining colors we have – the light blue color used for our mission text isn’t great, and the “Moonshot” title is black at the top, which is impossible to read against our dark blue background.

We can fix the first of these by assigning specific colors to those two text fields:

VStack {
    Text(mission.displayName)
        .font(.headline)
        .foregroundStyle(.white)
    Text(mission.formattedLaunchDate)
        .font(.caption)
        .foregroundStyle(.white.opacity(0.5))
}
Using a translucent white for the foreground color allows just a hint of the color behind to come through.

As for the Moonshot title, that belongs to our NavigationStack, and will appear either black or white depending on whether the user is in light mode or dark mode. To fix this, we can tell SwiftUI our view prefers to be in dark mode always – this will cause the title to be in white no matter what, and will also darken other colors such as navigation bar backgrounds.

So, to finish up the design for this view please add this final modifier to the ScrollView, below its background color:

.preferredColorScheme(.dark)
If you run the app now you’ll see we have a beautifully scrolling grid of mission data that will smoothly adapt to a wide range of device sizes, we have bright white navigation text and a dark navigation background no matter what appearance the user has enabled, and tapping any of our missions will bring in a temporary detail view. A great start!