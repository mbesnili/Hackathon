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

        socket.on("connect") { _, _ in
        }

        socket.on("packageStateChanged") { data, _ in
            print("data: \(data)")
        }

        socket.on(clientEvent: .disconnect) { _, _ in
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
