//
//  Capacity.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct Capacity {

    let numberOfPieces: Int
    let weight: Double
}

extension Capacity: Unmarshaling, Marshaling {
    typealias MarshalType = [String: Any]
    init(object: MarshaledObject) throws {
        numberOfPieces = try object.value(for: "pieces")
        weight = try object.value(for: "weight")
    }

    func marshaled() -> Capacity.MarshalType {
        return ["pieces": numberOfPieces, "weight": weight]
    }
}

extension Capacity: Hashable, Equatable {

    static func == (lhs: Capacity, rhs: Capacity) -> Bool {
        return lhs.numberOfPieces == rhs.numberOfPieces && lhs.weight == rhs.weight
    }

    var hashValue: Int {
        return numberOfPieces.hashValue ^ weight.hashValue
    }
}
