//
//  PackageRoutesViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import MapKit

class PackageRoutesViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {

        mapView.delegate = self

        APIManager.getTransportationPackages { [weak self] rawTransportationPackages in
            switch rawTransportationPackages {
            case let .success(transportationPackages):
                self?.group(packages: transportationPackages.packages, with: transportationPackages.gatheringPoint)
            case let .failure(error):
                self?.showError(error: error)
            }
        }
    }

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }

    func group(packages: [Package], with endingPoint: Location) {
        if packages.count == 1 {
            drawRoute(sourceCoordinate: CLLocationCoordinate2D(latitude: packages[0].coordinates.latitude, longitude: packages[0].coordinates.longitude), sourceTitle: packages[0].packageDescription, destinationCoordinate: CLLocationCoordinate2D(latitude: endingPoint.latitude, longitude: endingPoint.longitude), destinationTitle: "Gathering point")
        } else {
            drawRoute(sourceCoordinate: CLLocationCoordinate2D(latitude: packages[0].coordinates.latitude, longitude: packages[0].coordinates.longitude), sourceTitle: packages[0].packageDescription, destinationCoordinate: CLLocationCoordinate2D(latitude: packages[1].coordinates.latitude, longitude: packages[1].coordinates.longitude), destinationTitle: packages[1].packageDescription, completion: { [weak self] in
                var mutablePackages = packages
                mutablePackages.removeFirst()
                self?.group(packages: mutablePackages, with: endingPoint)
            })
        }
    }

    func drawRoute(sourceCoordinate: CLLocationCoordinate2D, sourceTitle: String, destinationCoordinate: CLLocationCoordinate2D, destinationTitle: String, completion: (() -> Void)? = nil) {

        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = sourceTitle

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = destinationTitle

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        directions.calculate { [weak self]
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self?.mapView.add(route.polyline, level: .aboveRoads)

            let rect = route.polyline.boundingMapRect
            self?.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            completion?()
        }
    }
}
