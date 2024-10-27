Project 10, part 3

Years ago, a company called Sun Microsystems came up with a slogan that was way ahead of its time: “the network is the computer.” Today it almost seems obvious: we rely on our phones, laptops, and even watches to stay connected wherever we are, so we get push messages, emails, tweets, and more delivered from across the world.

Think about it: the iPhone we have today got its name from the iPod, which in turn got its name from the iMac – a product that launched way back in 1998. Ken Segall, the marketer who came up with the name “iMac”, specifically said the “I” stands for “internet”, because back in the 90s getting online was nothing like as easy as it is today.

So, it’s no surprise that our iPhones – our internet phones – place networking at the very center of their existence, and so many apps become richer and more useful because of an almost guaranteed internet connection. Today, at last, you’re going to add networking to your own apps, and I hope you’re impressed by how easy iOS makes it for us!

Today you have three topics to work through, in which you’ll build the check out process, then use URLSession to send and receive data over the internet.


Checking for a valid address

The second step in our project will be to let the user enter their address into a form, but as part of that we’re going to add some validation – we only want to proceed to the third step if their address looks good.

We can accomplish this by adding a Form view to the AddressView struct we made previously, which will contain four text fields: name, street address, city, and zip. We can then add a NavigationLink to move to the next screen, which is where the user will see their final price and can check out.

To make this easier to follow, we’re going to start by adding a new view called CheckoutView, which is where this address view will push to once the user is ready. This just avoids us having to put a placeholder in now then remember to come back later.

So, create a new SwiftUI view called CheckoutView and give it the same Order property and preview that AddressView has:

struct CheckoutView: View {
    var order: Order

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    CheckoutView(order: Order())
}
Again, we’ll come back to that later, but first let’s implement AddressView. Like I said, this needs to have a form with four text fields bound to four properties from our Order object, plus a NavigationLink passing control off to our check out view.

First, we need four new properties in Order to store delivery details:

var name = ""
var streetAddress = ""
var city = ""
var zip = ""
Now replace the existing body of AddressView with this:

Form {
    Section {
        TextField("Name", text: $order.name)
        TextField("Street Address", text: $order.streetAddress)
        TextField("City", text: $order.city)
        TextField("Zip", text: $order.zip)
    }

    Section {
        NavigationLink("Check out") {
            CheckoutView(order: order)
        }
    }
}
.navigationTitle("Delivery details")
.navigationBarTitleDisplayMode(.inline)
As you can see, that passes our order object on one level deeper, to CheckoutView, which means we now have three views pointing to the same data.

That code will throw up lots of errors, but it takes just one small change to fix them – change the order property to this:

@Bindable var order: Order
Previously you've seen how Xcode lets us bind to local @State properties just fine, even when those properties are classes using the @Observable macros. That works because the @State property wrapper automatically creates two-way bindings for us, which we access through the $ syntax – $name, $age, etc.

We haven't used @State in AddressView because we aren't creating the class here, we're just receiving it from elsewhere. This means SwiftUI doesn't have access to the same two-way bindings we'd normally use, which is a problem.

Now, we know this class uses the @Observable macro, which means SwiftUI is able to watch this data for changes. So, what the @Bindable property wrapper does is create the missing bindings for us – it produces two-way bindings that are able to work with the @Observable macro, without having to use @State to create local data. It's perfect here, and you'll use it a lot in your future projects.

Go ahead and run the app again, because I want you to see why all this matters. Enter some data on the first screen, enter some data on the second screen, then try navigating back to the beginning then forward to the end – that is, go back to the first screen, then click the bottom button twice to get to the checkout view again.

What you should see is that all the data you entered stays saved no matter what screen you’re on. Yes, this is the natural side effect of using a class for our data, but it’s an instant feature in our app without having to do any work – if we had used local state, then any address details we had entered would disappear if we moved back to the original view.

Now that AddressView works, it’s time to stop the user progressing to the checkout unless some condition is satisfied. What condition? Well, that’s down to us to decide. Although we could write length checks for each of our four text fields, this often trips people up – some names are only four or five letters, so if you try to add length validation you might accidentally exclude people.

So, instead we’re just going to check that the name, streetAddress, city, and zip properties of our order aren’t empty. I prefer adding this kind of complex check inside my data, which means you need to add a new computed property to Order like this one:

var hasValidAddress: Bool {
    if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
        return false
    }

    return true
}
We can now use that condition in conjunction with SwiftUI’s disabled() modifier – attach that to any view along with a condition to check, and the view will stop responding to user interaction if the condition is true.

In our case, the condition we want to check is the computed property we just wrote, hasValidAddress. If that is false, then the form section containing our NavigationLink ought to be disabled, because we need users to fill in their delivery details first.

So, add this modifier to the end of the second section in AddressView:

.disabled(order.hasValidAddress == false)
The code should look like this:

Section {
    NavigationLink("Check out") {
        CheckoutView(order: order)
    }
}
.disabled(order.hasValidAddress == false)
Now if you run the app you’ll see that all four address fields must contain at least one character in order to continue. Even better, SwiftUI automatically grays out the button when the condition isn’t true, giving the user really clear feedback when it is and isn’t interactive.


