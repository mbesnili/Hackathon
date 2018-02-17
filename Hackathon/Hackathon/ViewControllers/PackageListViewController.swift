//
//  PackageListViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import CoreLocation
import Permission
import UIKit

class PackageListViewController: BaseViewController {

    @IBOutlet var applyButton: UIButton!
    @IBOutlet var tableView: UITableView!

    let locationManager = CLLocationManager()

    var packages = [Package]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localization.packagesTitle()

        applyButton.setTitle(R.string.localization.packagesDeliverPackagesButtonTitle(), for: [])

        tableView.register(cellType: PackageTableViewCell.self)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        let permission: Permission = .locationAlways
        permission.request { [weak self] status in
            switch status {
            case .authorized:
                self?.locationManager.startUpdatingLocation()
            case .notDetermined:
                fallthrough
            case .disabled:
                fallthrough
            case .denied:
                self?.applyButton.isEnabled = false
            }
        }

        APIManager.listPackages { [weak self] rawPackages in
            switch rawPackages {
            case let .success(listPackagesResponse):
                if listPackagesResponse.status.success {
                    self?.packages = listPackagesResponse.packages
                } else {
                    self?.showError(error: listPackagesResponse.status.error)
                }
            case let .failure(error):
                self?.showError(error: error)
            }
        }
    }
}

extension PackageListViewController: CLLocationManagerDelegate {

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.first {
            APIManager.check(location: location, capacity: Capacity(numberOfPieces: 20, weight: 7.0), completion: { _ in
            })
        }
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
