//
//  TransportationPackagesResponse.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct TransportationPackagesResponse {

    let status: Status
    let packages: [Package]
    let gatheringPoint: Location
}

extension TransportationPackagesResponse: Unmarshaling {

    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        packages = try object.value(for: "packages")
        gatheringPoint = try object.value(for: "gatheringPoint")
    }
}
