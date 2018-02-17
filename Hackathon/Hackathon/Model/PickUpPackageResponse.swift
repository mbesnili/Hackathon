//
//  ConfirmReceiveResponse.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct PickUpPackageResponse {

    let status: Status
    let package: Package
}

extension PickUpPackageResponse: Unmarshaling {
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        package = try object.value(for: "package")
    }
}
