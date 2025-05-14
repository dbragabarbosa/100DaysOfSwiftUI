Project 19, part 2

Today we’re going to implement the first half of our program, which means we’ll get a list of ski resorts, a detail view to show more information, and a NavigationSplitView that can show them side by side. That by itself shouldn’t present a problem for you, but along the way you’ll also learn about loading static example data from the bundle, controlling how NavigationSplitView should show primary and secondary views on iPhone, and even how to format lists of strings more neatly.

Although you already know so much of what is needed to make this code work, we’re still here on day 97 introducing new things to learn. I hope you’re not discouraged by that – learning is an important skill, and in programming as well as many other industries you can find yourself constantly trying new things throughout your whole career. That might feel hard at times, but as the Spanish painter Pablo Picasso once said, “I am always doing that which I cannot do, in order that I may learn how to do it.”

So, keep learning and be proud to say you’re still learning – it’s an important skill to have!

Today you have four topics to work through, in which you’ll learn about build our primary and secondary views, show them side by side in a NavigationSplitView, learn an improved way to format lists, and more.


Building a primary list of items

In this app we’re going to display two views side by side, just like Apple’s Mail and Notes apps. In SwiftUI this is done by placing two views into a NavigationSplitView, then using a NavigationLink in the primary view to control what’s visible in the secondary view.

So, we’re going to start off our project by building the primary view for our app, which will show a list of all ski resorts, along with which country they are from and how many ski runs it has – how many pistes you can ski down, sometimes called “trails” or just “slopes”.

I’ve provided some assets for this project in the GitHub repository for this book, so if you haven’t already downloaded them please do so now. You should drag resorts.json into your project navigator, then copy all the pictures into your asset catalog. You might notice that I’ve included 2x and 3x images for the countries, but only 2x pictures for the resorts. This is intentional: those flags are going to be used for both retina and Super Retina devices, but the resort pictures are designed to fill all the space on an iPad Pro – they are more than big enough for a Super Retina iPhone even at 2x resolution.

To get our list up and running quickly, we need to define a simple Resort struct that can be loaded from our JSON. That means it needs to conform to Codable, but to make it easier to use in SwiftUI we’ll also make it conform to both Hashable and Identifiable.

The actual data itself is mostly just strings and integers, but there’s also a string array called facilities that describe what else there is on the resort – I should add that this data is mostly fictional, so don’t try to use it in a real app!

Create a new Swift file called Resort.swift, then give it this code:

struct Resort: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var country: String
    var description: String
    var imageCredit: String
    var price: Int
    var size: Int
    var snowDepth: Int
    var elevation: Int
    var runs: Int
    var facilities: [String]
}
As usual, it’s a good idea to add an example value to your model so that it’s easier to show working data in your designs. This time, though, there are quite a few fields to work with and it’s helpful if they have real data, so I don’t really want to create one by hand.

Instead, we’re going to load an array of resorts from JSON stored in our app bundle, which means we can re-use the same code we wrote for project 8 – the Bundle-Decodable.swift extension. If you still have yours, you can drop it into your new project, but if not then create a new Swift file called Bundle-Decodable.swift and give it this code:

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
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
    }
}
With that in place, we can add some properties to Resort to store our example data, and there are two options here. The first option is to add two static properties: one to load all resorts into an array, and one to store the first item in that array, like this:

static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
static let example = allResorts[0]
The second is to collapse all that down to a single line of code. This requires a little bit of gentle typecasting because our decode() extension method needs to know what type of data it’s decoding:

static let example = (Bundle.main.decode("resorts.json") as [Resort])[0]
Of the two, I prefer the first option because it’s simpler and has a little more use if we wanted to show random examples rather than the same one again and again. In case you were curious, when we use static let for properties, Swift automatically makes them lazy – they don’t get created until they are used. This means when we try to read Resort.example Swift will be forced to create Resort.allResorts first, then send back the first item in that array for Resort.example. This means we can always be sure the two properties will be run in the correct order – there’s no chance of example going missing because allResorts wasn’t called yet.

Now that our simple Resort struct is done, we can also use that same Bundle extension to add a property to ContentView that loads all our resorts into a single array:

let resorts: [Resort] = Bundle.main.decode("resorts.json")
For the body of our view, we’re going to use a NavigationSplitView with a List inside it, showing all our resorts. In each row we’re going to show:

A 40x25 flag of which country the resort is in.
The name of the resort.
How many runs it has.
40x25 is smaller than our flag source image, and also a different aspect ratio, but we can fix that by using resizable(), scaledToFill(), and a custom frame. To make it look a little better on the screen, we’ll use a custom clip shape and a stroked overlay.

When the row is tapped we’re going to push to a detail view showing more information about the resort, but we haven’t built that yet so instead we’ll just push to a temporary text view as a placeholder.

Replace your current body property with this:

