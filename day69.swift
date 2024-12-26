Project 14, part 2

In the second part of our technique overview for this project, we’re going to look at two really important frameworks on iOS: MapKit for rendering maps in our app, and LocalAuthentication for using Touch ID and Face ID.

It won’t surprise you to learn that location, fingerprints, and facial recognition are really personal to users, which means we need to treat them with respect at all times. Remember, users trust us to treat their data with the utmost care and intention at all times, so it’s a good thing to get into the mindset that privacy, security, and trust are your core values rather than optional extras.

Elvis Presley is reputed to have once said, “values are like fingerprints: nobody’s are the same, but you leave them all over the things you touch.” Well, this project is at the center of the Venn diagram of both values and fingerprints, so stay sharp – this stuff matters.

Today you have two topics to work through, in which you’ll learn how embed maps into a SwiftUI app, how to use Face ID to unlock your app, and more.


Integrating MapKit with SwiftUI

Maps have been a core feature of iPhone since the very first device shipped way back in 2007, and the underlying framework has been available to developers for almost as long. Even better, Apple provides a SwiftUI Map view that wraps up the underlying map framework beautifully, letting us place maps, annotations, and more alongside the rest of our SwiftUI view hierarchy.

Let’s start with something simple: just showing a map. Maps and all their configuration data come from a dedicated framework called MapKit, so our first step is to import that framework:

import MapKit 
And now we can place a map in our SwiftUI view, with just this:

Map()
That's enough to show a map on the screen, so try running the app and take a moment to learn some key shortcuts in the simulator:

Hold down the Option key to trigger two-finger pinching. If you click and drag while option is held down, the virtual fingers will move closer or further.
Hold down Option and Shift to trigger two-finger panning. If you click and drag up and down while this combination is held down, you'll adjust the tilt of the map.
You can also mimic the single-finger zoom by tapping once, then tapping and dragging up or down.
Once you're in control of the map, there are stacks of options to customize it further.

For example, you can use the mapStyle() modifier to control how the map looks. You can get a satellite map like this:

Map()
    .mapStyle(.imagery)
Or combine both satellite and street map like this:

Map()
    .mapStyle(.hybrid)
Or you can get both maps along with realistic elevation, creating a 3D map, like this:

.mapStyle(.hybrid(elevation: .realistic))
You can adjust how the user can work with your map, such as whether they can zoom or rotate their position. For example, we could make a map that always remains centered on a particular location, but users can still adjust the rotation and zoom:

Map(interactionModes: [.rotate, .zoom])
Or we could specify no interaction modes, meaning that the map is always exactly fixed:

Map(interactionModes: [])
Those are all the easy customization options, but there are three that take a little more thinking: controlling the position, placing annotations, and handling taps.

First, you can customize the position of the camera. This can be done as an initial position, where you're setting how the map should start, or as a binding to its current position, which tracks its position over time.

For example, we could create a constant property storing the location of London, with a span specified as 1 degree by 1 degree:

let position = MapCameraPosition.region(
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )
)
We could then use that for the initial position of our map:

Map(initialPosition: position)
That value is only an initial position. If you want to change the position over time you'll need to mark it as @State then pass it in as a binding.

So, first make it use @State:

@State private var position = MapCameraPosition.region(
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )
)
Then pass it in as a binding:

Map(position: $position)
Now that's it's stored as program state, we can change it by adding some buttons to jump to other locations. For example, we could wrap the map in a VStack, then place this below it:

HStack(spacing: 50) {
    Button("Paris") {
        position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            )
        )
    }

    Button("Tokyo") {
        position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            )
        )
    }
}
Although we're now passing a binding to the map, we can't just read the location as the map moves around. Instead, we have a separate onMapCameraChange() modifier that tells us when the position changes, either immediately or once movement has ended.

For example, we could write get an update when they have finished dragging the map, then print it out:

Map(position: $position)
    .onMapCameraChange { context in
        print(context.region)
    }
Alternatively, you can have it post continuous updates like this:

Map(position: $position)
    .onMapCameraChange(frequency: .continuous) { context in
        print(context.region)
    }
You might think continuous mode is always preferable, but it's not that simple – if you're running a search on where the user has positioned the map, that's the kind of thing you'd want to do only when they have finished moving.

The second customizable thing I want to look at is placing annotations.

To do this takes at least three steps depending on your goal: defining a new data type that contains your location, creating an array of those containing all your locations, then adding them as annotations in the map. Whatever new data type you create to store locations, it must conform to the Identifiable protocol so that SwiftUI can identify each map marker uniquely.

For example, we might start with this kind of Location struct:

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}
Now we can go ahead and define an array of locations, wherever we want map annotations to appear:

let locations = [
    Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
    Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
]
Step three is the important part: we can feed that array of locations into the Map view as its content. SwiftUI provides us with a couple of different content types, but a simple one is called Marker: a balloon with a title and latitude/longitude coordinate attached.

For example, we could place markers at both our locations like so:

