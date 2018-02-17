//
//  PackageTableViewCell.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Reusable

final class PackageTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet var packageDescriptionLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    func prepare(with: Package) {
        packageDescriptionLabel.text = with.id
        capacityLabel.text = "weight: \(with.capacity.weight), number of piece: \(with.capacity.numberOfPieces)"
        statusLabel.text = with.state
    }
}