NavigationSplitView {
    List(resorts) { resort in
        NavigationLink(value: resort) {
            HStack {
                Image(resort.country)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 25)
                    .clipShape(
                        .rect(cornerRadius: 5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                    )

                VStack(alignment: .leading) {
                    Text(resort.name)
                        .font(.headline)
                    Text("\(resort.runs) runs")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    .navigationTitle("Resorts")
} detail: {
    Text("Detail")
}
Go ahead and run the app now and you should see it looks good enough – make sure you try it in both portrait and landscape, on both iPhone and iPad.

Now let's try to fill in that detail view…


Presenting a default detail view on iPad

When using NavigationSplitView, it's common to have the detail view presenting information about something that was selected in the sidebar view. Usually that works great, but what happens when the app is first launched – what should be shown in the detail view then?

On iPhone this won't be a problem because users will only see the sidebar view, but on iPad it's more tricky – depending on the orientation, users might only see the detail view by default.

One easy solution here is to create a small view with some introductory instructions to help users get started. Here that means creating a new SwiftUI view called WelcomeView, then give it this code:

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}
That’s all just static text; it will only be shown when the app first launches, because as soon as the user taps any of our navigation links it will get replaced with whatever they were navigating to.

To put that into ContentView so the two parts of our UI can be used side by side, replace the Text("Detail") code we added earlier with this:

WelcomeView()
That’s enough for SwiftUI to understand exactly what we want. Try running the app on several different devices, both in portrait and landscape, to see how SwiftUI responds – if you’re using an iPad, you might see several different things depending on the device orientation and whether the app has all the screen to itself as opposed to using split screen.


Creating a detail view for resorts

Right now our NavigationLink doesn't send the user anywhere, which is fine for prototyping but obviously not good enough for our actual project. So, in this step we're going to add a new ResortView that shows a picture from the resort, some description text, and a list of facilities.

Important: Like I said earlier, the content in my example JSON is mostly fictional, and this includes the photos – these are just generic ski photos taken from Unsplash. Unsplash photos can be used commercially or non-commercially without attribution, but I’ve included the photo credit in the JSON so you can add it later on. As for the text, this is taken from Wikipedia. If you intend to use the text in your own shipping projects, it’s important you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA available from here: https://creativecommons.org/licenses/by-sa/3.0.

To start with, our ResortView layout is going to be pretty simple – not much more than a scroll view, a VStack, an Image, and some Text. The only interesting part is that we’re going to show the resort’s facilities as a single text view using resort.facilities.joined(separator: ", ") to get a single string.

Create a new SwiftUI view called ResortView, and give it this code to start with:

struct ResortView: View {
    let resort: Resort

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()

                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    Text(resort.facilities.joined(separator: ", "))
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
You’ll also need to update your preview code to pass in an example resort for Xcode’s preview window:

#Preview
    ResortView(resort: .example)
}
And now we can update ContentView to point to our actual view – add this modifier after navigationTitle() there:

.navigationDestination(for: Resort.self) { resort in
    ResortView(resort: resort)
}
There’s nothing terribly interesting in our code so far, but that’s going to change now because I want to add more details to this screen – how big the resort is, roughly how much it costs, how high it is, and how deep the snow is.

We could just put all that into a single HStack in ResortView, but that restricts what we can do in the future. So instead we’re going to group them into two views: one for resort information (price and size) and one for ski information (elevation and snow depth).

The ski view is the easier of the two to implement, so we’ll start there: create a new SwiftUI view called SkiDetailsView and give it this code:

struct SkiDetailsView: View {
    let resort: Resort

    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                Text("\(resort.elevation)m")
                    .font(.title3)
            }

            VStack {
                Text("Snow")
                    .font(.caption.bold())
                Text("\(resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SkiDetailsView(resort: .example)
}
Giving the Group view a maximum frame width of .infinity doesn’t actually affect the group itself, because it has no impact on layout. However, it does get passed down to its child views, which means they will automatically spread out horizontally.

As for the resort details, this is a little trickier because of two things:

The size of a resort is stored as a value from 1 to 3, but really we want to use “Small”, “Average”, and “Large” instead.
The price is stored as a value from 1 to 3, but we’re going to replace that with $, $$, or $$$.
As always, it’s a good idea to get calculations out of your SwiftUI layouts so it’s nice and clear, so we’re going to create two computed properties: size and price.

Start by creating a new SwiftUI view called ResortDetailsView, and give it this property:

let resort: Resort
As with ResortView, you’ll need to update the preview struct to use some example data:

#Preview {
    ResortDetailsView(resort: .example)
}
When it comes to getting the size of the resort we could just add this property to ResortDetailsView:

var size: String {
    ["Small", "Average", "Large"][resort.size - 1]
}
That works, but it would cause a crash if an invalid value was used, and it’s also a bit too cryptic for my liking. Instead, it’s safer and clearer to use a switch block like this:

var size: String {
    switch resort.size {
    case 1: "Small"
    case 2: "Average"
    default: "Large"
    }
}
As for the price property, we can leverage the same repeating/count initializer we used to create example cards in project 17: String(repeating:count:) creates a new string by repeating a substring a certain number of times.

So, please add this second computed property to ResortDetailsView:

var price: String {
    String(repeating: "$", count: resort.price)
}
Now what remains in the body property is simple, because we just use the two computed properties we wrote:

var body: some View {
    Group {
        VStack {
            Text("Size")
                .font(.caption.bold())
            Text(size)
                .font(.title3)
        }

        VStack {
            Text("Price")
                .font(.caption.bold())
            Text(price)
                .font(.title3)
        }
    }
    .frame(maxWidth: .infinity)
}
Again, giving the whole Group an infinite maximum width means these views will spread out horizontally just like those from the previous view.

That completes our two mini views, so we can now drop them into ResortView – put this just before the group in ResortView:

HStack {
    ResortDetailsView(resort: resort)
    SkiDetailsView(resort: resort)
}
.padding(.vertical)
.background(.primary.opacity(0.1))
We’re going to add to that some more in a moment, but first I want to make one small tweak: using joined(separator:) does an okay job of converting a string array into a single string, but we’re not here to write okay code – we’re here to write great code.

Previously we’ve used the format parameter of Text to control the way numbers are formatted, but there’s a format for string arrays too. This is similar to using joined(separator:), but rather than sending back “A, B, C” like we have right now, we get back “A, B, and C” – it’s more natural to read.

Replace the current facilities text view with this:

Text(resort.facilities, format: .list(type: .and))
    .padding(.vertical)
Notice how the .and type is there? That’s because you can also use .or to get “A, B, or C” if that’s what you want.

Anyway, it’s a tiny change but I think it’s much better!