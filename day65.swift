Building our basic UI

The first step in our project is to build the basic user interface, which for this app will be:

A NavigationStack so we can show our app’s name at the top.
A box prompting users to select a photo, over which we’ll place their imported picture.
An “Intensity” slider that will affect how strongly we apply our Core Image filters, stored as a value from 0.0 to 1.0.
A sharing button to export the processed image from the app.
We won't put all those bits in place to begin with; just enough so you can see how things fit together.

Initially the user won’t have selected an image, so we’ll represent that using an @State optional image property.

First add these two properties to ContentView:

@State private var processedImage: Image?
@State private var filterIntensity = 0.5
Now modify the contents of its body property to this:

NavigationStack {
    VStack {
        Spacer()

        // image area

        Spacer()

        HStack {
            Text("Intensity")
            Slider(value: $filterIntensity)
        }
        .padding(.vertical)

        HStack {
            Button("Change Filter") {
                // change filter
            }

            Spacer()

            // share the picture
        }
    }
    .padding([.horizontal, .bottom])
    .navigationTitle("Instafilter")
}
That uses two spacers so that we always get space above and below the image area, which also ensures the filter controls stay fixed to the bottom of the screen.

In terms of what should go in place of the // image area comment, it will be one of two things: if we have an image already selected then we should show it, otherwise we'll display a simple ContentUnavailableView so users know that space isn't just accidentally blank:

if let processedImage {
    processedImage
        .resizable()
        .scaledToFit()
} else {
    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
}
I love being able to place optional views right inside a SwiftUI layout, and I think it works particularly well with ContentUnavailableView because only one is visible at a time. Yes, tapping the view won't do anything yet, but we'll tackle that shortly.

Now, as our code was fairly easy here, I want to just briefly explore what it looks like to clean up our body property a little – we have lots of layout code in there, but there's also a button action inside there too.

Yes, the Change Filter button isn't going to have a lot of complex functionality inside it, but this is good practice in splitting off button actions.

Right now that just means adding an empty method to ContentView, like this:

func changeFilter() {
}
Then calling it from the Change Filter button, like this:

Button("Change Filter", action: changeFilter)
When you’re learning it’s very common to write button actions and similar directly inside your views, but once you get onto real projects it’s a good idea to spend extra time keeping your code cleaned up – it makes your life easier in the long term, trust me!

I’ll be adding more little cleanup tips like this going forward, so as you start to approach the end of the course you feel increasingly confident that your code is in good shape.


Importing an image into SwiftUI using PhotosPicker

In order to bring this project to life, we need to let the user select a photo from their library, then display it in ContentView. This takes a little thinking, mostly because of the roundabout way Core Image works compared to SwiftUI.

First we need to add an import for PhotosUI to the top of ContentView, then give it an extra @State property to track whatever picture the user selected:

@State private var selectedItem: PhotosPickerItem?
Second, we need to place a PhotosPicker view wherever we want to trigger an image selection. In this app, we can actually place one around the whole if let processedImage check – we can use the selected image or the ContentUnavailableView as the label for our PhotosPicker.

Here's how that looks:

PhotosPicker(selection: $selectedItem) {
    if let processedImage {
        processedImage
            .resizable()
            .scaledToFit()
    } else {
        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
    }
}
Tip: That adds blue coloring to the ContentUnavailableView to signal that's interactive, but you can disable that by adding .buttonStyle(.plain) to the PhotosPicker if you prefer.

Third, we need a method that will be called when the an image has been selected.

Previously I showed you how how we can load data from a PhotosPicker selection, and separately I also showed you how to feed a UIImage into Core Image for filtering. Here we need to kind of bolt those two things together: we can't load a simple SwiftUI image because they can't be fed into Core Image, so instead we load a pure Data object and convert that to a UIImage.

Add this method to ContentView now:

func loadImage() {
    Task {
        guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let inputImage = UIImage(data: imageData) else { return }

        // more code to come
    }
}
We can then call that whenever our selectedItem property changes, by attaching an onChange() modifier somewhere in ContentView – it really doesn’t matter where, but attaching it to the PhotosPicker would seem sensible.

.onChange(of: selectedItem, loadImage)
Go ahead and run the app again – although it won't actually do much with your selection, you can at least bring up the photo selection UI and browse through the options.


Basic image filtering using Core Image

Now that our project has an image the user selected, the next step is to let the user apply varying Core Image filters to it. To start with we’re just going to work with a single filter, but shortly we’ll extend that using a confirmation dialog.

If we want to use Core Image in our apps, we first need to add two imports to the top of ContentView.swift:

import CoreImage
import CoreImage.CIFilterBuiltins
Next we need both a context and a filter. A Core Image context is an object that’s responsible for rendering a CIImage to a CGImage, or in more practical terms an object for converting the recipe for an image into an actual series of pixels we can work with.

Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive. As for the filter, we’ll be using CIFilter.sepiaTone() as our default but because we’ll make it flexible later we’ll make the filter use @State so it can be changed.

So, add these two properties to ContentView:

@State private var currentFilter = CIFilter.sepiaTone()
let context = CIContext()
With those two in place we can now write a method that will process whatever image was imported – that means it will set our sepia filter’s intensity based on the value in filterIntensity, read the output image back from the filter, ask our CIContext to render it, then place the result into our processedImage property so it’s visible on-screen.

func applyProcessing() {
    currentFilter.intensity = Float(filterIntensity)

    guard let outputImage = currentFilter.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    let uiImage = UIImage(cgImage: cgImage)
    processedImage = Image(uiImage: uiImage)
}
Tip: Sadly the Core Image behind the sepia tone filter wants Float rather than Double for its values. This makes Core Image feel even older, I know, but don’t worry – we’ll make it go away soon!

The next job is to change the way loadImage() works. Right now it ends with a // more code to come comment, but really it should send whatever image was chosen into the sepia tone filter, then call applyProcessing() to make the magic happen.

Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash – it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey.

So, replace the // more code to come comment with this:

let beginImage = CIImage(image: inputImage)
currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
applyProcessing()
If you run the code now you’ll see our basic app flow works great: we can select an image, then see it with a sepia effect applied. But that intensity slider we added doesn’t do anything, even though it’s bound to the same filterIntensity value that our filter is reading from.

What’s happening here ought not to be too surprising: even though the slider is changing the value of filterIntensity, changing that property won’t automatically trigger our applyProcessing() method again. Instead, we need to do that by hand by telling SwiftUI to watch filterIntensity with onChange().

Again, these onChange() modifiers can go anywhere in our SwiftUI view hierarchy, but as the slider changes the value directly I'll attach it there:

Slider(value: $filterIntensity)
    .onChange(of: filterIntensity, applyProcessing)
Tip: If multiple views adjust the same value, or if it’s not quite so specific what is changing the value, then I’d add the modifier at the end of the view.

You can go ahead and run the app now, but be warned: even though Core Image is extremely fast on all iPhones, it’s often extremely slow in the simulator. That means you can try it out to make sure everything works, but don’t be surprised if your code runs at a glacial pace.