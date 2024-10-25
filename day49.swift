Project 10, part 1

You’ve had a couple of days away from following projects, and I hope you used them to review what you’ve learned, write your own code for a while, and reflect on what was said in yesterday’s videos.

As the late, great Zig Ziglar said, “there are two sure ways to fail: think and never do, or do and never think.” Well, today is very much back to being a “do” day: we have a new project to build, which in turns means some new techniques to learn.

In particular, we’re going to take our first steps into networking, so you can see how Swift makes it easy to fetch data from the internet to use in our app. When combined with Codable to handle JSON, this means we can read data from a server directly from SwiftUI – it works really smoothly, as you'll see.

Today you have four topics to work through, in which you’ll learn about URLSession, the disabled() modifier, and more.


Cupcake Corner: Introduction

In this project we’re going to build a multi-screen app for ordering cupcakes. This will use a couple of forms, which are old news for you, but you’re also going to learn how to send and receive the order data from the internet, how to validate forms, and more.

As we continue to dig deeper and deeper into Codable, I hope you’ll continue to be impressed by how flexible and safe it is. In particular, I’d like you to keep in mind how very different it is from the much older UserDefaults API – it’s so nice not having to worry about typing strings exactly correctly!

Anyway, we have lots to get through so let’s get started: create a new iOS app using the App template, and name it CupcakeCorner. If you haven’t already downloaded the project files for this book, please fetch them now: https://github.com/twostraws/HackingWithSwift

As always we’re going to start with the new techniques you’ll need for the project…


Sending and receiving Codable data with URLSession and SwiftUI

iOS gives us built-in tools for sending and receiving data from the internet, and if we combine it with Codable support then it’s possible to convert Swift objects to JSON for sending, then receive back JSON to be converted back to Swift objects. Even better, when the request completes we can immediately assign its data to properties in SwiftUI views, causing our user interface to update.

To demonstrate this we can load some example music JSON data from Apple’s iTunes API, and show it all in a SwiftUI List. Apple’s data includes lots of information, but we’re going to whittle it down to just two types: a Result will store a track ID, its name, and the album it belongs to, and a Response will store an array of results.

So, start with this code:

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
We can now write a simple ContentView that shows an array of results:

struct ContentView: View {
    @State private var results = [Result]()

    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
    }
}
That won’t show anything at first, because the results array is empty. This is where our networking call comes in: we’re going to ask the iTunes API to send us a list of all the songs by Taylor Swift, then use JSONDecoder to convert those results into an array of Result instances.

However, doing this means you need to meet two important Swift keywords: async and await. You see, any iPhone capable of running SwiftUI can perform billions of operations every second – it’s so fast that it completes most work before we even realized it started it. On the flip side, networking – downloading data from the internet – might take several hundreds milliseconds or more to come, which is extremely slow for a computer that’s used to doing literally a billion other things in that time.

Rather than forcing our entire progress to stop while the networking happens, Swift gives us the ability to say “this work will take some time, so please wait for it to complete while the rest of the app carries on running as usual.”

This functionality – this ability to leave some code running while our main app code carries on working – is called an asynchronous function. A synchronous function is one that runs fully before returning a value as needed, but an asynchronous function is one that is able to go to sleep for a while, so that it can wait for some other work to complete before continuing. In our case, that means going to sleep while our networking code happens, so that the rest of our app doesn’t freeze up for several seconds.

To make this easier to understand, let’s write it in a few stages. First, here’s the basic method stub – please add this to the ContentView struct:

func loadData() async {

}
Notice the new async keyword in there – we’re telling Swift this function might want to go to sleep in order to complete its work.

We want that to be run as soon as our List is shown, but we can’t just use onAppear() here because that doesn’t know how to handle sleeping functions – it expects its function to be synchronous.

SwiftUI provides a different modifier for these kinds of tasks, giving it a particularly easy to remember name: task(). This can call functions that might go to sleep for a while; all Swift asks us to do is mark those functions with a second keyword, await, so we’re explicitly acknowledging that a sleep might happen.

Add this modifier to the List now:

.task {
    await loadData()
}
Tip: Think of await as being like try – we’re saying we understand a sleep might happen, in the same way try says we acknowledge an error might be thrown.

Inside loadData() we have three steps we need to complete:

Creating the URL we want to read.
Fetching the data for that URL.
Decoding the result of that data into a Response struct.
We’ll add those step by step, starting with the URL. This needs to have a precise format: “itunes.apple.com” followed by a series of parameters – you can find the full set of parameters if you do a web search for “iTunes Search API”. In our case we’ll be using the search term “Taylor Swift” and the entity “song”, so add this to loadData() now:

guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
    print("Invalid URL")
    return
}
Step 2 is to fetch the data from that URL, which is where our sleep is likely to happen. I say “likely” because it might not – iOS will do a little caching of data, so if the URL is fetched twice back to back then the data will get sent back immediately rather than triggering a sleep.

Regardless, a sleep is possible here, and every time a sleep is possible we need to use the await keyword with the code we want to run. Just as importantly, an error might also be thrown here – maybe the user isn’t currently connected to the internet, for example.

So, we need to use both try and await at the same time. Please add this code directly after the previous code:

do {
    let (data, _) = try await URLSession.shared.data(from: url)

    // more code to come
} catch {
    print("Invalid data")
}
That introduced three important things, so let’s break it down:

