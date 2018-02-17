//
//  Location.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import CoreLocation
import Foundation
import Marshal

struct Location {
    let longitude: Double
    let latitude: Double
}

extension Location: Unmarshaling, Marshaling, LocationProtocol {
    typealias MarshalType = [String: Any]

    init(object: MarshaledObject) throws {
        latitude = try object.value(for: "latitude")
        longitude = try object.value(for: "longitude")
    }

    func marshaled() -> Location.MarshalType {
        return ["lat": latitude, "lon": longitude]
    }
}

extension Location {
    func equals(coordinates: CLLocationCoordinate2D) -> Bool {
        return latitude == coordinates.latitude && longitude == coordinates.longitude
    }
}

typealias CheckPoint = Location
