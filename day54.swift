Project 11, part 2

Today we’re going to start applying the new techniques you learned to build our app, using SwiftData to create books and a custom RatingView component to let users store how much they liked each book, built using @Binding.

The way we handle data is critically important to our work. Sometimes it’s as simple as figuring out what should be an integer and what should be a string; other times it requires a little theory, such as being able to choose between arrays and sets; and still other times it means we need to think about how objects relate to each other.

A quote from Linus Torvalds that I love very much is this one: “Bad programmers worry about the code; good programmers worry about data structures and their relationships.” I like it partly because it re-enforces the view that designing good data structures is critically important, but also because it’s a reminder that once you master one language it’s relatively easy to move to others – the syntax might be different, but the data structures are usually the same if not very similar.

Today you have three topics to work through, in which you’ll apply your new-found SwiftData skills with List, @Binding, and more.


Creating books with SwiftData

Our first task in this project will be to design a SwitData model for our books, then creating a new view to add books to the database.

First, the model: create a new file called Book.swift, add an import for SwiftData, then give it this code:

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
}
That class needs an initializer to provide values for all its properties, but here's a tip: if you just start typing "in" inside the class, Xcode should autocomplete the whole initializer for you.

That class is enough to store the title of the book, the name of whoever wrote the book, a genre, a brief overview of what the user thought of the book, and also the user’s numerical rating for it.

Now that we have our data model, we can ask SwiftData to create a model container for it. This means opening BookwormApp.swift, adding import SwiftData to the top of the file, then adding this modifier to the WindowGroup:

.modelContainer(for: Book.self)
Our next step is to write a form that can create new entries. This will combine so many of the skills you’ve learned so far: Form, @State, @Environment, TextField, TextEditor, Picker, sheet(), and more, plus all your new SwiftData knowledge.

Start by creating a new SwiftUI view called “AddBookView”. In terms of properties, we need an environment property to get access to our model context:

@Environment(\.modelContext) var modelContext
As this form is going to store all the data required to make up a book, we need @State properties for each of the book’s values. So, add these properties next:

@State private var title = ""
@State private var author = ""
@State private var rating = 3
@State private var genre = "Fantasy"
@State private var review = ""
Finally, we need one more property to store all possible genre options, so we can make a picker using ForEach. Add this last property to AddBookView now:

let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
We can now take a first pass at the form itself – we’ll improve it soon, but this is enough for now. Replace the current body with this:

NavigationStack {
    Form {
        Section {
            TextField("Name of book", text: $title)
            TextField("Author's name", text: $author)

            Picker("Genre", selection: $genre) {
                ForEach(genres, id: \.self) {
                    Text($0)
                }
            }
        }

        Section("Write a review") {                
            TextEditor(text: $review)

            Picker("Rating", selection: $rating) {
                ForEach(0..<6) {
                    Text(String($0))
                }
            }                
        }

        Section {
            Button("Save") {
                // add the book
            }
        }
    }
    .navigationTitle("Add Book")
}
When it comes to filling in the button’s action, we’re going to create an instance of the Book class using all the values from our form, then insert the object into the model context.

Add this code in place of the // add the book comment:

let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
modelContext.insert(newBook)
That completes the form for now, but we still need a way to show and hide it when books are being added.

Showing AddBookView involves returning to ContentView.swift and following the usual steps for a sheet:

Adding an @State property to track whether the sheet is showing.
Add some sort of button – in the toolbar, in this case – to toggle that property.
A sheet() modifier that shows AddBookView when the property becomes true.
Enough talk – let’s start writing some more code. Please start by adding an import for SwiftData to ContentView,swift, then add these properties to the ContentView struct:

@Environment(\.modelContext) var modelContext
@Query var books: [Book]

@State private var showingAddScreen = false
That gives us a model context we can use later on to delete books, a query reading all the books we have (so we can test everything worked), and a Boolean that tracks whether the add screen is showing or not.

For the ContentView body, we’re going to use a navigation stack so we can add a title plus a button in its top-right corner, but otherwise it will just hold some text showing how many items we have in the books array – just so we can be sure everything is working. Remember, this is where we need to add our sheet() modifier to show an AddBookView as needed.

Replace the existing body property of ContentView with this:

 NavigationStack {
    Text("Count: \(books.count)")
        .navigationTitle("Bookworm")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Book", systemImage: "plus") {
                    showingAddScreen.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBookView()
        }
}
Tip: That explicitly specifies a trailing placement for the button so that we can add a second button later.

Bear with me – we’re almost done! We’ve now designed our SwiftData model, created a form to add data, then updated ContentView so that it can present the form when needed. The final step is to make the form dismiss itself when the user adds a book.

We’ve done this before, so hopefully you know the drill. We need to start by adding another environment property to AddBookView to be able to dismiss the current view:

@Environment(\.dismiss) var dismiss
Finally, add a call to dismiss() to the end of your Save button’s action closure.

You should be able to run the app now and add an example book just fine. When AddBookView slides away the count label should update itself to 1.


Adding a custom star rating component

SwiftUI makes it really easy to create custom UI components, because they are effectively just views that have some sort of @Binding exposed for us to read.

