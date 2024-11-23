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