//
//  CLLocationExtensions.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import CoreLocation

extension CLLocation: LocationProtocol {
    var latitude: Double {
        return coordinate.latitude
    }

    var longitude: Double {
        return coordinate.longitude
    }

    func marshaled() -> [String: Any] {
        return ["latitude": latitude, "longitude": longitude]
    }
}
