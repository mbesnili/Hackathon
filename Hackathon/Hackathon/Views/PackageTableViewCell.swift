//
//  PackageTableViewCell.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Reusable
import UIFontComplete

final class PackageTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet var packageIdTextLabel: UILabel!
    @IBOutlet var packageDescriptionLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    func prepare(with: Package) {
        let mediumBoldAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: Font.helveticaNeueMedium.of(size: 16.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.black,
        ]
        let packageIdAttributedString = NSMutableAttributedString(string: R.string.localization.packagesPackageId(), attributes: mediumBoldAttributes)
        packageIdAttributedString.append(NSAttributedString(string: with.id, attributes: [
            NSAttributedStringKey.font: Font.helveticaNeue.of(size: 16.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.black,
        ]))

        packageIdTextLabel.attributedText = packageIdAttributedString

        let packageDescriptionAttributedString = NSMutableAttributedString(string: R.string.localization.packagesPackageDescription(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: Font.helveticaNeueMedium.of(size: 16.0)!])

        packageDescriptionAttributedString.append(NSAttributedString(string: with.description, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: Font.helveticaNeue.of(size: 16.0)!]))

        packageDescriptionLabel.attributedText = packageDescriptionAttributedString

        let statusLabelAttributedString = NSMutableAttributedString(string: R.string.localization.packagesPackageStatus(), attributes: [NSAttributedStringKey.font: Font.helveticaNeueMedium.of(size: 16.0)!, NSAttributedStringKey.foregroundColor: UIColor.black])
        statusLabelAttributedString.append(NSAttributedString(string: with.state.description, attributes: [
            NSAttributedStringKey.foregroundColor: with.state.displayColor,
            NSAttributedStringKey.font: Font.helveticaNeue.of(size: 16.0)!,
        ]))
        statusLabel.attributedText = statusLabelAttributedString
    }
}
