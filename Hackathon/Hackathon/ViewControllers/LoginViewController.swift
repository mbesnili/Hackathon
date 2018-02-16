//
//  LoginViewController.swift
//  Hackathon
//
//  Created by mbesnili on 16.02.2018.
//  Copyright © 2018 mbesnili. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localization.loginTitle()
        usernameTextField.placeholder = R.string.localization.loginUsernamePlaceholderText()
        passwordTextField.placeholder = R.string.localization.loginPasswordPlaceholderText()
        loginButton.setTitle(R.string.localization.loginLoginButtonTitle(), for: [])
    }

    @IBAction func loginButtonTapped() {
        APIManager.login(with: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] rawLoginResponse in
            switch rawLoginResponse {
            case let .success(loginResponse):
                if loginResponse.status.success {
                    self?.performSegue(withIdentifier: R.segue.loginViewController.seguePackageList, sender: nil)
                } else {
                    self?.showError(error: loginResponse.status.error)
                }
            case let .failure(error):
                self?.showError(error: error)
            }
        }
    }
}
