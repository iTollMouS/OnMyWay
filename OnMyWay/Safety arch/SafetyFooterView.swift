//
//  SafetyFooterView.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/28/20.
//

import UIKit

class SafetyFooterView: UIView {

    private lazy var reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Okay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blueLightIcon
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleReport), for: .touchUpInside)
        button.layer.cornerRadius = 50 / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(reportButton)
        reportButton.anchor(left: leftAnchor, right: rightAnchor,
                            paddingLeft: 32, paddingRight: 32)
        reportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reportButton.centerY(inView: self)
    }
    
    @objc func handleReport(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
