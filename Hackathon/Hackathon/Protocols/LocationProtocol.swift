//
//  LocationProtocol.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation

protocol LocationProtocol {
    var latitude: Double { get }
    var longitude: Double { get }

    func marshaled() -> [String: Any]
}