Preparing for checkout

The final screen in our app is CheckoutView, and it’s really a tale of two halves: the first half is the basic user interface, which should provide little real challenge for you; but the second half is all new: we need to encode our Order class to JSON, send it over the internet, and get a response.

We’re going to look at the whole encoding and transferring chunk of work soon enough, but first let’s tackle the easy part: giving CheckoutView a user interface. More specifically, we’re going to create a ScrollView with an image, the total price of their order, and a Place Order button to kick off the networking.

For the image, I’ve uploaded a cupcake image to my server that we’ll load remotely with AsyncImage – we could store it in the app, but having a remote image means we can dynamically switch it out for seasonal alternatives and promotions.

As for the order cost, we don’t actually have any pricing for our cupcakes in our data, so we can just invent one – it’s not like we’re actually going to be charging people here. The pricing we’re going to use is as follows:

There’s a base cost of $2 per cupcake.
We’ll add a little to the cost for more complicated cakes.
Extra frosting will cost $1 per cake.
Adding sprinkles will be another 50 cents per cake.
We can wrap all that logic up in a new computed property for Order, like this:

var cost: Decimal {
    // $2 per cake
    var cost = Decimal(quantity) * 2

    // complicated cakes cost more
    cost += Decimal(type) / 2

    // $1/cake for extra frosting
    if extraFrosting {
        cost += Decimal(quantity)
    }

    // $0.50/cake for sprinkles
    if addSprinkles {
        cost += Decimal(quantity) / 2
    }

    return cost
}
The actual view itself is straightforward: we’ll use a VStack inside a vertical ScrollView, then our image, the cost text, and button to place the order.

We’ll be filling in the button’s action in a minute, but first let’s get the basic layout done – replace the existing body of CheckoutView with this:

ScrollView {
    VStack {
        AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(height: 233)

        Text("Your total is \(order.cost, format: .currency(code: "USD"))")
            .font(.title)

        Button("Place Order", action: { })
            .padding()
    }
}
.navigationTitle("Check out")
.navigationBarTitleDisplayMode(.inline)
That should all be old news for you by now, but before we're done with this screen I want to show you a small but useful SwiftUI modifier we can add here: scrollBounceBehavior().

Using scroll views is a great way to make sure your layouts work great no matter what Dynamic Type size the user has enabled, but it creates a small annoyance: when your views fit just fine on a single screen, they still bounce a little when the user moves up and down on them.

The scrollBounceBehavior() modifier helps us disable that bounce when there is nothing to scroll. Add this below navigationBarTitleDisplayMode():

.scrollBounceBehavior(.basedOnSize)
With that in place we'll get nice scroll bouncing when we have actually scrolling content, otherwise the scroll view acts like it isn't even there.

With that last tweak out of the way, it's time to finish up this project by tackling the tricky part: networking!


Sending and receiving orders over the internet

iOS comes with some fantastic functionality for handling networking, and in particular the URLSession class makes it surprisingly easy to send and receive data. If we combine that with Codable to convert Swift objects to and from JSON, we can use a new URLRequest struct to configure exactly how data should be sent, we can accomplish great things in about 20 lines of code.

First, let’s create a method we can call from our Place Order button – add this to CheckoutView:

func placeOrder() async {
}
Just like when we were downloading data using URLSession, uploading is also done asynchronously.

Now modify the Place Order button to this:

Button("Place Order", action: placeOrder)
    .padding()
That code won’t work, and Swift will be fairly clear why: it calls an asynchronous function from a function that does not support concurrency. What it means is that our button expects to be able to run its action immediately, and doesn’t understand how to wait for something – even if we wrote await placeOrder() it still wouldn’t work, because the button doesn’t want to wait.

Previously I mentioned that onAppear() didn’t work with these asynchronous functions, and we needed to use the task() modifier instead. That isn’t an option here because we’re executing an action rather than just attaching modifiers, but Swift provides an alternative: we can create a new task out of thin air, and just like the task() modifier this will run any kind of asynchronous code we want.

In fact, all it takes is placing our await call inside a task, like this:

Button("Place Order") {
    Task {
        await placeOrder()
    }
}
And now we’re all set – that code will call placeOrder() asynchronously just fine. Of course, that function doesn’t actually do anything just yet, so let’s fix that now.

Inside placeOrder() we need to do three things:

Convert our current order object into some JSON data that can be sent.
Tell Swift how to send that data over a network call.
Run that request and process the response.
The first of those is straightforward, so let’s get it out of the way. We'll use JSONEncoder to archive our order by adding this code to placeOrder():

guard let encoded = try? JSONEncoder().encode(order) else {
    print("Failed to encode order")
    return
}
That code won't work yet because the Order class doesn't conform to the Codable protocol. That's an easy change, though – modify its class definition to this:

