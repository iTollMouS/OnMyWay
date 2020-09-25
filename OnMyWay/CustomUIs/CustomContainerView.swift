//
//  CustomContainerView.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/25/20.
//

import UIKit

class CustomContainerView: UIView {

    
    private lazy var dividerView = UIView()
    
    init(label: UILabel, labelHeight: CGFloat, textField: UITextField, textFieldHeight: CGFloat) {
        super.init(frame: .zero)
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        addSubview(stackView)
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        heightAnchor.constraint(equalToConstant: (labelHeight + textFieldHeight)).isActive = true
        stackView.centerX(inView: self)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 5)
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        dividerView.backgroundColor = .white

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
