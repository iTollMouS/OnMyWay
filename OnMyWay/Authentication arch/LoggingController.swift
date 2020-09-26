//
//  LoggingController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//

import UIKit

class LoggingController: UIViewController {
    
    
    private lazy var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "leone-venter-mTkXSSScrzw-unsplash")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setHeight(height: 400)
        return imageView
    }()
    
    private lazy var bottomCardView: UIView = {
        let view = UIView()
        view.setDimensions(height: 600, width: view.frame.width)
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        bottomCardView.layer.configureGradientBackground(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1))
        bottomCardView.layer.cornerRadius = 40
    }
    
    func configureUI(){
        view.addSubview(imageBackground)
        imageBackground.centerX(inView: view)
        imageBackground.anchor(left: view.leftAnchor, right: view.rightAnchor)
        view.addSubview(bottomCardView)
        bottomCardView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}
