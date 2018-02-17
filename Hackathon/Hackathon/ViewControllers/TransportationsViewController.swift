//
//  TransportationsViewController.swift
//  Hackathon
//
//  Created by mbesnili on 18.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import UIKit

class TransportationsViewController: BaseViewController {

    enum Constants {
        static let cellIdentifier = "Cell"
    }

    @IBOutlet var newTransportationButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!

    var unfinishedTransactionFound = false {
        didSet {
            tableView.reloadData()
            newTransportationButton.isEnabled = !unfinishedTransactionFound
        }
    }

    var transactionPackagesResponse: TransportationPackagesResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localization.transportationsTitle()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: R.string.localization.userLogoutTitle(), style: .done, target: self, action: #selector(logoutButtonTapped))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }

    @objc func logoutButtonTapped() {
        User.current = nil
        AppDelegate.shared?.loggedOut()
        navigationController?.viewControllers.removeAll()
        navigationController?.removeFromParentViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.getTransportation { [weak self] rawResponse in
            switch rawResponse {
            case let .success(response):
                self?.transactionPackagesResponse = response
                self?.unfinishedTransactionFound = true
            case .failure:
                break
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let typedInfo = R.segue.transportationsViewController.showPackageRoutes(segue: segue) {
            typedInfo.destination.getTransportationPackages = transactionPackagesResponse
        }
    }
}

extension TransportationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if unfinishedTransactionFound {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = R.string.localization.transportationsTitle()
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        performSegue(withIdentifier: R.segue.transportationsViewController.showPackageRoutes, sender: nil)
    }
}
