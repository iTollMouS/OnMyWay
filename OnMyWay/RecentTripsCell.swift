//
//  RecentTripsCell.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/28/20.
//

import UIKit

class RecentTripsCell: UITableViewCell {
    
    
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.setDimensions(height: 50, width: 50)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 / 2
        return imageView
    }()

    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/9/2020"
        label.textAlignment = .center
        label.textColor = .blueLightIcon
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:32:12 AM"
        label.textAlignment = .center
        label.textColor = .blueLightIcon
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var dateAndTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, dateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    
    private lazy var timeTravel: UILabel = {
        let label = UILabel()
        label.text = "11:13 AM"
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var fromCity: UILabel = {
        let label = UILabel()
        label.text = "Alrass"
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    private lazy var destinationCity: UILabel = {
        let label = UILabel()
        label.text = "Qassim"
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var fullnameLable: UILabel = {
        let label = UILabel()
        label.text = "Tariq Almazyad"
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var fromCityDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.setDimensions(height: 5, width: 5)
        view.layer.cornerRadius = 5 / 2
        return view
    }()
    
    private lazy var lineBetweenCities: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.setWidth(width: 3)
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var destinationCityDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.setDimensions(height: 5, width: 5)
        view.layer.cornerRadius = 5 / 2
        return view
    }()
    
    private lazy var citiesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromCity, destinationCity])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        stackView.setWidth(width: 70)
        return stackView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        addSubview(fullnameLable)
        fullnameLable.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 4)
        addSubview(dateAndTimeStackView)
        dateAndTimeStackView.anchor(top: topAnchor, right: rightAnchor, paddingTop: 6, paddingRight: 8)
        
        // construct the dots and the line in between
        addSubview(fromCityDot)
        fromCityDot.centerX(inView: profileImageView, topAnchor: profileImageView.bottomAnchor, paddingTop: 18)
        addSubview(destinationCityDot)
        destinationCityDot.centerX(inView: fromCityDot, topAnchor: fromCityDot.bottomAnchor, paddingTop: 60)
        addSubview(lineBetweenCities)
        lineBetweenCities.centerX(inView: fromCityDot)
        lineBetweenCities.anchor(top: fromCityDot.bottomAnchor, bottom: destinationCityDot.topAnchor, paddingTop: 8, paddingBottom: 8)
        addSubview(citiesStackView)
        citiesStackView.centerY(inView: lineBetweenCities, leftAnchor: lineBetweenCities.rightAnchor, paddingLeft: 6)
        citiesStackView.anchor(top: fromCityDot.topAnchor, bottom: destinationCityDot.bottomAnchor, paddingTop: -20, paddingBottom: -20)
        addSubview(containerView)
        containerView.anchor(top: fullnameLable.bottomAnchor, left: citiesStackView.rightAnchor, bottom: bottomAnchor,
                             right: rightAnchor, paddingBottom: 8, paddingRight: 12)
        
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}