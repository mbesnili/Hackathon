//
//  ConfirmReceiveResponse.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct ConfirmReceiveResponse {

    let status: Status
}

extension ConfirmReceiveResponse: Unmarshaling {
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
    }
}
