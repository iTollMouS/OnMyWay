//
//  ProfileHeader.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/30/20.
//

import UIKit
import Cosmos

protocol ProfileHeaderDelegate: class {
    
    func handleUpdatePhoto(_ header: ProfileHeader)
    
}

class ProfileHeader: UIView {

    weak var delegate: ProfileHeaderDelegate?
    
     lazy var profileImageView: UIButton = {
        let imageView = UIButton(type: .system)
        imageView.setDimensions(height: 100, width: 100)
        imageView.layer.cornerRadius = 100 / 2
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        imageView.layer.masksToBounds = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    private lazy var editImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit image"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.setHeight(height: 20)
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tariq Almazyad"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.setHeight(height: 50)
        return label
    }()
    
    
    private lazy var userStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "I am using chat"
        label.textAlignment = .center
        label.textColor = .gray
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
    
    private lazy var ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.filledImage = #imageLiteral(resourceName: "RatingStarFilled").withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = #imageLiteral(resourceName: "RatingStarEmpty").withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 24
        view.settings.totalStars = 5
        view.settings.starMargin = 3.0
        view.text = "Reviews (5/4.2)"
        view.settings.textColor = .lightGray
        view.settings.textMargin = 10
        view.settings.textFont = UIFont.systemFont(ofSize: 14)
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        view.setDimensions(height: 50, width: 250)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(profileImageView)
        profileImageView.centerX(inView: self, topAnchor: topAnchor, paddingTop: 20)
        addSubview(userInfoStackView)
        userInfoStackView.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 20)
        userInfoStackView.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 20)
        addSubview(ratingView)
        ratingView.centerX(inView: userInfoStackView, topAnchor: userInfoStackView.bottomAnchor, paddingTop: 12)
        addSubview(editImageLabel)
        editImageLabel.centerX(inView: profileImageView, topAnchor: profileImageView.bottomAnchor, paddingTop: 2)
    }
    
    @objc func handleSelectPhoto(){
        delegate?.handleUpdatePhoto(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
