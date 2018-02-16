//
//  UIViewControllerExtensions.swift
//  Hackathon
//
//  Created by mbesnili on 17.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(error: Error) {
        let alertController = UIAlertController(title: R.string.localization.errorTitle(), message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localization.commonOkTitle(), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
