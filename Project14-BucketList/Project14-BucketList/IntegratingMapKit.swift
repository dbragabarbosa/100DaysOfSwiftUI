//
//  IntegratingMapKit.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 26/12/24.
//

import SwiftUI
import MapKit

struct LocationModel: Identifiable
{
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct IntegratingMapKit: View
{
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    let locations = [
        LocationModel(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        LocationModel(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    var body: some View
    {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
//        Map()
        
//        Map()
//            .mapStyle(.imagery)
        
//        Map()
//            .mapStyle(.hybrid)
            
//        Map()
//            .mapStyle(.hybrid(elevation: .realistic))
        
//        Map(interactionModes: [.rotate, .zoom])
        
//        VStack
//        {
//            Map(position: $position)
//                .onMapCameraChange(frequency: .continuous) { context in
//                    print(context.region)
//                }
//            
//            HStack(spacing: 50)
//            {
//                Button("Paris")
//                {
//                    position = MapCameraPosition.region(
//                        MKCoordinateRegion(
//                            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
//                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//                        )
//                    )
//                }
//                
//                Button("Tokyo")
//                {
//                    position = MapCameraPosition.region(
//                        MKCoordinateRegion(
//                            center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
//                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//                        )
//                    )
//                }
//            }
//        }
        
        
//        Map {
//            ForEach(locations) { LocationModel in
////                Marker(LocationModel.name, coordinate: LocationModel.coordinate)
//                
//                Annotation(LocationModel.name, coordinate: LocationModel.coordinate) {
//                    Text(LocationModel.name)
//                        .font(.headline)
//                        .padding()
//                        .background(.blue)
//                        .foregroundStyle(.white)
//                        .clipShape(.capsule)
//                }
//                .annotationTitles(.hidden)
//            }
//        }
        
        
        MapReader { proxy in
            Map()
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
        }
        
    }
}

#Preview {
    IntegratingMapKit()
}
