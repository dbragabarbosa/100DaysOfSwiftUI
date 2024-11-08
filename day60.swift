Milestone: Projects 10-12
That’s another three projects done, and more really important techniques under your belt. No matter how beautiful your design or how clever your app idea, it’s nearly always the case that handling your users’ data well is the most important thing for any good app.

Of course, the real discussion is what “well” means. At the very least I hope it means “with respect” – you don’t share anything without their consent, you don’t track their activity without permission, and you store any personal data carefully. Beyond that, you might want to add searching or filtering, you might want cloud synchronization so their data is shared across devices, you might want to let them browse or modify the raw data, and so on.

Regardless of what you do with it, learning to work with user data is a great skill to have, and you’ve taken lots of steps forward in these last three projects.

Now it’s time for a challenge, and unsurprisingly it will involve fetching, processing, and displaying lots of data. You already have all the skills you need to make this a great app, so all that remains is for you to crack open a new Xcode project and get stuck in.

Will you make mistakes? Yes – and that’s OK. British author Neil Gaiman had some advice that I hope will serve you well:

I hope that in this year to come, you make mistakes. Because if you are making mistakes, then you are making new things, trying new things, learning, living, pushing yourself, changing yourself, changing your world. You're doing things you've never done before, and more importantly, you're doing something.

Today you have three topics to work through, one of which of is your challenge.


What you learned
These last three projects have really pushed hard on data, starting first with sending and receiving data using the internet, then going into SwiftData so you can see how real apps manage their data. The skills you’ve learned in this projects are perhaps more important than you realize, because if you put them all together you can now fetch data from the internet, store it locally, and let users filter to find the stuff they care about.

Here’s a quick recap of all the new things we covered in the last three projects:

Building custom Codable conformance
Sending and receiving data using URLSession
The disabled() modifier for views
Building custom UI components using @Binding
Adding multiple buttons to an alert
Editing SwiftData objects using @Bindable.
Using @Query to query SwiftData objects
Sorting SwiftData results using SortDescriptor
Filtering data using #Predicate
Creating relationships between SwiftData models
Syncing SwiftData with iCloud

That’s a comparatively short list compared to some other projects, but I think it’s fair to say these topics have been a real step up: SwiftData is hard in places, particularly in the way we need to work to get dynamic sorting and filtering, but it's definitely worth it!


Key points
Although we’ve covered a lot in these last three projects, there is one thing in particular I’d like to cover in more detail: advanced usages of Codable. We already looked at this a little in our projects, but it's a topic that deserves some additional time as you’ll see…

Tip: If you want to know how to make SwiftData models work with Codable, you should read this fully.

Custom Codable keys
When we have JSON data that matches the way we’ve designed our types, Codable works perfectly. In fact, we often don’t need to do anything other than add Codable conformance – the Swift compiler will synthesize everything we need automatically.

However, a lot of the time things aren’t so straightforward, and there are three options for working with more complex data:

Asking Swift to convert property names automatically.
Creating custom property name conversions.
Creating completely custom encoding and decoding.
Generally speaking you should prefer them in that order, with option 1 being most preferable and option 3 being least.

Let's work through the first two, one at a time. I'll leave option 3 for the time being, because it's comparatively tricky!

Asking Swift to convert property names automatically is useful when our incoming JSON uses a different naming convention for its properties. For example, we might receive JSON property names in snake case (e.g. first_name) whereas our Swift code uses property names in camel case (e.g. firstName).

Codable is able to translate between these two as long as it knows what to expect: we need to set a property on our decoder called keyDecodingStrategy.

To demonstrate this, here’s a User struct with two properties:

struct User: Codable {
    var firstName: String
    var lastName: String
}
That uses the naming convention typically used in Swift code, called camel case because the practice of uppercasing the first letters of words is a bit like humps on a camels back.

Now here is some JSON data with the same two properties:

let str = """
{
    "first_name": "Andrew",
    "last_name": "Glouberman"
}
"""

let data = Data(str.utf8)
That JSON data uses snake case, which is a naming convention where property names are written all in lowercase with words separated by underscores.

If we try to decode that JSON into a User instance, it won’t work because the two properties have different naming styles:

do {
    let decoder = JSONDecoder()

    let user = try decoder.decode(User.self, from: data)
    print("Hi, I'm \(user.firstName) \(user.lastName)")
} catch {
    print("Whoops: \(error.localizedDescription)")
} 
However, if we modify the key decoding strategy before we call decode(), we can ask Swift to convert snake case to and from camel case. So, this will succeed:

