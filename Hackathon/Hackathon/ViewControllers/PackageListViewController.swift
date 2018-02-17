//
//  PackageListViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import CoreLocation
import DeepDiff
import Permission
import UIKit

class PackageListViewController: BaseViewController {

    @IBOutlet var applyButton: UIButton!
    @IBOutlet var tableView: UITableView!

    var location: CLLocation?
    let locationManager = CLLocationManager()
    var locationDisabled = true
    let refreshControl = UIRefreshControl()

    var packages = [Package]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        NotificationCenter.default.addObserver(self, selector: #selector(updatePackage), name: Constants.shouldUpdatePackageNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func updatePackage(_ notification: Notification) {
        guard let package = notification.userInfo?["package"] as? Package else {
            return
        }
        let oldPackageIndex = packages.index { (p) -> Bool in
            return p.id == package.id
        }
        if oldPackageIndex != nil {
            packages[oldPackageIndex!] = package
        }
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
