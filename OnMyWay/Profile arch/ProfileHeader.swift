//
//  ProfileHeader.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/30/20.
//

import UIKit
import Cosmos

class ProfileHeader: UIView {

    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 100, width: 100)
        imageView.layer.cornerRadius = 100 / 2
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tariq Almazyad"
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.setHeight(height: 50)
        return label
    }()
    
    
    private lazy var userStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "I am using chat"
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.setHeight(height: 50)
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, userStatusLabel])
        stackView.axis = .vertical
        stackView.spacing = -20
        stackView.distribution = .fill
        return stackView
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, userInfoStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.setWidth(width: 100)
        return stackView
    }()
    
    
    private lazy var ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.filledImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
        view.settings.filledColor = .blueLightIcon
        view.settings.emptyImage = UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyColor = .white
        view.settings.starSize = 24
        view.settings.totalStars = 5
        view.settings.starMargin = 3.0
        view.text = "Reviews (5/4.2)"
        view.settings.textColor = .lightGray
        view.settings.textMargin = 10
        view.settings.textFont = UIFont.systemFont(ofSize: 14)
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.setDimensions(height: 50, width: 250)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(stackView)
        stackView.centerX(inView: self, topAnchor: topAnchor, paddingTop: 20)
        addSubview(ratingView)
        ratingView.centerX(inView: stackView, topAnchor: stackView.bottomAnchor, paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
