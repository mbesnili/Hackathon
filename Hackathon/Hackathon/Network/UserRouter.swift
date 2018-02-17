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
        case let .check(location: location, capacity):
            return ["coordinates": location.marshaled(), "capacity": capacity.marshaled()]
        }
    }

    case login(username: String, password: String)
    case check(location: LocationProtocol, capacity: Capacity)

    var method: HTTPMethod {
        switch self {
        case .login(username: _, password: _):
            return Alamofire.HTTPMethod.post
        case .check:
            return Alamofire.HTTPMethod.post
        }
    }
}
