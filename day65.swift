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