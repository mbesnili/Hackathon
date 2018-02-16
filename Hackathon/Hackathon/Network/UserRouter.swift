//
//  UserRouter.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Alamofire
import Foundation

enum UserRouter: APIConfiguration {

    var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .check:
            return "/user/check"
        }
    }

    var parameters: APIParams {
        switch self {
        case let .login(username: username, password: password):
            return ["username": username, "password": password]
        case let .check(location: location, weight: weight, numberOfPieces: numberOfPieces):
            return ["location": location.marshaled(), "weight": weight, "numberOfPieces": numberOfPieces]
        }
    }

    case login(username: String, password: String)
    case check(location: Location, weight: Float, numberOfPieces: Int)

    var method: HTTPMethod {
        switch self {
        case .login(username: _, password: _):
            return Alamofire.HTTPMethod.post
        case .check:
            return Alamofire.HTTPMethod.post
        }
    }
}
