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
//    @State private var locations = [Location]()
//    @State private var selectedPlace: Location?
    
    @State private var viewModel = ViewModel()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View
    {
        if viewModel.isUnlocked
        {
            MapReader
            { proxy in
                Map(initialPosition: startPosition)
                {
                    ForEach(viewModel.locations)
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
                                viewModel.selectedPlace = location
                            }
                        }
                    }
                }
                .mapStyle(.hybrid)
                .onTapGesture
                { position in
                    if let coordinate = proxy.convert(position, from: .local)
                    {
                        //                    let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        //                    viewModel.locations.append(newLocation)
                        
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace)
                { place in
                    
                    //                Text(place.name)
                    
                    EditView(location: place)
                    {
                        //                { newLocation in
                        
                        //                    if let index = viewModel.locations.firstIndex(of: place)
                        //                    {
                        //                        viewModel.locations[index] = newLocation
                        //                    }
                        
                        viewModel.update(location: $0)
                    }
                }
            }
        }
        else
        {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
        
    }
}

#Preview
{
    ContentView()
}
