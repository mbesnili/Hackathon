//
//  User.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Marshal

struct User {

    enum DefaultKeys {
        static let token = Bundle.main.bundleIdentifier! + ".token"
        static let username = Bundle.main.bundleIdentifier! + ".username"
    }

    let token: String
    let username: String

    static var current: User? {
        didSet {
            if current == nil {
                UserDefaults.standard.removeObject(forKey: DefaultKeys.token)
                UserDefaults.standard.removeObject(forKey: DefaultKeys.username)
            } else {
                UserDefaults.standard.setValue(current!.token, forKey: DefaultKeys.token)
                UserDefaults.standard.setValue(current!.username, forKey: DefaultKeys.username)
            }
            UserDefaults.standard.synchronize()
        }
    }

    static func restoreIfLoggedIn() {
        guard let token = UserDefaults.standard.string(forKey: DefaultKeys.token), let username = UserDefaults.standard.string(forKey: DefaultKeys.username) else {
            return
        }
        User.current = User(token: token, username: username)
    }
}

extension User: Unmarshaling {
    init(object: MarshaledObject) throws {
        token = try object.value(for: "token")
        username = try object.value(for: "username")
    }
}
