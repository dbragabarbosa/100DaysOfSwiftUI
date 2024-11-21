Project 13, part 3
Believe it or not, we still have one more day of techniques for this project before we get into the implementation phase, and I’ve left the fun stuff to the end.

Today you’re going to look at how to bring data into your app, and also send it back out again, which is where apps really come to life – users love to be able to bring in their existing content, remix it somehow, and share the results with their friends.

Stick with it! After today we’ll start putting all these concepts into action, so you’re really close to the building part. Take your inspiration from the postage stamp – as the writer Josh Billings once quipped, “its usefulness consists in the ability to stick to one thing until it gets there.“

Today you have three topics to work through, in which you’ll learn about loading photos, sharing data, and asking for app reviews.


Loading photos from the user's photo library

SwiftUI's PhotosPicker view provides us with a simple way to import one or more photos from the user's photo library. To avoid causing any performance hiccups, the data gets provided to us as a special type called PhotosPickerItem, which we can then load asynchronously to convert the data into a SwiftUI image.

This takes five steps in total, starting with adding an import for PhotosUI alongside your regular SwiftUI import, like this:

import PhotosUI
import SwiftUI
Second, we need to create two properties: one to store the item that was selected, and one to store that selected item as a SwiftUI image. This distinction matters, because the selected item is just a reference to a picture in the user's photo library until we actually ask for it to be loaded.

Add these two now:

@State private var pickerItem: PhotosPickerItem?
@State private var selectedImage: Image?
The third step is to add a PhotosPicker view somewhere in your SwiftUI view hierarchy. This must be created with a title to show the user, a binding where to store the selected image, and also what type of data to show – that last part allows us use PhotosPicker to load videos, Live Photos, and more.

Replace the current body property of your view with this:

VStack {
    PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
}
Tip: That's in a VStack intentionally – more on that in a moment.

The fourth step is to watch pickerItem for changes, because when it changes it means the user has selected a picture for us to load. Once that's done, we can call loadTransferable(type:) on the picker item, which is a method that tells SwiftUI we want to load actual underlying data from the picker item into a SwiftUI image. If that succeeds, we can assign the resulting value to the selectedImage property.

Add this modifier to the VStack:

.onChange(of: pickerItem) {
    Task {
        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
    }
}
Tip: Calling loadTransferable(type:) might take a few seconds to complete, particularly for a large picture such as a panorama.

And now the fifth and final step is to show the loaded SwiftUI image somewhere. Add this to the VStack, either before or after the PhotosPicker:

selectedImage?
    .resizable()
    .scaledToFit()
Now give it a try! The Simulator comes with a handful of built-in images you can test with, and if you select one you should see it loaded into the Image view and displayed on-screen.

There are lots of other ways PhotosPicker can be used, depending on what you need. For example, you can pass it a binding to an array of picker items and let the user select several. That means creating a an array of picker items as a property:

@State private var pickerItems = [PhotosPickerItem]()
Then passing that array in just like before:

PhotosPicker("Select images", selection: $pickerItems, matching: .images)
The harder part is processing those images then displaying them somehow, because we can't watch a single photo picker item item any more.

Instead, you should create an array to store the images that get loaded, like this:

@State private var selectedImages = [Image]()
Then display them using a ForEach or similar, like this:

ScrollView {
    ForEach(0..<selectedImages.count, id: \.self) { i in
        selectedImages[i]
            .resizable()
            .scaledToFit()
    }
}
And finally update your onChange() so that you clear that array when new items are selected, then load the new set individually:

.onChange(of: pickerItems) {
    Task {
        selectedImages.removeAll()

        for item in pickerItems {
            if let loadedImage = try await item.loadTransferable(type: Image.self) {
                selectedImages.append(loadedImage)
            }
        }
    }
}
If you're going to allow users to select several photos, I would recommend you limit how many pictures actually can be selected at once by adding a maxSelectionCount parameter, like this:

PhotosPicker("Select images", selection: $pickerItems, maxSelectionCount: 3, matching: .images)
There are two last ways you can customize photo import, starting with the label. As with many SwiftUI views, you can provide a completely custom label if you prefer, which might be a Label view or something completely custom:

PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .images) {
    Label("Select a picture", systemImage: "photo")
}
And the last way is to limit the kinds of pictures that can be imported. We've used .images here across the board, which means we'll get regular photos, screenshots, panoramas, and more. You can apply a more advanced filter using .any(), .all(), and .not(), and passing them an array. For example, this matches all images except screenshots:

PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
    Label("Select a picture", systemImage: "photo")
}

How to let the user share content with ShareLink

SwiftUI's ShareLink view lets users export content from our app to share elsewhere, such as saving a picture to their photo library, sending a link to a friend using Messages, and more.

We provide the content we want to share, and iOS takes care of showing all the apps that can handle the data we're sending. For example, we can share a URL like this:

ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
That's going to make a button saying "Share" with an icon attached to it, and pressing it will bring up the iOS share sheet. If you're in the simulator you'll only see a few things there as samples, and some might not even work, but if you use a real device you'll see you can share that URL just fine.

If you want more control over the data, you have several options.

First, you can attach a subject and message to the shared data like this:

ShareLink(item: URL(string: "https://www.hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
How that information is used depends on the app users share to – the URL will always be attached, because that's the most important thing, but some apps will use the subject, some the message, and others will use both.

Second, you can customize the button itself by providing whatever label you want:

ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
    Label("Spread the word about Swift", systemImage: "swift")
}
And third, you can provide a preview to attach, which is important when you're sharing something more complex – it's possible to share entirely custom data here, so the preview is helpful for giving the recipient some idea of what's inside.

Annoyingly, this is needed even for data that is its own preview, such as an image. To avoid making your code repetitive, I'd suggest assigning the image to a local constant then using that:

let example = Image(.example)

ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
    Label("Click to share", systemImage: "airplane")
}
Letting users share data from your app is really important, because without it your data can feel quite isolated from the rest of their life!


How to ask the user to leave an App Store review

SwiftUI provides a special environment key called .requestReview, which lets us ask the user to leave a review for our app on the App Store. Apple takes care of showing the whole user interface, making sure it doesn't get shown if the user has already left a review, and also limiting how often the request can be shown – we just need to make a request when we're ready.

This process takes three steps, starting with a new import for StoreKit:

import StoreKit
Second, you need to add a property to read the review requester from SwiftUI's environment:

@Environment(\.requestReview) var requestReview
And third, you need to request a review when you're ready. When you're just starting out, you might think attaching the review to a button press is a good idea, like this:

Button("Leave a review") {
    requestReview()
}
However, that's far from ideal, not least because we're only requesting that a review prompt be shown – the user might have disabled these alerts system-wide, or they might already have reached the maximum number of review requests allowed, in which case your button would do nothing.

Instead, it's better to call requestReview() automatically when you think it's the right time. A good starting place is when the user has performed an important task some number of times, because that way it's clear they have realized the benefit of your app.