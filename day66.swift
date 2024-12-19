Project 13, part 5

It’s time to put the finishing touches to our app, which will allow the user to experiment with different Core Image filters then share their result with other apps.

Today’s work requires us to return back to some of the Core Image warts we met earlier, namely the quirky-at-best stringly typed API for Core Image. There is ample room for mistakes here, so take your time, double check your code against mine, and remember Mosher’s Law of Software Engineering: “Don’t worry if it doesn’t work right – if everything did, you’d be out of a job.”

Today you have two topics to work through, in which you’ll put into practice confirmation dialogs, ShareLink, and more.


Customizing our filter using confirmationDialog()

So far we’ve brought together SwiftUI and Core Image, but the app still isn’t terribly useful – after all, the sepia tone effect isn’t that interesting.

To make the whole app better, we’re going to let users customize the filter they want to apply, and we’ll accomplish that using a confirmation dialog. On iPhone this is a list of buttons that slides up from the bottom of the screen, and you can add as many as you want – it can even scroll if you really need it to.

First we need a property that will store whether the confirmation dialog should be showing or not, so add this to ContentView:

@State private var showingFilters = false
Now we can add our buttons using the confirmationDialog() modifier. This works identically to alert(): we provide a title and condition to monitor, and as soon as the condition becomes true the confirmation dialog will be shown.

Start by adding this modifier below the navigation title:

.confirmationDialog("Select a filter", isPresented: $showingFilters) {
    // dialog here
}
Now fill in the changeFilter() method with this:

showingFilters = true
In terms of what to show in the confirmation dialog, we can create an array of buttons to show and an optional message. These buttons work just like with alert(): we provide a text title and an action to run when it’s selected.

For the confirmation dialog in this app, we want users to select from a range of different Core Image filters, and when they choose one it should be activated and immediately applied. To make this work we’re going to write a method that modifies currentFilter to whatever new filter they chose, then calls loadImage() straight away.

There is a wrinkle in our plan, and it’s a result of the way Apple wrapped the Core Image APIs to make them more Swift-friendly. You see, the underlying Core Image API is entirely stringly typed – it uses strings to set values, rather than fixed properties – so rather than invent all new classes for us to use Apple instead created a series of protocols.

When we assign CIFilter.sepiaTone() to a property, we get an object of the class CIFilter that happens to conform to a protocol called CISepiaTone. That protocol then exposes the intensity parameter we’ve been using, but internally it will just map it to a call to setValue(_:forKey:).

This flexibility actually works in our favor because it means we can write code that works across all filters, as long as we’re careful not to send in an invalid value.

So, let’s start solving the problem. Please change your currentFilter property to this:

@State private var currentFilter: CIFilter = CIFilter.sepiaTone()
So, again, CIFilter.sepiaTone() returns a CIFilter object that conforms to the CISepiaTone protocol. Adding that explicit type annotation means we’re throwing away some data: we’re saying that the filter must be a CIFilter but doesn’t have to conform to CISepiaTone any more.

As a result of this change we lose access to the intensity property, which means this code won’t work any more:

currentFilter.intensity = Float(filterIntensity)
Instead, we need to replace that with a call to setValue(:_forKey:). This is all the protocol was doing anyway, but it did provide valuable extra type safety.

Replace that broken line of code with this:

currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
kCIInputIntensityKey is another Core Image constant value, and it has the same effect as setting the intensity parameter of the sepia tone filter.

With that change, we can return to our confirmation dialog: we want to be able to change that filter to something else, then call loadImage() to reset everything and apply initial processing. So, add this method to ContentView:

func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    loadImage()
}
Tip: This means image loading is triggered every time a filter changes. If you wanted to make this run a little faster, you could store beginImage in another @State property to avoid reloading the image each time a filter changes.

With that in place we can now replace the // dialog here comment with a series of buttons that try out various Core Image filters.

Put this in its place:

