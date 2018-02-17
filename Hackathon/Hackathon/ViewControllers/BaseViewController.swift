//
//  ViewController.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class BaseViewController: UIViewController {

    private lazy var indicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: (view.bounds.width - NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE.width) / 2, y: (view.bounds.height - NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE.height) / 2), size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE), type: .ballScaleMultiple, color: UIColor.blue)

    func startAnimating() {
        if indicatorView.superview == nil {
            view.addSubview(indicatorView)
        }
        indicatorView.startAnimating()
    }

    func stopAnimating() {
        indicatorView.stopAnimating()
    }
}
