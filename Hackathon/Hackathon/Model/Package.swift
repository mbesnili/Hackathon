//
//  Package.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct Package {

    enum State: String {
        case available
        case claimed
        case beingCarried
        case delivered
    }

    let id: String
    let capacity: Capacity
    let coordinates: Location
    let packageDescription: String
    let state: String
}

extension Package: Unmarshaling {
    init(object: MarshaledObject) throws {
        id = try object.value(for: "_id")
        capacity = try object.value(for: "capacity")
        coordinates = try object.value(for: "coordinates")
        packageDescription = (try? object.value(for: "description")) ?? ""
        state = try object.value(for: "state")
    }
}
