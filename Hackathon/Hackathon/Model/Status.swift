//
//  Status.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct Status {
    let code: Int
    let success: Bool
    let message: String
}

extension Status: Unmarshaling {
    init(object: MarshaledObject) throws {
        code = try object.value(for: "code")
        success = try object.value(for: "success")
        message = try object.value(for: "message")
    }

    var error: Error {
        switch code {
        case 0 ... 200:
            return APIManagerError.noError
        default:
            return APIManagerError.noError
        }
    }
}
