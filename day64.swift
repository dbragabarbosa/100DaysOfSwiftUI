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