do {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let user = try decoder.decode(User.self, from: data)
    print("Hi, I'm \(user.firstName) \(user.lastName)")
} catch {
    print("Whoops: \(error.localizedDescription)")
} 
That works great when we’re converting snake_case to and from camelCase, but what if our property names are completely different? This is where we need to rely on the second option: creating custom property name conversions.

As an example, take a look at this JSON:

let str = """
{
    "first": "Andrew",
    "last": "Glouberman"
}
"""
It still has the first and last name of a user, but the property names don’t match our struct at all.

When we were looking at Codable I said that we can create an enum of coding keys that describe which keys should be encoded and decoded. At the time I said “this enum is conventionally called CodingKeys, with an S on the end, but you can call it something else if you want,” and while that’s true it’s not the whole story.

You see, the reason we conventionally use CodingKeys for the name is that this name has super powers: if a CodingKeys enum exists, Swift will automatically use it to decide how to encode and decode an object for times we don’t provide custom Codable implementations.

I realize that’s a lot to take in, so it’s best demonstrated with some code. Try changing the User struct to this:

struct User: Codable {
    enum ZZZCodingKeys: CodingKey {
        case firstName
    }

    var firstName: String
    var lastName: String
}
That code will compile just fine, because the name ZZZCodingKeys is meaningless to Swift – it’s just a nested enum. But if you rename the enum to just CodingKeys you’ll find the code no longer builds: we’re now instructing Swift to encode and decode just the firstName property, which means there is no initializer that handles setting the lastName property - and that’s not allowed.

All this matters because CodingKeys has a second super power: when we attach raw value strings to our properties, Swift will use those for the JSON property names. That is, the case names should match our Swift property names, and the case values should match the JSON property names.

So, let’s return to our example JSON:

let str = """
{
    "first": "Andrew",
    "last": "Glouberman"
}
"""
That uses “first” and “last” for property names, whereas our User struct uses firstName and lastName. This is a great place where CodingKeys can come to the rescue: we don’t need to write a custom Codable conformance, because we can just add coding keys that marry up our Swift property names to the JSON property names, like this:

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }

    var firstName: String
    var lastName: String
}
Now that we have specifically told Swift how to convert between JSON and Swift naming, we no longer need to use keyDecodingStrategy – just adding that enum is enough.

So, while you do need to know how to create custom Codable conformance, it’s generally best practice to do without it if these other options are possible.

Completely custom Codable implementations
So far you've seen how to let Swift map between snake case and camel case, and how we can specify mappings when JSON has one name and Swift uses an entirely different one.

This last option is for times when the changes are even bigger, such as if the JSON data provides a number as a string. However, it's also useful when you want to make SwiftData models conform to Codable, as you'll see.

First, let's try some new JSON that demonstrates the problem:

