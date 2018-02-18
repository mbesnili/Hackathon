//
//  SocketIOManager.swift
//  Sociable
//
//  Created by Skylab on 10/08/2017.
//  Copyright © 2017 Sociable. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    @objc static let sharedInstance = SocketIOManager()

    #if DEBUG
        let socketManager = SocketManager(socketURL: URL(string: "https://floating-reaches-70596.herokuapp.com/")!, config: [.forceWebsockets(true), .log(true), .reconnects(true), .reconnectAttempts(-1)])
    #else
        let socketManager = SocketManager(socketURL: URL(string: Config.sharedInstance.socketEndpointURL)!, config: [.forceWebsockets(true), .reconnects(true), .reconnectAttempts(-1)])
    #endif

    override init() {
        super.init()
        let socket = socketManager.defaultSocket

        socket.on(clientEvent: .disconnect) { _, _ in
        }

        socket.on(clientEvent: .connect) { _, _ in
        }

        socket.on(Constants.SocketEventKeys.packageStateChanged) { data, _ in
            guard let attributes = data[0] as? [[String: Any]] else {
                return
            }

            let packages = attributes.map({ (attribute) -> Package in
                try! Package(object: attribute)
            })
            NotificationCenter.default.post(name: Constants.Notifications.shouldUpdatePackageNotification, object: nil, userInfo: ["packages": packages])
        }
    }

    @objc func establishConnection(withToken _: String) {
        if let token = User.current?.token {
            socketManager.config.insert(.extraHeaders(["token": token]))
        }
        socketManager.connect()
    }

    @objc func closeConnection() {
        socketManager.disconnect()
    }
}
