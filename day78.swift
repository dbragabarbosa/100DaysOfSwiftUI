Time for MapKit
Yesterday you built a new app that imports photos from the user’s library, and hopefully you’re pleased with the finished product – or at least making great progress towards the finished product.

But your boss has come in and demanded a new feature: when you’re viewing a picture that was imported, you should show a map with a pin that marks where they were when that picture was added. It might be on the same screen side by side with the photo, it might be shown or hidden using a segmented control, or perhaps it’s on a different screen – it’s down to you. Regardless, you know how to drop pins, and you also know how to use the center coordinate of map views, so the only thing left to figure out is how to get the user’s location to save alongside their text and image.

Although I do want you to push your skills, I’m not cruel. So, here’s a class that fetches the user’s location:

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
To use that, start by adding a new key in the Info tab for your app's target, just like we did when we wanted Face ID permission. This key is called “Privacy - Location When In Use Usage Description”, then give it some sort of value explaining to the user why you need their location.

Now you can use it inside SwiftUI view like this:

struct ContentView: View {
    let locationFetcher = LocationFetcher()

    var body: some View {
        VStack {
            Button("Start Tracking Location") {
                locationFetcher.start()
            }

            Button("Read Location") {
                if let location = locationFetcher.lastKnownLocation {
                    print("Your location is \(location)")
                } else {
                    print("Your location is unknown")
                }
            }
        }
    }
}
If you’re using the simulator rather than a real device, you can fake a location by going to the Debug menu and choosing Location > Apple.