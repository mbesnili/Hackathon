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
    case routes
    case packageReceive(id: String)
    case finishTransportation

    var path: String {
        switch self {
        case .list:
            return "package/list"
        case .routes:
            return "transportation/apply"
        case .packageReceive:
            return "package/receive"
        case .finishTransportation:
            return "transportation/finish"
        }
    }

    var parameters: APIParams {
        switch self {
        case .list:
            return nil
        case .routes:
            return nil
        case let .packageReceive(id: id):
            return ["id": id]
        case .finishTransportation:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return Alamofire.HTTPMethod.get
        case .routes:
            return Alamofire.HTTPMethod.post
        case .packageReceive:
            return Alamofire.HTTPMethod.post
        case .finishTransportation:
            return Alamofire.HTTPMethod.post
        }
    }
}
