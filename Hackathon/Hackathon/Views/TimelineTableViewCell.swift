//
//  TimelineTableViewCell.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import Reusable
import UIFontComplete

final class TimelineTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var stackView: UIStackView!

    override func awakeFromNib() {

        super.awakeFromNib()

        descriptionLabel.font = Font.helveticaNeueMedium.of(size: 20.0)
        addressLabel.font = Font.helveticaNeue.of(size: 16.0)

        descriptionLabel.textColor = UIColor.black
        addressLabel.textColor = UIColor.black

        actionButton.isHidden = true
    }
}
