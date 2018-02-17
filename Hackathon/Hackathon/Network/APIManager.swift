//
//  APIManager.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Alamofire
import Foundation

enum APIManagerError: Error {
    case noError
    case parsingError
}

class APIManager {

    static func login(with username: String, password: String, completion: @escaping (Result<LoginResponse>) -> Void) {
        #if DEBUG
            let data = try! Data(contentsOf: R.file.loginResponseJson()!, options: Data.ReadingOptions.alwaysMapped)
            guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], let loginResponse = try? LoginResponse(object: dictionary) else {
                return
            }
            completion(.success(loginResponse))
        #else
            Alamofire.request(UserRouter.login(username: username, password: password)).responseJSON { rawResponse in
                switch rawResponse.result {
                case let .failure(error):
                    completion(.failure(error))
                case let .success(response):
                    guard let responseDictionary = response as? [String: Any] else {
                        return
                    }
                    if let loginResponse = try? LoginResponse(object: responseDictionary) {
                        completion(.success(loginResponse))
                    } else {
                        completion(.failure(APIManagerError.parsingError))
                    }
                }
            }
        #endif
    }

    static func check(location: LocationProtocol, capacity: Capacity, completion: @escaping (Result<CheckResponse>) -> Void) {
        #if DEBUG
            Alamofire.request(UserRouter.check(location: location, capacity: capacity)).responseJSON { rawResponse in
                switch rawResponse.result {
                case let .failure(error):
                    completion(.failure(error))
                case let .success(response):
                    guard let responseDictionary = response as? [String: Any] else {
                        return
                    }
                    if let checkResponse = try? CheckResponse(object: responseDictionary) {
                        completion(.success(checkResponse))
                    } else {
                        completion(.failure(APIManagerError.parsingError))
                    }
                }
            }
        #else

        #endif
    }
}