Our work is being done by the data(from:) method, which takes a URL and returns the Data object at that URL. This method belongs to the URLSession class, which you can create and configure by hand if you want, but you can also use a shared instance that comes with sensible defaults.
The return value from data(from:) is a tuple containing the data at the URL and some metadata describing how the request went. We don’t use the metadata, but we do want the URL’s data, hence the underscore – we create a new local constant for the data, and toss the metadata away.
When using both try and await at the same time, we must write try await – using await try is not allowed. There’s no special reason for this, but they had to pick one so they went with the one that reads more naturally.
So, if our download succeeds our data constant will be set to whatever data was sent back from the URL, but if it fails for any reason our code prints “Invalid data” and does nothing else.

The last part of this method is to convert the Data object into a Response object using JSONDecoder, then assign the array inside to our results property. This is exactly what we’ve used before, so this shouldn’t be a surprise – add this last code in place of the // more code to come comment now:

if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
    results = decodedResponse.results
}
If you run the code now you should see a list of Taylor Swift songs appear after a short pause – it really isn’t a lot of code given how well the end result works.

All this only handles downloading data. Later on in this project we’re going to look at how to adopt a slightly different approach so you can send Codable data, but that’s enough for now.


Loading an image from a remote server

SwiftUI’s Image view works great with images in your app bundle, but if you want to load a remote image from the internet you need to use AsyncImage instead. These are created using an image URL rather than a simple asset name or Xcode-generated constant, but SwiftUI takes care of all the rest for us – it downloads the image, caches the download, and displays it automatically.

So, the simplest image we can create looks like this:

AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
I created that picture to be 1200 pixels high, but when it displays you’ll see it’s much bigger. This gets straight to one of the fundamental complexities of using AsyncImage: SwiftUI knows nothing about the image until our code is run and the image is downloaded, and so it isn’t able to size it appropriately ahead of time.

If I were to include that 1200px image in my project, I’d actually name it logo@3x.png, then also add an 800px image that was logo@2x.png. SwiftUI would then take care of loading the correct image for us, and making sure it appeared nice and sharp, and at the correct size too. As it is, SwiftUI loads that image as if it were designed to be shown at 1200 pixels high – it will be much bigger than our screen, and will look a bit blurry too.

To fix this, we can tell SwiftUI ahead of time that we’re trying to load a 3x scale image, like this:

AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
When you run the code now you’ll see the resulting image is a much more reasonable size.

And if you wanted to give it a precise size? Well, then you might start by trying this:

AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
    .frame(width: 200, height: 200)
That won’t work, but perhaps that won’t even surprise you because it wouldn’t work with a regular Image either. So you might try to make it resizable, like this:

AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
    .resizable()
    .frame(width: 200, height: 200)
…except that won’t work either, and in fact it’s worse because now our code won’t even compile. You see, the modifiers we’re applying here don’t apply directly to the image that SwiftUI downloads – they can’t, because SwiftUI can’t know how to apply them until it has actually fetched the image data.

Instead, we’re applying modifiers to a wrapper around the image, which is the AsyncImage view. That will ultimately contain our finished image, but it will also contain a placeholder that gets used while the image is loading. You can actually see the placeholder just briefly when your app runs – that 200x200 gray square is it, and it will automatically go away once loading finishes.

To adjust our image, you need to use a more advanced form of AsyncImage that passes us the final image view once it’s ready, which we can then customize as needed. As a bonus, this also gives us a second closure to customize the placeholder as needed.

For example, we could make the finished image view be both resizable and scaled to fit, and use Color.red as the placeholder so it’s more obvious while you’re learning.

AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
    image
        .resizable()
        .scaledToFit()
} placeholder: {
    Color.red
}
.frame(width: 200, height: 200)
A resizable image and Color.red both automatically take up all available space, which means the frame() modifier actually works now.

The placeholder view can be whatever you want. For example, if you replace Color.red with ProgressView() – just that – then you’ll get a little spinner activity indicator instead of a solid color.

If you want complete control over your remote image, there’s a third way of creating AsyncImage that tells us whether the image was loaded, hit an error, or hasn’t finished yet. This is particularly useful for times when you want to show a dedicated view when the download fails – if the URL doesn’t exist, or the user was offline, etc.

Here’s how that looks:

AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
    if let image = phase.image {
        image
            .resizable()
            .scaledToFit()
    } else if phase.error != nil {
        Text("There was an error loading the image.")
    } else {
        ProgressView()
    }
}
.frame(width: 200, height: 200)
So, that will show our image if it can, an error message if the download failed for any reason, or a spinning activity indicator while the download is still in progress.


Validating and disabling forms

SwiftUI’s Form view lets us store user input in a really fast and convenient way, but sometimes it’s important to go a step further – to check that input to make sure it’s valid before we proceed.

Well, we have a modifier just for that purpose: disabled(). This takes a condition to check, and if the condition is true then whatever it’s attached to won’t respond to user input – buttons can’t be tapped, sliders can’t be dragged, and so on. You can use simple properties here, but any condition will do: reading a computed property, calling a method, and so on,

To demonstrate this, here’s a form that accepts a username and email address:

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }

            Section {
                Button("Create account") {
                    print("Creating account…")
                }
            }
        }
    }
}
In this example, we don’t want users to create an account unless both fields have been filled in, so we can disable the form section containing the Create Account button by adding the disabled() modifier like this:

Section {
    Button("Create account") {
        print("Creating account…")
    }
}
.disabled(username.isEmpty || email.isEmpty)
That means “this section is disabled if username is empty or email is empty,” which is exactly what we want.

You might find that it’s worth spinning out your conditions into a separate computed property, such as this:

var disableForm: Bool {
    username.count < 5 || email.count < 5
}
Now you can just reference that in your modifier:

.disabled(disableForm)
Regardless of how you do it, I hope you try running the app and seeing how SwiftUI handles a disabled button – when our test fails the button’s text goes gray, but as soon as the test passes the button lights up blue.