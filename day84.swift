Project 16, part 6

This has been a long project with lots to learn, but today marks the last of the code. As the American professor Angela Duckworth said, “enthusiasm is common; endurance is rare” – it took enthusiasm to start day 1 of this series, but here you are on day 84 just finishing a huge project, so it’s clear you’ve got great endurance as well.

This project has already drawn upon some important SwiftUI features such as tab bars, swipe actions, and the environment; some important Swift features such as importing external packages and Result; and even some important iOS features such as Core Image and scanning codes with the camera. Today we’re going to add the icing on the cake, which is adding a context menu, and showing alerts using the UserNotification framework.

This is what great apps look like: they lean on a variety of language and system features to build great user experiences that go beyond what SwiftUI can do by itself. Yes, SwiftUI is an awesome way to build apps, but it’s only the beginning – iOS is capable of so much more, and as much as it sounds like a cliche the only limit to what you can make is your imagination.

Today you have two topics to work through, in which you’ll add a context menu to save our QR code, then show local notifications using the UserNotifications framework.


Adding a context menu to an image

We’ve already written code that dynamically generates a QR code based on the user’s name and email address, but with a little extra code we can also let the user share that QR code outside the app. This is another example of where ShareLink comes in handy, although this time we'll place it inside a context menu.

Start by opening MeView.swift, and adding the contextMenu() modifier to the QR code image, like this:

Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
    .interpolation(.none)
    .resizable()
    .scaledToFit()
    .frame(width: 200, height: 200)
    .contextMenu {
        let image = generateQRCode(from: "\(name)\n\(emailAddress)")

        ShareLink(item: Image(uiImage: image), preview: SharePreview("My QR Code", image: Image(uiImage: image)))
    }
As you can see, we need to convert the UIImage of our QR code to a SwiftUI Image view, which can then be handed to the system's share sheet.

We could save a little work by caching the generated QR code, however a more important side effect of that is that we wouldn’t have to pass in the name and email address each time – duplicating that data means if we change one copy in the future we need to change the other too.

To add this change, first add a new @State property that will store the code we generate:

@State private var qrCode = UIImage()
Now modify generateQRCode() so that it quietly stores the new code in our cache before sending it back:

if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
    qrCode = UIImage(cgImage: cgimg)
    return qrCode
}
And now our context menu button can use the cached code:

.contextMenu {
    ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
}
Before you try the context menu yourself, make sure you add the same project option we had for the Instafilter project – you need to add a permission request string to your project’s configuration options.

In case you’ve forgotten how to do that, here are the steps you need:

Open your target settings
Select the Info tab
Right-click on an existing option
Choose Add Row
Select “Privacy - Photo Library Additions Usage Description” for the key name.
Enter “We want to save your QR code.” as the value.
And now go ahead and run the app – you're likely to find things don't work quite as planned. In fact, back in Xcode you might see a purple warning line in the generateQRCode() method: "Modifying state during view update, this will cause undefined behavior."

What this means is that our current view body calls generateQRCode() to create the shareable image that we're attaching our context menu to, but calling that method now saves a value in the qrCode property we marked with @State, which in turn causes the view body to be reinvoked – it creates a loop, so SwiftUI bails out and flags a big warning for us.

To fix this we need to make the Image view use our cached QR code, like this:

Image(uiImage: qrCode)
And then use a combination of onAppear() and onChange() to make sure the code is updated when the view is first shown, and also when either the name or email address changes.

This means creating a new method that updates our code in one place:

func updateCode() {
    qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
}
Then attaching some extra modifiers below navigationTitle():

.onAppear(perform: updateCode)
.onChange(of: name, updateCode)
.onChange(of: emailAddress, updateCode)
Tip: Now that updateCode() updates the value of qrCode directly, we can go back to the earlier version of generateQRCode(), which simply returns the new value:

if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
    return UIImage(cgImage: cgimg)
}
Now this step is done, and done properly – you should be able to run the app, switch to the Me tab, then long press the QR code to bring up your new context menu.


Posting notifications to the lock screen

For the final part of our app, we’re going to add another button to our list swipe actions, letting users opt to be reminded to contact a particular person. This will use iOS’s UserNotifications framework to create a local notification, and we’ll conditionally include it in the swipe actions as part of our existing if check – the button will only be shown if the user hasn’t been contacted already.

Much more interesting is how we schedule the local notifications. Remember, the first time we try this we need to use requestAuthorization() to explicitly ask for permission to show a notification on the lock screen, but we also need to be careful subsequent times because the user can retroactively change their mind and disable notifications.

One option is to call requestAuthorization() every time we want to post a notification, and honestly that works great: the first time it will show an alert, and all other times it will immediately return success or failure based on the previous response.

However, in the interests of completion I want to show you a more powerful alternative: we can request the current authorization settings, and use that to determine whether we should schedule a notification or request permission. The reason it’s helpful to use this approach rather than just requesting permission repeatedly, is that the settings object handed back to us includes properties such as alertSetting to check whether we can show an alert or not – the user might have restricted this so all we can do is display a numbered badge on our icon.

So, we’re going to call getNotificationSettings() to read whether notifications are currently allowed. If they are, we’ll show a notification. If they aren’t, we’ll request permissions, and if that comes back successfully then we’ll also show a notification. Rather than repeat the code to schedule a notification, we’ll put it inside a closure that can be called in either scenario.

Start by adding this import near the top of ProspectsView.swift:

import UserNotifications
Now add this method to the ProspectsView struct:

func addNotification(for prospect: Prospect) {
    let center = UNUserNotificationCenter.current()

    let addRequest = {
        let content = UNMutableNotificationContent()
        content.title = "Contact \(prospect.name)"
        content.subtitle = prospect.emailAddress
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    // more code to come
}
That puts all the code to create a notification for the current prospect into a closure, which we can call whenever we need. Notice that I’ve used UNCalendarNotificationTrigger for the trigger, which lets us specify a custom DateComponents instance. I set it to have an hour component of 9, which means it will trigger the next time 9am comes about.

Tip: For testing purposes, I recommend you comment out that trigger code and replace it with the following, which shows the alert five seconds from now:

let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
For the second part of that method we’re going to use both getNotificationSettings() and requestAuthorization() together, to make sure we only schedule notifications when allowed. This will use the addRequest closure we defined above, because the same code can be used if we have permission already or if we ask and have been granted permission.

Replace the // more code to come comment with this:

center.getNotificationSettings { settings in
    if settings.authorizationStatus == .authorized {
        addRequest()
    } else {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                addRequest()
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}
That’s all the code we need to schedule a notification for a particular prospect, so all that remains is to add an extra button to our swipe actions – add this below the “Mark Contacted” button:

Button("Remind Me", systemImage: "bell") {
    addNotification(for: prospect)
}
.tint(.orange)
That completes the current step, and completes our project too – try running it now and you should find that you can add new prospects, then press and hold to either mark them as contacted, or to schedule a contact reminder.

Good job!