//
//  PackageRouter.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Alamofire
import Foundation

enum PackageRouter: APIConfiguration {

    case list

    var path: String {
        switch self {
        case .list:
            return "package/list"
        }
    }

    var parameters: APIParams {
        switch self {
        case .list:
            return [:]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return Alamofire.HTTPMethod.get
        }
    }
}
