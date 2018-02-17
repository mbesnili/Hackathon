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
    let weight: Float
    let numberOfPieces: Int
    let location: Location
    let packageDescription: String
    let state: String
}

extension Package: Unmarshaling {
    init(object: MarshaledObject) throws {
        id = try object.value(for: "_id")
        weight = try object.value(for: "weight")
        numberOfPieces = try object.value(for: "numberOfPieces")
        location = try object.value(for: "location")
        packageDescription = try object.value(for: "description")
        state = try object.value(for: "state")
    }
}
