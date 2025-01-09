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
    @State private var viewModel = ViewModel()
    
    @State private var mapStyle: String = "standard"
    
    @State var showingAlert = false
    
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
            Picker("Map Style", selection: $mapStyle)
            {
                Text("Standard").tag("Standard")
                Text("Hybrid").tag("Hybrid")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            MapReader
            { proxy in
                Map(initialPosition: startPosition)
                {
                    ForEach(viewModel.locations)
                    { location in
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
                .mapStyle(mapStyle == "Standard" ? .standard : .hybrid)
                .onTapGesture
                { position in
                    if let coordinate = proxy.convert(position, from: .local)
                    {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace)
                { place in
                    EditView(location: place)
                    {
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
