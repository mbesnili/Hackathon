//
//  PackagePinPointAnnotation.swift
//  Hackathon
//
//  Created by mbesnili on 18.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import MapKit

class PackagePinPointAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: package.coordinates.latitude, longitude: package.coordinates.longitude)
    }

    var title: String? {
        return package.packageDescription
    }

    var subtitle: String? {
        return package.state.description
    }

    let package: Package

    init(package: Package) {
        self.package = package
    }
}
