Project 11, part 3

As we finish our app today, I hope you’re able to stop and realize just how much SwiftUI you already know. For example, to build the detail screen for our app will leverage SwiftData, VStack and ZStack, clip shapes, spacers, and more – things you should now be more than comfortable with, which shows how far you have come.

Still, there are always new things to learn, which today will include how to delete SwiftData objects, how to sort queries using SortDescriptor, and how to add custom buttons to alerts. As the American philosopher Vernon Howard said, “Always walk through life as if you have something new to learn, and you will” – I drop in these small extra things into projects to keep you on your toes, but going over the old stuff is often just as important!

Today you have three topics to work through, in which you’ll upgrade your app to support sorting, deleting, and more.


Showing book details

When the user taps a book in ContentView we’re going to present a detail view with some more information – the genre of the book, their brief review, and more. We’re also going to reuse our new RatingView, and even customize it so you can see just how flexible SwiftUI is.

To make this screen more interesting, we’re going to add some artwork that represents each category in our app. I’ve picked out some artwork already from Unsplash, and placed it into the project11-files folder for this book – if you haven’t downloaded them, please do so now and then drag them into your asset catalog.

Unsplash has a license that allows us to use pictures commercially or non-commercially, with or without attribution, although attribution is appreciated. The pictures I’ve added are by Ryan Wallace, Eugene Triguba, Jamie Street, Alvaro Serrano, Joao Silas, David Dilbert, and Casey Horner – you can get the originals from https://unsplash.com if you want.

Next, create a new SwiftUI view called “DetailView”, then give it an import for SwiftData. This new view only needs one property, which is the book it should show, so please add that now:

let book: Book
Even just having that property is enough to break the preview code at the bottom of DetailView.swift. Previously this was easy to fix because we just sent in an example object, but with SwiftData involved things are messier: creating a new book also means having a view context to create it inside.

This is the first thing that's actually tricky in SwiftData; we need to get things exactly right in order for it to work:

In order to create a sample Book object, we must first create a model context.
That model context comes from creating a model container.
If we create a model container, we don't want it to actually store anything, so we can create a custom configuration that tells SwiftData to store its information in memory only. That means everything is temporary.
I know that sounds a lot, but in practice it's only a few lines of code – we need to make our model container by hand, and do so using a new type called ModelConfiguration that lets us request temporary in-memory storage. Once we have that, we can create a Book object as normal, then send it into DetailView along with the model container itself.

Replace your current preview code with this:

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)

        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
Yes, creating the Book instance doesn't actually mention the model container or configuration anywhere, but it does matter: trying to create a SwiftData model object without a container around is likely to make your code crash.

With that done we can turn our attention to more interesting problems, namely designing the view itself. To start with, we’re going to place the category image and genre inside a ZStack, so we can put one on top of the other nicely. I’ve picked out some styling that I think looks good, but you’re welcome to experiment with the styling all you want – the only thing I’d recommend you definitely keep is the ScrollView, which ensures our review will fit fully onto the screen no matter how long it is, what device the user has, or whether they have adjusted their font sizes or not.

Replace the current body property with this:

ScrollView {
    ZStack(alignment: .bottomTrailing) {
        Image(book.genre)
            .resizable()
            .scaledToFit()

        Text(book.genre.uppercased())
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundStyle(.white)
            .background(.black.opacity(0.75))
            .clipShape(.capsule)
            .offset(x: -5, y: -5)
    }
}
.navigationTitle(book.title)
.navigationBarTitleDisplayMode(.inline)
.scrollBounceBehavior(.basedOnSize)
That places the genre name in the bottom-right corner of the ZStack, with a background color, bold font, and a little padding to help it stand out.

Below that ZStack we’re going to add the author, review, and rating. We don’t want users to be able to adjust the rating here, so instead we can use another constant binding to turn this into a simple read-only view. Even better, because we used SF Symbols to create the rating image, we can scale them up seamlessly with a simple font() modifier, to make better use of all the space we have.

So, add these views directly below the previous ZStack:

Text(book.author)
    .font(.title)
    .foregroundStyle(.secondary)

Text(book.review)
    .padding()

RatingView(rating: .constant(book.rating))
    .font(.largeTitle)
That completes DetailView, so we can head back to ContentView.swift to add a navigation destination to the List view:

.navigationDestination(for: Book.self) { book in
    DetailView(book: book)
}
Now run the app again, because you should be able to tap any of the books you’ve entered to show them in our new detail view.


Sorting SwiftData queries using SortDescriptor

When you use @Query to pull objects out of SwiftData, you get to specify how you want the data to be sorted – should it be alphabetically by one of the fields? Or numerically with the highest numbers first? Regardless of what you choose, it's always a good idea to choose something so your users have a predictable experience.

In this project we have various fields that might be useful for sorting purposes: the title of the book, the author, or the rating are all sensible and would be good choices, but we don't have to rely on just one – you can specify multiple, so that you might ask for highest-rated books first, then use their names for a tiebreaker.

Query sorting can be done in two ways: a simple option that allows just one sort field, and a more advanced version that allows an array of a new type called SortDescriptor.

Using the simple version, we might ask for our books to be provided in alphabetical order based on their title:

@Query(sort: \Book.title) var books: [Book]
Or we could ask for them to be sorted by rating, highest to lowest:

