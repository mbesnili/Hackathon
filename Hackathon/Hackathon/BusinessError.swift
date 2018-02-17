//
//  BusinessError.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation

enum BusinessError: Error {
    case noRoutesFound
    case noLocationFound

    var pushBack: Bool {
        switch self {
        case .noRoutesFound:
            return true
        case .noLocationFound:
            return false
        }
    }
}

extension BusinessError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noRoutesFound:
            return R.string.localization.errorNoRoutesFound()
        case .noLocationFound:
            return R.string.localization.errorNoLocationFound()
        }
    }
}
