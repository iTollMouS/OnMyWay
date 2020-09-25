//
//  CustomAuthenticationLabel.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/25/20.
//

import UIKit

class CustomAuthenticationLabel: UILabel {
    
    init(labelText: String) {
        super.init(frame: .zero)
        text = labelText
        textAlignment = .left
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
