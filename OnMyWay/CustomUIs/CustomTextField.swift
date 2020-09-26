//
//  CustomTextField.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//

import UIKit

class CustomTextField: UITextField {

    init(textColor: UIColor, placeholder: String, placeholderColor: UIColor , isSecure: Bool = false) {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes:[.foregroundColor : placeholderColor])
        self.textColor = textColor
        keyboardAppearance = .dark
        self.isSecureTextEntry = isSecure
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
