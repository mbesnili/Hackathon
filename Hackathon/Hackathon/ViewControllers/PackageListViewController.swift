//
//  PackageListViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import CoreLocation
import DeepDiff
import MapKit
import Permission
import UIKit

class PackageListViewController: BaseViewController {

    enum ListType {
        case map
        case table

        mutating func toggle() {
            switch self {
            case .map:
                self = .table
            case .table:
                self = .map
            }
        }

        var image: UIImage {
            switch self {
            case .map:
                return #imageLiteral(resourceName: "icons8-menu-filled-50")
            case .table:
                return #imageLiteral(resourceName: "icons8-map-50")
            }
        }
    }

    @IBOutlet var applyButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var containerView: UIView!

    var listType = ListType.table
    var location: CLLocation?
    let locationManager = CLLocationManager()
    var locationDisabled = true
    let refreshControl = UIRefreshControl()

    var packages = [Package]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.alpha = 1.0
        mapView.alpha = 0.0

        title = R.string.localization.packagesTitle()
        applyButton.setTitle(R.string.localization.packagesDeliverPackagesButtonTitle(), for: [])

        tableView.register(cellType: PackageTableViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        let permission: Permission = .locationAlways
        permission.request { [weak self] status in
            switch status {
            case .authorized:
                self?.startAnimating()
                self?.locationDisabled = false
                self?.locationManager.startUpdatingLocation()
            case .notDetermined:
                fallthrough
            case .disabled:
                fallthrough
            case .denied:
                self?.locationDisabled = true
            }
        }

        refreshControlValueChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePackage), name: Constants.Notifications.shouldUpdatePackageNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func prepareMapView() {
        let annotations = packages.map { (package) -> PackagePinPointAnnotation in
            let annotation = PackagePinPointAnnotation(package: package)
            return annotation
        }
        mapView.showAnnotations(annotations, animated: true)
    }

    @objc func updatePackage(_ notification: Notification) {

        guard let newPackages = notification.userInfo?["packages"] as? [Package] else {
            return
        }
        for package in newPackages {
            let oldPackageIndex = packages.index { (p) -> Bool in
                return p.id == package.id
            }
            if oldPackageIndex != nil {
                packages[oldPackageIndex!] = package
            }

            guard let annotations = mapView.annotations as? [PackagePinPointAnnotation] else {
                return
            }
            let annotationIndex = annotations.index(where: { (a) -> Bool in
                a.package.id == package.id
            })
            if annotationIndex != nil {
                mapView.removeAnnotation(annotations[annotationIndex!])
                mapView.addAnnotation(PackagePinPointAnnotation(package: package))
            }
        }
        tableView.reloadData()
    }

    @objc func refreshControlValueChanged() {
        APIManager.listPackages { [weak self] rawPackages in
            self?.refreshControl.endRefreshing()
            switch rawPackages {
            case let .success(response):
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.packages.count == 0 {
                    strongSelf.packages = response.packages
                    strongSelf.tableView.reloadData()
                } else {
                    let oldPackages = strongSelf.packages
                    strongSelf.packages = response.packages
                    let changes = diff(old: strongSelf.packages, new: oldPackages)
                    strongSelf.tableView.reload(changes: changes) { _ in
                    }
                }
                strongSelf.prepareMapView()
            case let .failure(error):
                self?.showError(error: error)
            }
        }
    }

    @IBAction func fetchRoutesTapped(_: Any) {
        if location == nil {
            showError(error: BusinessError.noLocationFound)
            return
        }
        performSegue(withIdentifier: R.segue.packageListViewController.seguePackageRoutes, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if location == nil {
            showError(error: BusinessError.noLocationFound)
            return
        }

        if let typedInfo = R.segue.packageListViewController.seguePackageRoutes(segue: segue) {
            typedInfo.destination.currentLocation = location!
        }
    }

    @IBAction func rightBarButtonItemTapped(_: Any) {
        listType.toggle()
        rightBarButtonItem.image = listType.image

        UIView.transition(with: containerView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.tableView.alpha = 1 - self.tableView.alpha
            self.mapView.alpha = 1 - self.mapView.alpha
        }) { _ in
        }
    }
}

extension PackageListViewController: CLLocationManagerDelegate {

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            APIManager.check(location: location, capacity: Capacity(numberOfPieces: 20, weight: 30), completion: { [weak self] _ in
                self?.stopAnimating()
            })
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        stopAnimating()
        showError(error: error)
    }
}

extension PackageListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return packages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PackageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.prepare(with: packages[indexPath.row])
        return cell
    }
}

extension PackageListViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PackagePinPointAnnotation else { return nil }
        let identifier = "MarkerIdentifier"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.markerTintColor = annotation.package.state.displayColor
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.markerTintColor = annotation.package.state.displayColor
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
