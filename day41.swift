Project 8, part 3
Today we’re going to be completing our Moonshot app by adding two more views plus navigation between them, but here is where you’ll start to see what it takes to create custom layouts in SwiftUI – we’ll be using container relative frames to get the view size exactly the way we want it, for example.

Along the way, we’re also going to be tackling one of the common problems you’ll face as programmer: when you have two pieces of separate data that need to be merged somehow. For us, that’s our astronaut and mission data, but the concept is transferrable enough as you’ll see.

At one point in today’s topics I encourage you to stop and play around with the design. I’m sure some folks will skip over this wanting to rush towards the end, but I hope you don’t. As the astronaut John Glenn said, “I suppose the quality in an astronaut more powerful than any other is curiosity – they have to get to some place nobody’s ever been.”

Be curious – take the time to explore your skills and it will pay off!

Today you have three topics to work through, in which you’ll work with container relative frames, ScrollView`, and more.


Showing mission details with ScrollView and containerRelativeFrame()

When the user selects one of the Apollo missions from our main list, we want to show information about the mission: its mission badge, its mission description, and all the astronauts that were on the crew along with their roles. The first two of those aren’t too hard, but the third requires a little more work because we need to match up crew IDs with crew details across our two JSON files.

Let’s start simple and work our way up: make a new SwiftUI view called MissionView.swift. Initially this will just have a mission property so that we can show the mission badge and description, but shortly we’ll add more to it.

In terms of layout, this thing needs to have a scrolling VStack with a resizable image for the mission badge, then a text view. We’ll use containerRelativeFrame() to set the width of the mission image – through some trial and error I found that the mission badge worked best when it wasn’t full width – somewhere between 50% and 70% width looked better, to avoid it becoming weirdly big on the screen.

Put this code into MissionView.swift now:

struct MissionView: View {
    let mission: Mission

    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    .padding(.top)

                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)

                    Text(mission.description)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}
Placing a VStack inside another VStack allows us to control alignment for one specific part of our view – our main mission image can be centered, while the mission details can be aligned to the leading edge.

Anyway, with that new view in place the code will no longer build, all because of the previews struct below it – that thing needs a Mission object passed in so it has something to render. Fortunately, our Bundle extension is available here as well:

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")

    return MissionView(mission: missions[0])
        .preferredColorScheme(.dark)
}
Tip: This view will automatically have a dark color scheme because it’s applied to the NavigationStack in ContentView, but the MissionView preview doesn’t know that so we need to enable it by hand.

If you look in the preview you’ll see that’s a good start, but the next part is trickier: we want to show the list of astronauts who took part in the mission below the description. Let’s tackle that next…


Merging Codable structs

Below our mission description we want to show the pictures, names, and roles of each crew member, which means matching up data that came from two different JSON files.

If you remember, our JSON data is split across missions.json and astronauts.json. This eliminates duplication in our data, because some astronauts took part in multiple missions, but it also means we need to write some code to join our data together – to resolve “armstrong” to “Neil A. Armstrong”, for example. You see, on one side we have missions that know crew member “armstrong” had the role “Commander”, but has no idea who “armstrong” is, and on the other side we have “Neil A. Armstrong” and a description of him, but no concept that he was the commander on Apollo 11.

So, what we need to do is make our MissionView accept the mission that got tapped, along with our full astronauts dictionary, then have it figure out which astronauts actually took part in the launch.

Add this nested struct inside MissionView now:

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}
Now for the tricky part: we need to add a property to MissionView that stores an array of CrewMember objects – these are the fully resolved role / astronaut pairings. At first that’s as simple as adding another property:

let crew: [CrewMember]
But then how do we set that property? Well, think about it: if we make this view be handed its mission and all astronauts, we can loop over the mission crew, then for each crew member look in the dictionary to find the one that has a matching ID. When we find one we can convert that and their role into a CrewMember object, but if we don’t it means somehow we have a crew role with an invalid or unknown name.

That latter case should never happen. To be clear, if you’ve added some JSON to your project that points to missing data in your app, you’ve made a fundamental mistake – it’s not the kind of thing you should try to write error handling for at runtime, because it should never be allowed to happen in the first place. So, this is a great example of where fatalError() is useful: if we can’t find an astronaut using their ID, we should exit immediately and complain loudly.

Let’s put all that into code, using a custom initializer for MissionView. Like I said, this will accept the mission it represents along with all the astronauts, and its job is to store the mission away then figure out the array of resolved astronauts.

Here’s the code:

init(mission: Mission, astronauts: [String: Astronaut]) {
    self.mission = mission

    self.crew = mission.crew.map { member in
        if let astronaut = astronauts[member.name] {
            return CrewMember(role: member.role, astronaut: astronaut)
        } else {
            fatalError("Missing \(member.name)")
        }
    }
}
As soon as that code is in, our preview struct will stop working again because it needs more information. So, add a second call to decode() there so it loads all the astronauts, then passes those in too:

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
Now that we have all our astronaut data, we can show this directly below the mission description using a horizontal scroll view. We’re also going to add a little extra styling to the astronaut pictures to make them look better, using a capsule clip shape and overlay.

Add this code just after the VStack(alignment: .leading):

ScrollView(.horizontal, showsIndicators: false) {
    HStack {
        ForEach(crew, id: \.role) { crewMember in
            NavigationLink {
                Text("Astronaut details")
            } label: {
                HStack {
                    Image(crewMember.astronaut.id)
                        .resizable()
                        .frame(width: 104, height: 72)
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(crewMember.astronaut.name)
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text(crewMember.role)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
Why after the VStack rather than inside? Because scroll views work best when they take full advantage of the available screen space, which means they should scroll edge to edge. If we put this inside our VStack it would have the same padding as the rest of our text, which means it would scroll strangely – the crew would get clipped as it hit the leading edge of our VStack, which looks odd.

We’ll make that NavigationLink do something more useful shortly, but first we need to modify the NavigationLink in ContentView – it pushes to Text("Detail View") right now, but please replace it with this:

MissionView(mission: mission, astronauts: astronauts)
Now go ahead and run the app in the simulator – it’s starting to become useful!

Before you move on, try spending a few minutes customizing the way the astronauts are shown – I’ve used a capsule clip shape and overlay, but you could try circles or rounded rectangles, you could use different fonts or larger images, or even add some way of marking who the mission commander was.

In my project, I think it would be useful to add a little visual separation in our mission view, so that the mission badge, description, and crew are more clearly split up.

SwiftUI does provide a dedicated Divider view for creating a visual divide in your layout, but it’s not customizable – it’s always just a skinny line. So, to get something a little more useful, I’m going to draw a custom divider to break up our view.

First, place this directly before the “Mission Highlights” text:

Rectangle()
    .frame(height: 2)
    .foregroundStyle(.lightBackground)
    .padding(.vertical)
Now place another one of those – the same code – directly after the mission.description text. Much better!

To finish up this view, I’m going to add a title before our crew, but this needs to be done carefully. You see, although this relates to the scroll view, it needs to have the same padding as the rest of our text. So, the best place for this is inside the VStack, directly after the previous rectangle:

Text("Crew")
    .font(.title.bold())
    .padding(.bottom, 5)
You don’t need to put it there – if you wanted we could move it outside the VStack then apply padding individually to that text view. However, if you do that make sure you apply the same amount of padding to keep everything neatly aligned.


Finishing up with one last view

To finish this program we’re going to make a third and final view to display astronaut details, which will be reached by tapping one of the astronauts in the mission view. This should mostly just be practice for you, but I hope it also shows you the importance of NavigationStack – we’re digging deeper into our app’s information, and the presentation of views sliding in and out really drives that home to the user.

Start by making a new SwiftUI view called AstronautView. This will have a single Astronaut property so it knows what to show, then it will lay that out using a similar ScrollView/VStack combination as we had in MissionView. Give it this code:

struct AstronautView: View {
    let astronaut: Astronaut

    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()

                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
Once again we need to update the preview so that it creates its view with some data:

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
Now we can present that from the NavigationLink inside MissionView. This points to Text("Astronaut details") right now, but we can update it to point to our new AstronautView instead:

AstronautView(astronaut: crewMember.astronaut)
That was easy, right? But if you run the app now you’ll see how natural it makes our user interface feel – we start at the broadest level of information, showing all our missions, then tap to select one specific mission, then tap to select one specific astronaut. iOS takes care of animating in the new views, but also providing back buttons and swipes to return to previous views.