//
//  PackageListViewController.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Permission
import UIKit

class PackageListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let permission: Permission = .locationAlways
        permission.request { _ in
        }
    }
}
