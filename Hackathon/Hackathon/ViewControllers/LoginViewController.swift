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
        usernameTextField.placeholder = R.string.localization.loginUsernamePlaceholderText()
        passwordTextField.placeholder = R.string.localization.loginPasswordPlaceholderText()
        loginButton.setTitle(R.string.localization.loginLoginButtonTitle(), for: [])
    }
}
