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
    case routes(latitude: Double, longitude: Double)
    case packageReceive(id: String)
    case finishTransportation
    case getTransportation

    var path: String {
        switch self {
        case .list:
            return "package/list"
        case .routes:
            return "transportation/apply"
        case .packageReceive:
            return "package/pickUp"
        case .finishTransportation:
            return "transportation/finish"
        case .getTransportation:
            return "transportation/get"
        }
    }

    var parameters: APIParams {
        switch self {
        case .list:
            return nil
        case let .routes(latitude: latitude, longitude: longitude):
            return ["coordinates": ["latitude": latitude, "longitude": longitude]]
        case let .packageReceive(id: id):
            return ["packageId": id]
        case .finishTransportation:
            return nil
        case .getTransportation:
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
        case .getTransportation:
            return Alamofire.HTTPMethod.get
        }
    }
}
