//
//  Location.swift
//  Project14-BucketList
//
//  Created by Daniel Braga Barbosa on 27/12/24.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable
{
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D
    {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool
    {
        return lhs.id == rhs.id
    }
    
#if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40,000 lightbulbs.", latitude: 51.501, longitude: -0.141)
#endif
    
}
