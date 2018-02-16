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
    }
}
