//
//  AppDelegate.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Alamofire
import Foundation

public typealias JSONDictionary = [String: AnyObject]
typealias APIParams = [String: Any]?

protocol APIConfiguration: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var parameters: APIParams { get }
    var baseUrl: String { get }
}

extension APIConfiguration {
    var baseUrl: String {
        #if DEBUG
            return "http://192.168.88.65:3000/"
        #else
            return "http://192.168.88.65:3000/"
        #endif
    }
}

extension APIConfiguration {
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        return urlRequest
    }
}