class Order: Codable {
The second step means using a new type called URLRequest, which is like a URL except it gives us options to add extra information such as the type of request, user data, and more.

We need to attach the data in a very specific way so that the server can process it correctly, which means we need to provide two extra pieces of data beyond just our order:

The HTTP method of a request determines how data should be sent. There are several HTTP methods, but in practice only GET (“I want to read data”) and POST (“I want to write data”) are used much. We want to write data here, so we’ll be using POST.
The content type of a request determines what kind of data is being sent, which affects the way the server treats our data. This is specified in what’s called a MIME type, which was originally made for sending attachments in emails, and it has several thousand highly specific options.
So, the next code for placeOrder() will be to create a URLRequest object, then configure it to send JSON data using a HTTP POST request. We can then use that to upload our data using URLSession, and handle whatever comes back.

Of course, the real question is where to send our request, and I don’t think you really want to set up your own web server in order to follow this tutorial. So, instead we’re going to use a really helpful website called https://reqres.in – it lets us send any data we want, and will automatically send it back. This is a great way of prototyping network code, because you’ll get real data back from whatever you send.

Add this code to placeOrder() now:

let url = URL(string: "https://reqres.in/api/cupcakes")!
var request = URLRequest(url: url)
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpMethod = "POST"
That first line contains a force unwrap for the URL(string:) initializer, which means “this returns an optional URL, but please force it to be non-optional.” Creating URLs from strings might fail because you inserted some gibberish, but here I hand-typed the URL so I can see it’s always going to be correct – there are no string interpolations in there that might cause problems.

At this point we’re all set to make our network request, which we’ll do using a new method called URLSession.shared.upload() and the URL request we just made. So, go ahead and add this to placeOrder():

do {
    let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
    // handle the result    
} catch {
    print("Checkout failed: \(error.localizedDescription)")
}
Now for the important work: we need to read the result of our request for times when everything has worked correctly. If something went wrong – perhaps because there was no internet connection – then our catch block will be run, so we don’t have to worry about that here.

Because we’re using the ReqRes.in, we’ll actually get back the same order we sent, which means we can use JSONDecoder to convert that back from JSON to an object.

To confirm everything worked correctly we’re going to show an alert containing some details of our order, but we’re going to use the decoded order we got back from ReqRes.in. Yes, this ought to be identical to the one we sent, so if it isn’t it means we made a mistake in our coding.

Showing an alert requires properties to store the message and whether it’s visible or not, so please add these two new properties to CheckoutView now:

@State private var confirmationMessage = ""
@State private var showingConfirmation = false
We also need to attach an alert() modifier to watch that Boolean, and show an alert as soon as it's true. Add this modifier below the navigation title modifiers in CheckoutView:

.alert("Thank you!", isPresented: $showingConfirmation) {
    Button("OK") { }
} message: {
    Text(confirmationMessage)
}
And now we can finish off our networking code: we’ll decode the data that came back, use it to set our confirmation message property, then set showingConfirmation to true so the alert appears. If the decoding fails – if the server sent back something that wasn’t an order for some reason – we’ll just print an error message.

Add this final code to placeOrder(), replacing the // handle the result comment:

let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
showingConfirmation = true
If you try running it now you should be able to select the exact cakes you want, enter your delivery information, then press Place Order to see an alert appear – it's all working nicely!

We're not quite done, though, because right now our networking has a small but invisible problem. To see what it is I want to introduce you to a tiny bit of debugging with Xcode: we're going to pause our app, so we can inspect a particular value.

First, click on the line number next to the `let url = URL…" line. A blue arrow should appear there, which is Xcode's way of saying we've placed a breakpoint there. This tells Xcode to pause execution when that line is reached, so we can poke around in all our data.

Now go ahead and run the app again, enter some shipping data, then place the order. All being well your app should pause, Xcode should come to the front, and that line of code should highlighted because it's about to be run.

All being well, you should see Xcode's debug console in the bottom right of the Xcode window – it's normally where all Apple's internal log messages appear, but right now it should say "(lldb)". LLDB is the name of Xcode's debugger, and we can run commands here to explore our data.

I'd like you to run this command there: p String(decoding: encoded, as: UTF8.self). That converts our encoded data back to a string, and prints it out. You should see it has lots of underscored variable names along with the observation registrar provided to us by the @Observable macro.

Our code doesn't actually care about this, because we're sending all the properties up with the underscored names, the ReqRes.in server sends them back to us with the same names, and we decoded them back to the underscored properties. But when you're working with a real server these names matter – you need to send the actual names up, rather than the weird versions produced by the @Observable macro.

This means we need to create some custom coding keys for the Order class. This is rather tedious, particularly for classes like this one where we want to save and load quite a few properties, but it's the best way to ensure our networking is done properly.

So, open up the Order class and add this nested enum there:

enum CodingKeys: String, CodingKey {
    case _type = "type"
    case _quantity = "quantity"
    case _specialRequestEnabled = "specialRequestEnabled"
    case _extraFrosting = "extraFrosting"
    case _addSprinkles = "addSprinkles"
    case _name = "name"
    case _city = "city"
    case _streetAddress = "streetAddress"
    case _zip = "zip
}

If you run the code again you should find you can run the p command again by pressing the up cursor key and return, and this time the data being sent and received is much cleaner.

With that final code in place our networking code is complete, and in fact our app is complete too.

We’re done! Well, I’m done – you still have some challenges to complete!