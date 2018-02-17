//
//  PackageRoutesViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import MapKit

class PackageRoutesViewController: BaseViewController {

    @IBOutlet var pickUpButton: UIButton!
    @IBOutlet var finishTransportationButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: MKMapView!

    var getTransportationPackages: TransportationPackagesResponse?

    override func viewDidLoad() {
        title = R.string.localization.routesTitle()
        pickUpButton.setTitle(R.string.localization.routesPickUpButtonTitle(), for: [])
        finishTransportationButton.setTitle(R.string.localization.routesFinishButtonTitle(), for: [])

        mapView.delegate = self

        APIManager.getTransportationPackages { [weak self] rawTransportationPackages in
            switch rawTransportationPackages {
            case let .success(transportationPackages):
                self?.getTransportationPackages = transportationPackages
                self?.group(packages: transportationPackages.packages, with: transportationPackages.gatheringPoint)
            case let .failure(error):
                self?.showError(error: error)
            }
        }
        pickUpButton.isHidden = true
        finishTransportationButton.isHidden = true
    }

    func group(packages: [Package], with endingPoint: Location) {
        if packages.count == 1 {
            drawRoute(sourceCoordinate: CLLocationCoordinate2D(latitude: packages[0].coordinates.latitude, longitude: packages[0].coordinates.longitude), sourceTitle: packages[0].packageDescription, sourceSubtitle: packages[0].state.description, destinationCoordinate: CLLocationCoordinate2D(latitude: endingPoint.latitude, longitude: endingPoint.longitude), destinationTitle: R.string.localization.routesGatheringPointTitle())
        } else {
            drawRoute(sourceCoordinate: CLLocationCoordinate2D(latitude: packages[0].coordinates.latitude, longitude: packages[0].coordinates.longitude), sourceTitle: packages[0].packageDescription, sourceSubtitle: packages[0].state.description, destinationCoordinate: CLLocationCoordinate2D(latitude: packages[1].coordinates.latitude, longitude: packages[1].coordinates.longitude), destinationTitle: packages[1].packageDescription, completion: { [weak self] in
                var mutablePackages = packages
                mutablePackages.removeFirst()
                self?.group(packages: mutablePackages, with: endingPoint)
            })
        }
    }

    func drawRoute(sourceCoordinate: CLLocationCoordinate2D, sourceTitle: String, sourceSubtitle: String, destinationCoordinate: CLLocationCoordinate2D, destinationTitle: String, completion: (() -> Void)? = nil) {

        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = sourceTitle
        sourceAnnotation.subtitle = sourceSubtitle

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

    @IBAction func pickUpButtonTapped() {
    }

    @IBAction func finishTransportationButtonTapped() {
    }
}

extension PackageRoutesViewController: MKMapViewDelegate {

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }

    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        guard let response = getTransportationPackages else {
            return
        }

        guard let coordinate = view.annotation?.coordinate else {
            return
        }

        finishTransportationButton.isHidden = !(coordinate.latitude == response.gatheringPoint.latitude && coordinate.longitude == response.gatheringPoint.longitude)
        pickUpButton.isHidden = (coordinate.latitude == response.gatheringPoint.latitude && coordinate.longitude == response.gatheringPoint.longitude)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        let identifier = "MarkerIdentifier"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    func mapView(_: MKMapView, didDeselect _: MKAnnotationView) {
        pickUpButton.isHidden = true
        finishTransportationButton.isHidden = true
        addressLabel.text = nil
    }

    func mapView(_: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation else {
            return
        }

        let package = getTransportationPackages?.packages.filter({ (package) -> Bool in
            package.coordinates.latitude == annotation.coordinate.latitude && package.coordinates.longitude == annotation.coordinate.longitude
        }).first
        if package != nil {
            addressLabel.text = package!.address
        }
    }
}