Map {
    ForEach(locations) { location in
        Marker(location.name, coordinate: location.coordinate)
    }
}
When that runs you’ll see two red balloons on the map, and even better you'll see the map adjusts its position and scale so the two markers are visible.

If you want more control over the way your markers look on the map, use an Annotation instead. This lets you provide a completely custom view to use instead of the standard system marker balloon, and if you prefer you can hide the default title so you can replace it with your own, like this:

Annotation(location.name, coordinate: location.coordinate) {
    Text(location.name)
        .font(.headline)
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(.capsule)
}
.annotationTitles(.hidden)
And finally, you can handle taps on the map using onTapGesture(). This tells us where on the map the user tapped, but it does so in screen coordinates – e.g., 50 points from the top, and 100 points from the left.

In order to get an actual location on the map, we need a special view called MapReader. When you wrap one of these around your map, you'll be handed a special MapProxy object that is able to convert screen locations to map locations and back the other way.

Use it like this:

MapReader { proxy in
    Map()
        .onTapGesture { position in
            if let coordinate = proxy.convert(position, from: .local) {
                print(coordinate)
            }
        }
}
Tip: The .local part means we're converting that position in the map's local coordinate space, meaning that the tap location we're working with is relative to the top-left corner of the map rather than the whole screen or some other coordinate space.


Using Touch ID and Face ID with SwiftUI

The vast majority of Apple’s devices come with biometric authentication as standard, which means they use fingerprint, facial, and even iris recognition to unlock. This functionality is available to us too, which means we can make sure that sensitive data can only be read when unlocked by a valid user.

This is another Objective-C API, but it’s only a little bit unpleasant to use with SwiftUI, which is better than we’ve had with some other frameworks we’ve looked at so far.

Before we write any code, you need to add a new key to your project options, explaining to the user why you want access to Face ID. For reasons known only to Apple, we pass the Touch ID request reason in code, and the Face ID request reason in project options.

So, select your current target, go to the Info tab, right-click on an existing key, then choose Add Row. Scroll through the list of keys until you find “Privacy - Face ID Usage Description” and give it the value “We need to unlock your data.”

Now head back to ContentView.swift, and add this import near the top of the file:

import LocalAuthentication
And with that, we’re all set to write some biometrics code.

I mentioned earlier this was “only a little bit unpleasant”, and here’s where it comes in: Swift developers use the Error protocol for representing errors that occur at runtime, but Objective-C uses a special class called NSError. We need to be able to pass that into the function and have it changed inside the function rather than returning a new value – although this was the standard in Objective-C, it’s quite an alien way of working in Swift so we need to mark this behavior specially by using &.

We’re going to write an authenticate() method that isolates all the biometric functionality in a single place. To make that happen requires four steps:

Create instance of LAContext, which allows us to query biometric status and perform the authentication check.
Ask that context whether it’s capable of performing biometric authentication – this is important because iPod touch has neither Touch ID nor Face ID.
If biometrics are possible, then we kick off the actual request for authentication, passing in a closure to run when authentication completes.
When the user has either been authenticated or not, our completion closure will be called and tell us whether it worked or not, and if not what the error was.
Please go ahead and add this method to ContentView:

func authenticate() {
    let context = LAContext()
    var error: NSError?

    // check whether biometric authentication is possible
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        // it's possible, so go ahead and use it
        let reason = "We need to unlock your data."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            // authentication has now completed
            if success {
                // authenticated successfully
            } else {
                // there was a problem
            }
        }
    } else {
        // no biometrics
    }
}
That method by itself won’t do anything, because it’s not connected to SwiftUI at all. To fix that we need to add some state we can adjust when authentication is successful, and also an onAppear() modifier to trigger authentication.

So, first add this property to ContentView:

@State private var isUnlocked = false
That simple Boolean will store whether the app is showing its protected data or not, so we’ll flip that to true when authentication succeeds. Replace the // authenticated successfully comment with this:

isUnlocked = true
Finally, we can show the current authentication state and begin the authentication process inside the body property, like this:

VStack {
    if isUnlocked {
        Text("Unlocked")
    } else {
        Text("Locked")
    }
}
.onAppear(perform: authenticate)
If you run the app there’s a good chance you just see “Locked” and nothing else. This is because the simulator isn’t opted in to biometrics by default, and we didn’t provide any error messages, so it fails silently.

To take Face ID for a test drive in the simulator, go to the Features menu and choose Face ID > Enrolled, then launch the app again. This time you should see the Face ID prompt appear, and you can trigger successful or failed authentication by going back to the Features menu and choosing Face ID > Matching Face or Non-matching Face.

All being well you should see the Face ID prompt go away, and underneath it will be the “Unlocked” text view – our app has detected the authentication, and is now open to use.

Important: When working with biometric authentication, you should always look for a backup plan that lets users authenticate without biometrics. This usually means adding a screen that prompts for a passcode then providing that as a fallback if biometrics fail, but this is something you need to build yourself.