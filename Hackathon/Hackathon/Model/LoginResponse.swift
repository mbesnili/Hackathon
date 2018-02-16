//
//  LoginResponse.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct LoginResponse {
    let status: Status
}

extension LoginResponse: Unmarshaling {
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
    }
}
