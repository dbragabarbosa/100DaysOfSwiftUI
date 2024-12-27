//
//  ContentView.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 23/12/24.
//

import SwiftUI
import MapKit

struct ContentView: View
{
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View
    {
        MapReader
        { proxy in
            Map(initialPosition: startPosition)
            {
                ForEach(locations)
                { location in
                    
//                    Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    
                    Annotation(location.name, coordinate: location.coordinate)
                    {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture
                            {
                                selectedPlace = location
                            }
                    }
                }
            }
            .mapStyle(.hybrid)
            .onTapGesture
            { position in
                if let coordinate = proxy.convert(position, from: .local)
                {
                    let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locations.append(newLocation)
                }
            }
            .sheet(item: $selectedPlace)
            { place in
                
//                Text(place.name)
                
                EditView(location: place)
                { newLocation in
                    
                    if let index = locations.firstIndex(of: place)
                    {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview
{
    ContentView()
}
