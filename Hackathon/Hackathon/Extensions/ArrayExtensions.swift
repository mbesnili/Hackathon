//
//  ArrayExtensions.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation

extension Array where Element == Package {
    var readyToFinish: Bool {
        return (filter { (package) -> Bool in
            package.state != Package.State.beingCarried
        }.count == 0)
    }
}
