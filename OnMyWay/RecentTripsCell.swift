//
//  RecentTripsCell.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/28/20.
//

import UIKit

class RecentTripsCell: UITableViewCell {
    
    
    
    private lazy var clientImageView1 = createImage()
    private lazy var clientImageView2 = createImage()
    private lazy var clientImageView3 = createImage()
    private lazy var clientImageView4 = createImage()
    
    
    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clientImageView1,
                                                       clientImageView2,
                                                       clientImageView3,
                                                       clientImageView4])
        stackView.spacing = -20
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.setWidth(width: 50)
        stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
        return stackView
    }()
    
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunday, September 23, 2020"
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
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.setWidth(width: 150)
        return stackView
    }()
    
    var imageArray = [UIImageView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [clientImageView1, clientImageView2, clientImageView3, clientImageView4].forEach{imageArray.append($0)}
        addSubview(imagesStackView)
        imagesStackView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: imagesStackView.rightAnchor, bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
        containerView.addSubview(dateAndTimeStackView)
        dateAndTimeStackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                                    paddingTop: 8 ,paddingLeft: 12)
        addSubview(fromCityDot)
        fromCityDot.anchor(top: dateAndTimeStackView.bottomAnchor, left: containerView.leftAnchor, paddingTop: 12, paddingLeft: 30)
        
        addSubview(destinationCityDot)
        destinationCityDot.centerX(inView: fromCityDot, topAnchor: fromCityDot.bottomAnchor, paddingTop: 50)
        
        addSubview(lineBetweenCities)
        lineBetweenCities.centerX(inView: fromCityDot)
        lineBetweenCities.anchor(top: fromCityDot.bottomAnchor, bottom: destinationCityDot.topAnchor, paddingTop: 5, paddingBottom: 5)
        addSubview(citiesStackView)
        citiesStackView.anchor(top: fromCityDot.topAnchor, bottom: destinationCityDot.bottomAnchor, paddingTop: -10, paddingBottom: -10)
        citiesStackView.centerY(inView: lineBetweenCities, leftAnchor: lineBetweenCities.rightAnchor, paddingLeft: 12)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func createImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.setDimensions(height: 50, width: 50)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 / 2
        return imageView
    }
    
}