@Query(sort: \Book.rating, order: .reverse) var books: [Book]
That works well when you want just one single field, but generally I'd say it's a better idea to have a backup field too – to say "sort by rating, then by title" adds an extra level of predictability to your app, which is always a good thing.

This is done using the SortDescriptor type, which we can create them from either one or two values: the property we want to sort on, and optionally whether it should be reversed or not. For example, we can alphabetically sort on the title property like this:

@Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
Like the simpler approach to sorting, sorting results using SortDescriptor is done in ascending order by default, meaning alphabetical order for text, but if you wanted to reverse the sort order you’d use this instead:

@Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) var books: [Book]
You can specify more than one sort descriptor, and they will be applied in the order you provide them. For example, if the user added the book “Forever” by Pete Hamill, then added “Forever” by Judy Blume – an entirely different book that just happens to have the same title – then specifying a second sort field is helpful.

So, we might ask for book title to be sorted ascending first, followed by book author ascending second, like this:

@Query(sort: [
    SortDescriptor(\Book.title),
    SortDescriptor(\Book.author)
]) var books: [Book]
Having a second or even third sort field has little to no performance impact unless you have lots of data with similar values. With our books data, for example, almost every book will have a unique title, so having a secondary sort field is more or less irrelevant in terms of performance.


Deleting from a SwiftData query

We already used @Query to place SwiftData objects into a SwiftUI List, and with only a little more work we can enable both swipe to delete and a dedicated Edit/Done button.

Just as with regular arrays of data, most of the work is done by attaching an onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our query then use it to call delete() on our model context. Once all the objects are deleted, SwiftData's autosave system will kick in and apply the changes permanently.

So, start by adding this method to ContentView:

func deleteBooks(at offsets: IndexSet) {
    for offset in offsets {
        // find this book in our query
        let book = books[offset]

        // delete it from the context
        modelContext.delete(book)
    }
}
We can trigger that by adding an onDelete(perform:) modifier to the ForEach of ContentView, but remember: it needs to go on the ForEach and not the List.

Add this modifier now:

.onDelete(perform: deleteBooks)
That gets us swipe to delete, and we can go one better by adding an Edit/Done button too. Find the toolbar() modifier in ContentView, and add another ToolbarItem:

ToolbarItem(placement: .topBarLeading) {
    EditButton()
}
That completes ContentView, so try running the app – you should be able to add and delete books freely now, and can delete by using swipe to delete or using the edit button.


Using an alert to pop a NavigationLink programmatically

You’ve already seen how NavigationLink lets us push to a detail screen, which might be a custom view or one of SwiftUI’s built-in types such as Text or Image. Because we’re inside a NavigationStack, iOS automatically provides a “Back” button to let users get back to the previous screen, and they can also swipe from the left edge to go back. However, sometimes it’s useful to programmatically go back – i.e., to move back to the previous screen when we want rather than when the user swipes.

We've looked at this before, so hopefully this is just good practice for you: we’re going to add one last feature to our app that deletes whatever book the user is currently looking at. To do this we need to show an alert asking the user if they really want to delete the book, then delete the book from the current model context if that’s what they want. Once that’s done, there’s no point staying on the current screen because its associated book doesn’t exist any more, so we’re going to pop the current view – remove it from the top of the NavigationStack stack, so we move back to the previous screen.

First, we need three new properties in our DetailView struct: one to hold our SwiftData model context (so we can delete stuff), one to hold our dismiss action (so we can pop the view off the navigation stack), and one to control whether we’re showing the delete confirmation alert or not.

So, start by adding these three new properties to DetailView:

@Environment(\.modelContext) var modelContext
@Environment(\.dismiss) var dismiss
@State private var showingDeleteAlert = false
The second step is writing a method that deletes the current book from our model context, and dismisses the current view. It doesn’t matter that this view is being shown using a navigation link rather than a sheet – we still use the same dismiss() code.

Add this method to DetailView now:

func deleteBook() {
    modelContext.delete(book)
    dismiss()
}
The third step is to add an alert() modifier that watches showingDeleteAlert, and asks the user to confirm the action. So far we’ve been using simple alerts with a dismiss button, but here we need two buttons: one button to delete the book, and another to cancel. Both of these have specific button roles that automatically make them look correct, so we’ll use those.

Apple provides very clear guidance on how we should label alert text, but it comes down to this: if it’s a simple “I understand” acceptance then “OK” is good, but if you want users to make a choice then you should avoid titles like “Yes” and “No” and instead use verbs such as “Ignore”, “Reply”, and “Confirm”.

In this instance, we’re going to use “Delete” for the destructive button, then provide a cancel button next to it so users can back out of deleting if they want. So, add this modifier to the ScrollView in DetailView:

.alert("Delete book", isPresented: $showingDeleteAlert) {
    Button("Delete", role: .destructive, action: deleteBook)
    Button("Cancel", role: .cancel) { }
} message: {
    Text("Are you sure?")
}
The final step is to add a toolbar item that starts the deletion process – this just needs to flip the showingDeleteAlert Boolean, because our alert() modifier is already watching it. So, add this one last modifier to the ScrollView:

.toolbar {
    Button("Delete this book", systemImage: "trash") {
        showingDeleteAlert = true
    }
}
You can now delete books in ContentView using swipe to delete or the edit button, or navigate into DetailView then tap the dedicated delete button in there – it should delete the book, update the list in ContentView, then automatically dismiss the detail view.

That’s another app complete – good job!