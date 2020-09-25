//
//  CustomAuthenticationTextField.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/25/20.
//

import UIKit

class CustomAuthenticationTextField: UITextField {

    init(placeholder: String, isSecureTextEntry: Bool, textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.textAlignment = textAlignment
        self.textColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
