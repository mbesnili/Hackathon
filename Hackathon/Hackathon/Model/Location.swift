//
//  Location.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct Location {
    let latitude: Double
    let longitude: Double
}

extension Location: Unmarshaling {
    init(object: MarshaledObject) throws {
        latitude = try object.value(for: "latitude")
        longitude = try object.value(for: "longitude")
    }
}

typealias CheckPoint = Location
