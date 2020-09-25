//
//  ViewController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/25/20.
//

import UIKit


class ViewController: UIViewController {
    
    private lazy var emailLabel = CustomAuthenticationLabel(labelText: "Email")
    private lazy var emailTextField = CustomAuthenticationTextField(placeholder: "Email",
                                                                    isSecureTextEntry: false, textAlignment: .left)
    private lazy var emailContainerView = CustomContainerView(label: emailLabel,
                                                              labelHeight: 50,
                                                              textField: emailTextField,
                                                              textFieldHeight: 70)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emailContainerView)
        emailContainerView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 50)
        emailContainerView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.0862745098, blue: 0.0862745098, alpha: 1)
        emailLabel.backgroundColor = .clear
        emailTextField.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        emailContainerView.backgroundColor = .clear
    }
    
}