let str = """
{
    "first": "Andrew",
    "last": "Glouberman",
    "age": "13"
}

As you can see, that has unhelpful names for first name and last, but also stores a number inside a string. While there's very little we can do to fix up JSON data coming from an external server, we certainly don't want its weirdness to infect our code – that's an integer, and we want it to be stored as one in our Swift code.

So, we might define a User struct like this, so we correct the first and last name properties, and store age as an integer:

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case age
    }

    var firstName: String
    var lastName: String
    var age: Int
}
But now we have a problem: while Swift can convert the property names for us, it can't handle different data types.

For this we need to create a completely custom Codable implementation which means adding two things to the User struct:

A new initializer that accepts a Decoder instance and knows how to read our properties from it.
A new encode(to:) method that accepts an Encoder instance and knows how to write our properties to it.
Tip: Swift uses Decoder and Encoder here because there are lots of ways of converting data to and from Swift objects – JSON is just one of several options.

Both of these take quite a bit of code, but helpfully Xcode can sometimes help. In this case it will actually fill in all the code required to make both these work: type init in the space below the properties, then press return with init(from decoder: Decoder) selected, then type encode and press return with encode(to encoder: Encoder) selected.

Your finished User struct should look like this:

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case age
    }

    var firstName: String
    var lastName: String
    var age: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.age = try container.decode(Int.self, forKey: .age)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.age, forKey: .age)
    }
}
Tip: If this were a class rather than a struct, the new initializer would need to be marked with required so that any subclasses are required to implement it.

That's a lot of code, but really only four lines matter: two from the initializer, and two from encode(to:).

The first line that matters is this, from the initializer:

let container = try decoder.container(keyedBy: CodingKeys.self)
That uses CodingKeys to read all the possible keys that can be loaded from the JSON file. This looks in the CodingKeys enum, so we can refer to things like .firstName and .age.

The second line that matters is this, also from the initializer:

self.firstName = try container.decode(String.self, forKey: .firstName)
That reads a string from the key .firstName, and assigns it to the firstName property of our struct. This part might be a bit confusing because we have firstName twice, so let me rephrase what the line of code does: "look in the JSON to find the property matching CodingKeys.firstName, and assign it to our local firstName value."

This little dance matters, because CodingKeys.firstName isn't actually called firstName because we renamed it to match our JSON. So, in practice this line actually means "find the first property in the JSON and assign it to firstName in our struct" – it makes sure all the automatic renaming still happens.

If it helps, imagine reading the code like this:

self.structFirstName = try container.decode(String.self, forKey: .jsonFirstName)
That's the first two interesting lines of code. The second two are effectively inverses of the first two. These are both in the encode(to:) method:

var container = encoder.container(keyedBy: CodingKeys.self)
try container.encode(self.firstName, forKey: .firstName)
That first line means we want to create a place where we can store all our CodingKeys values, and the second one writes the current firstName property to whatever is specified in CodingKeys.firstName – again, that's important so we get the automatic renaming to first.

At this point, chances are you're wondering how you'll ever remember this code, because it's not exactly something you can guess. So, here's my #1 tip:

When you need to implement a custom Codable implementation and Xcode can't generate it for you, just create a new, simple struct with one property and a one-case CodingKeys enum, have Xcode generate that, then use its implementation to help you build your own for the bigger type.

This is particularly important when working with SwiftData, where adding Codable support means create a custom implementation. It's annoying to have to remember all the code above, and Xcode almost certainly won't help, so just create a temporary struct that Xcode can generate a Codable implementation for, then use its structure to make your SwiftData model class Codable.

Anyway, we got to this point because we were trying to load a string into an integer, which means making two changes to the code Xcode generated for us.

First, this line of code needs to change:

self.age = try container.decode(Int.self, forKey: .age)
That attempts to read the age property as an integer, which will fail. Instead, we need to read it as a string, then convert that to an integer or provide a default value if conversion fails. Replace the code with this:

let stringAge = try container.decode(String.self, forKey: .age)
self.age = Int(stringAge) ?? 0
The second thing that needs to change is in encode(to:), so if we need to write any JSON we keep the existing format. Here, this line needs to change:

try container.encode(self.age, forKey: .age)
That writes an integer, but it needs to write a string like this:

try container.encode(String(self.age), forKey: .age)
I know creating the custom implementation seems like a lot of hassle, but as you can see it gives us exact control over what happens: we can add any kind of logic to our loading and saving, changing names, changing types, providing default values, and more.


Challenge
It’s time for you to build an app from scratch, and it’s a particularly expansive challenge today: your job is to use URLSession to download some JSON from the internet, use Codable to convert it to Swift types, then use NavigationStack, List, and more to display it to the user.

Your first step should be to examine the JSON. The URL you want to use is this: https://www.hackingwithswift.com/samples/friendface.json – that’s a massive collection of randomly generated data for example users.

As you can see, there is an array of people, and each person has an ID, name, age, email address, and more. They also have an array of tag strings, and an array of friends, where each friend has a name and ID.

How far you implement this is down to you, but at the very least you should:

Fetch the data and parse it into User and Friend structs.
Display a list of users with a little information about them, such as their name and whether they are active right now.
Create a detail view shown when a user is tapped, presenting more information about them, including the names of their friends.
Before you start your download, check that your User array is empty so that you don’t keep starting the download every time the view is shown.
If you’re not sure where to begin, start by designing your types: build a User struct with properties for name, age, company, and so on, then a Friend struct with id and name. After that, move onto some URLSession code to fetch the data and decode it into your types.

You might notice that the date each user registered has a very specific format: 2015-11-10T01:47:18-00:00. This is known as ISO-8601, and is so common that there’s a built-in dateDecodingStrategy called .iso8601 that decodes it automatically.

While you’re building this, I want you to keep one thing in mind: this kind of app is the bread and butter of iOS app development – if you can nail this with confidence, you’re well on your way to a full-time job as an app developer.