To demonstrate this, we’re going to build a star rating view that lets the user enter scores between 1 and 5 by tapping images. Although we could just make this view simple enough to work for our exact use case, it’s often better to add some flexibility where appropriate so it can be used elsewhere too. Here, that means we’re going to make six customizable properties:

What label should be placed before the rating (default: an empty string)
The maximum integer rating (default: 5)
The off and on images, which dictate the images to use when the star is highlighted or not (default: nil for the off image, and a filled star for the on image; if we find nil in the off image we’ll use the on image there too)
The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
We also need one extra property to store an @Binding integer, so we can report back the user’s selection to whatever is using the star rating.

So, create a new SwiftUI view called “RatingView”, and start by giving it these properties:

@Binding var rating: Int

var label = ""

var maximumRating = 5

var offImage: Image?
var onImage = Image(systemName: "star.fill")

var offColor = Color.gray
var onColor = Color.yellow
Before we fill in the body property, please try building the code – you should find that it fails, because our #Preview code doesn’t pass in a binding to use for rating.

SwiftUI has a specific and simple solution for this called constant bindings. These are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews.

So, replace the existing preview code with this:

#Preview {
    RatingView(rating: .constant(4))
}
Now let’s turn to the body property. This is going to be a HStack containing any label that was provided, plus as many stars as have been requested – although, of course, they can choose any image they want, so it might not be a star at all.

The logic for choosing which image to show is pretty simple, but it’s perfect for carving off into its own method to reduce the complexity of our code. The logic is this:

If the number that was passed in is greater than the current rating, return the off image if it was set, otherwise return the on image.
If the number that was passed in is equal to or less than the current rating, return the on image.
We can encapsulate that in a single method, so add this to RatingView now:

func image(for number: Int) -> Image {
    if number > rating {
        offImage ?? onImage
    } else {
        onImage
    }
}
And now implementing the body property is surprisingly easy: if the label has any text use it, then use ForEach to count from 1 to the maximum rating plus 1 and call image(for:) repeatedly. We’ll also apply a foreground color depending on the rating, and wrap each star inside a button that adjusts the rating.

Replace your existing body property with this:

HStack {
    if label.isEmpty == false {
        Text(label)
    }

    ForEach(1..<maximumRating + 1, id: \.self) { number in
        Button {
            rating = number
        } label: {
            image(for: number)
                .foregroundStyle(number > rating ? offColor : onColor)
        }
    }
}
That completes our rating view already, so to put it into action go back to AddBookView and replace the second section with this:

Section("Write a review") {
    TextEditor(text: $review)
    RatingView(rating: $rating)
}
Our default values are sensible, so it looks great out of the box – go ahead and try it now!

Chances are you'll see things don't quite work right: no matter which star rating you press, it will select 5 stars!

I've seen this problem hit countless hundreds of people, no matter how much experience they have. The problem is that when we have rows inside a form or a list, SwiftUI likes to assume the rows themselves are tappable. This makes selection easier for users, because they can tap anywhere in a row to trigger the button inside it.

In our case we have multiple buttons, so SwiftUI is tapping them all in order – rating gets set to 1, then 2, then 3, 4, and 5, which is why it ends up at 5 no matter what.

We can disable the whole "tap the row to trigger its buttons" behavior with an extra modifier attached to the whole HStack:

.buttonStyle(.plain)
That makes SwiftUI treat each button individually, so everything works as planned. And the result is much nicer to use: there’s no need to tap into a detail view with a picker here, because star ratings are more natural and more common.


Building a list with @Query

Right now our ContentView has a query property like this:

@Query var books: [Book]
And we’re using it in body with this simple text view:

Text("Count: \(books.count)")
To bring this screen to life, we’re going to replace that text view with a List showing all the books that have been added, along with their rating and author.

We could just use the same star rating view here that we made earlier, but it’s much more fun to try something else. Whereas the RatingView control can be used in any kind of project, we can make a new EmojiRatingView that displays a rating specific to this project. All it will do is show one of five different emoji depending on the rating, and it’s a great example of how straightforward view composition is in SwiftUI – it’s so easy to just pull out a small part of your views in this way.

So, make a new SwiftUI view called “EmojiRatingView”, and give it the following code:

struct EmojiRatingView: View {
    let rating: Int

    var body: some View {
        switch rating {
        case 1:
            Text("1")
        case 2:
            Text("2")
        case 3:
            Text("3")
        case 4:
            Text("4")
        default:
            Text("5")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
Tip: I used numbers in my text because emoji can cause havoc with e-readers, but you should replace those with whatever emoji you think represent the various ratings.

Now we can return to ContentView and do a first pass of its UI. This will replace the existing text view with a list and a ForEach over books. We don’t need to provide an identifier for the ForEach because all SwiftData models conform to Identifiable automatically.

Inside the list we’re going to have a NavigationLink that point to the current book, and inside that we’ll have our new EmojiRatingView, plus the book’s title and author. So, replace the existing text view with this:

List {
    ForEach(books) { book in
        NavigationLink(value: book) {
            HStack {
                EmojiRatingView(rating: book.rating)
                    .font(.largeTitle)

                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
Tip: Make sure you leave the earlier modifiers in place - navigationTitle(), etc.

Navigation won't quite work because we haven't added navigationDestination() just yet, but that's okay – we’ll come back to this screen soon enough. First let’s build the detail view…