Button("Crystallize") { setFilter(CIFilter.crystallize()) }
Button("Edges") { setFilter(CIFilter.edges()) }
Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
Button("Pixellate") { setFilter(CIFilter.pixellate()) }
Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
Button("Vignette") { setFilter(CIFilter.vignette()) }
Button("Cancel", role: .cancel) { }
I picked out those from the vast range of Core Image filters, but you’re welcome to try using code completion to try something else – type CIFilter. and see what comes up!

Go ahead and run the app, select a picture, then try changing Sepia Tone to Vignette – this applies a darkening effect around the edges of your photo. (If you’re using the simulator, remember to give it a little time because it’s slow!)

Now try changing it to Gaussian Blur, which ought to blur the image, but will instead cause our app to crash. By jettisoning the CISepiaTone restriction for our filter, we’re now forced to send values in using setValue(_:forKey:), which provides no safety at all. In this case, the Gaussian Blur filter doesn’t have an intensity value, so the app just crashes.

To fix this – and also to make our single slider do much more work – we’re going to add some more code that reads all the valid keys we can use with setValue(_:forKey:), and only sets the intensity key if it’s supported by the current filter. Using this approach we can actually query as many keys as we want, and set all the ones that are supported. So, for sepia tone this will set intensity, but for Gaussian blur it will set the radius (size of the blur), and so on.

This conditional approach will work with any filters you choose to apply, which means you can experiment with others safely. The only thing you need be careful with is to make sure you scale up filterIntensity by a number that makes sense – a 1-pixel blur is pretty much invisible, for example, so I’m going to multiply that by 200 to make it more pronounced.

Replace this line:

currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
With this:

let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
And with that in place you can now run the app safely, import a picture of your choosing, then try out all the various filters – nothing should crash any more. Try experimenting with different filters and keys to see what you can find!


Sharing an image using ShareLink

To complete this project we’re going to add two more important features: letting the user share their image using SwiftUI's ShareLink view, then adding a prompt to encourage them to review our app on the App Store – once a suitable amount of time has elapsed, of course.

Neither of these are challenging, so let's get straight into the code.

SwiftUI's ShareLink button lets us share things like text, URLs, and images in just one line of code, and it automatically takes care of using the system-standard share sheet so that users see all the apps that support the data we're sending.

In our case, we already have a // share the picture comment, but that needs to be replaced with a check to see if there is an image to share, and, if there is, a ShareLink button using it.

Replace the comment with this:

if let processedImage {
    ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
}
That's already the first step complete, although remember to try it on a real device so you can see how various real apps respond to the image.

And now all that remains is to ask the user to review our app. Remember, this is best shown only after the user has really felt the benefit of the app, because if you ask too early they are more likely to ignore the request.

So, rather than always showing the request, we're instead going to wait until the user has changed filter at least 20 times – that's enough they've gone through all the options more than once, so hopefully they are happy enough to help with a review.

First, we need to add two new properties: one to get the reviewer requester from SwiftUI's environment, and one to track how many filter changes have happened. Add another import to ContentView.swift, this time for StoreKit, then add these two properties to ContentView`:

@AppStorage("filterCount") var filterCount = 0
@Environment(\.requestReview) var requestReview
And now we need to add some code to the end of the setFilter() method so that we increment filterCount for each filter change, then activate the review request when we have at least 20 filter changes. Put this at the end of the method:

filterCount += 1

if filterCount >= 20 {
    requestReview()
}
That will trigger an error in Xcode: requesting a review must be done on Swift's main actor, which is the part of our app that's able to work with the user interface. Although we're currently writing code inside a SwiftUI view, Swift can't guarantee this code will run on the main actor unless we specifically force that to be the case.

That sounds complicated, but really it just means changing the method to this:

@MainActor func setFilter(_ filter: CIFilter) {
Now Swift will ensure that code always runs on the main actor, and the compile error will go away.

Tip: For testing purposes, you should perhaps change the review condition from 20 down to 5 or so, just to make sure your code works the way you expect!

That final step completes our app, so go ahead and run it again and try it from end to end – import a picture, apply a filter, then share it to a different app. Well done!