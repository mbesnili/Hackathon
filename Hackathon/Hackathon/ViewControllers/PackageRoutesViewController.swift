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

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var timelineTableView: UITableView!
    var getTransportationPackages: TransportationPackagesResponse?

    var currentLocation: CLLocation!

    override func viewDidLoad() {
        title = R.string.localization.routesTitle()

        mapView.delegate = self

        startAnimating()
        APIManager.getTransportationPackages(latitude: currentLocation.latitude, longitude: currentLocation.longitude) { [weak self] rawTransportationPackages in
            self?.stopAnimating()
            switch rawTransportationPackages {
            case let .success(transportationPackages):
                if transportationPackages.packages.count == 0 {
                    self?.showError(error: BusinessError.noRoutesFound)
                } else {
                    self?.getTransportationPackages = transportationPackages
                    self?.group(packages: transportationPackages.packages, with: transportationPackages.gatheringPoint)
                    self?.timelineTableView.reloadData()
                }
            case let .failure(error):
                self?.showError(error: error)
            }
        }
        timelineTableView.tableFooterView = UIView(frame: .zero)
        timelineTableView.register(cellType: TimelineTableViewCell.self)
        timelineTableView.separatorStyle = .none
    }

    func group(packages: [Package], with endingPoint: Location) {

        var annotations = [MKPointAnnotation]()

        let userLocationAnnotation = MKPointAnnotation()
        userLocationAnnotation.coordinate = currentLocation.coordinate
        userLocationAnnotation.title = "User's location"
        annotations.append(userLocationAnnotation)

        let packageAnnotations = packages.map { (package) -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: package.coordinates.latitude, longitude: package.coordinates.longitude)
            annotation.title = package.packageDescription
            annotation.subtitle = package.state.description
            return annotation
        }

        annotations.append(contentsOf: packageAnnotations)

        let endingPointAnnotation = MKPointAnnotation()
        userLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: endingPoint.latitude, longitude: endingPoint.longitude)
        userLocationAnnotation.title = R.string.localization.routesGatheringPointTitle()
        annotations.append(endingPointAnnotation)

        draw(annotations: annotations)
    }

    func draw(annotations: [MKPointAnnotation]) {
        if annotations.count < 2 {
            return
        } else if annotations.count == 2 {
            draw(source: annotations[0], destination: annotations[1])
        } else {
            draw(source: annotations[0], destination: annotations[1], completion: { [weak self] in
                var mutableAnnotations = annotations
                mutableAnnotations.removeFirst()
                self?.draw(annotations: mutableAnnotations)
            })
        }
    }

    func draw(source: MKPointAnnotation, destination: MKPointAnnotation, completion: (() -> Void)? = nil) {

        let sourcePlacemark = MKPlacemark(coordinate: source.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        mapView.addAnnotation(source)
        mapView.addAnnotation(destination)

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

extension PackageRoutesViewController: MKMapViewDelegate {

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.red]
        let polylineRenderer = JLTGradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        polylineRenderer.lineWidth = 7
        return polylineRenderer
    }

    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        guard let response = getTransportationPackages else {
            return
        }

        guard let coordinate = view.annotation?.coordinate else {
            return
        }
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
        }
        return view
    }

    func mapView(_: MKMapView, didDeselect _: MKAnnotationView) {
    }

    func mapView(_: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation else {
            return
        }

        let package = getTransportationPackages?.packages.filter({ (package) -> Bool in
            package.coordinates.latitude == annotation.coordinate.latitude && package.coordinates.longitude == annotation.coordinate.longitude
        }).first
        if package != nil {
        }
    }
}

extension PackageRoutesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in _: UITableView) -> Int {
        guard let packages = getTransportationPackages?.packages else {
            return 0
        }
        return packages.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        if indexPath.section == getTransportationPackages!.packages.count {
            cell.addressLabel.text = ""
            cell.descriptionLabel.text = R.string.localization.routesGatheringPointTitle()
            cell.actionButton.setTitle(R.string.localization.routesFinishButtonTitle(), for: [])
            cell.actionButton.isHidden = !getTransportationPackages!.packages.readyToFinish
        } else {
            let index = getTransportationPackages!.packages.index { (package) -> Bool in
                return package.state == .claimed
            }
            if index == indexPath.section {
                cell.actionButton.isHidden = false
                cell.actionButton.setTitle(R.string.localization.routesPickUpButtonTitle(), for: [])
            } else {
                cell.actionButton.isHidden = true
            }
            cell.addressLabel.text = getTransportationPackages!.packages[indexPath.section].address
            cell.descriptionLabel.text = getTransportationPackages!.packages[indexPath.section].packageDescription
        }

        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let _ = getTransportationPackages?.packages else {
            return 0
        }
        return 1
    }
}
