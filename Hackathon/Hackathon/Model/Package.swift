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
    let state: State
    let address: String
}

extension Package: Unmarshaling {
    init(object: MarshaledObject) throws {
        id = try object.value(for: "_id")
        capacity = try object.value(for: "capacity")
        coordinates = try object.value(for: "coordinates")
        packageDescription = (try? object.value(for: "description")) ?? ""
        state = try object.value(for: "state")
        address = (try? object.value(for: "address")) ?? ""
    }
}

extension Package: CustomStringConvertible {
    var description: String {
        let numberOfPieces = R.string.localization.piece_count(value: capacity.numberOfPieces)
        let weight = Formatter.mass.string(fromKilograms: capacity.weight)
        return [packageDescription, numberOfPieces, weight].joined(separator: ", ")
    }
}

extension Package: Equatable, Hashable {

    static func == (lhs: Package, rhs: Package) -> Bool {
        return lhs.address == rhs.address && lhs.id == rhs.id && lhs.coordinates == rhs.coordinates && lhs.packageDescription == rhs.packageDescription && lhs.state == rhs.state && lhs.address == rhs.address
    }

    var hashValue: Int {
        return id.hashValue ^ capacity.hashValue ^ coordinates.hashValue ^ packageDescription.hashValue ^ state.hashValue ^ address.hashValue
    }
}

extension Package.State: CustomStringConvertible {
    var displayColor: UIColor {
        switch self {
        case .available:
            return UIColor.green
        case .beingCarried:
            return UIColor.orange
        case .claimed:
            return UIColor.darkGray
        case .delivered:
            return UIColor.red
        }
    }

    var description: String {
        switch self {
        case .available:
            return R.string.localization.packagesPackageStateAvailable()
        case .beingCarried:
            return R.string.localization.packagesPackageStateBeingCarried()
        case .claimed:
            return R.string.localization.packagesPackageStateClaimed()
        case .delivered:
            return R.string.localization.packagesPackageStateDelivered()
        }
    }
}
