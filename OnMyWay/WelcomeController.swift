//
//  ViewController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/25/20.
//

import UIKit
import ProgressHUD
import CLTypingLabel

class WelcomeController: UIViewController {
    
    
    private lazy var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "rosebox-BFdSCxmqvYc-unsplash")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "markus-spiske-RWTUrJf7I5w-unsplash")
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: 100, width: 100)
        imageView.layer.cornerRadius = 100 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.addSubview(logo)
        view.setDimensions(height: 100, width: 100)
        view.layer.cornerRadius = 100 / 2
        view.setupShadowAndBorder(opacity: 1, radius: 20, offset: CGSize(width: 0.0, height: 8),
                                  color: .white, borderColor: .blueLightIcon, borderWidth: 2)
        logo.fillSuperview()
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = CLTypingLabel()
        label.font = UIFont.init(name: "Copperplate-Light", size: 26)
        label.text = "Welcome to the new era \n in delivering packages"
        label.setHeight(height: 100)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    
    
    private lazy var registerButton = createButton(tag: 0, title: "Register",
                                                   backgroundColor: .blueLightBackground,
                                                   fontColor: .blueLightIcon)
    
    private lazy var loginButton: UIButton = {
        let button = createButton(tag: 1, title: "Login",
                                  backgroundColor: .backgroundGreen,
                                  fontColor: .greenIcon)
        button.addTarget(self, action: #selector(handleLoggingTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var browsAsGuestButton = createButton(tag: 2, title: "Guest",
                                                       backgroundColor: .redBackground,
                                                       fontColor: .redIcon)
    
    
    
    
    private lazy var stackButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [registerButton, loginButton, browsAsGuestButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fill
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return stackView
    }()
    
    private lazy var buttonsContainerView: UIView = {
        let view = UIView()
        view.addSubview(stackButtons)
        view.setHeight(height: 300)
        view.setGradiantBGColor(with: .black, bottomColor: .white, startPoint: 0.0, endPoint: 0.3)
        stackButtons.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 30)
        stackButtons.setWidth(width: 500)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.buttonsContainerView.transform = .identity
            self.buttonsContainerView.alpha = 1
        }
    }
    
    
    func configureUI(){
        view.addSubview(imageBackground)
        imageBackground.fillSuperview()
        view.backgroundColor = .white
        view.addSubview(imageContainerView)
        imageContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                  paddingTop: 50, paddingLeft: 50)
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: imageContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 50)
        view.addSubview(buttonsContainerView)
        buttonsContainerView.centerX(inView: view)
        buttonsContainerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
    }
 
    
    @objc func handleLoggingTapped(){
        let loggingController = LoggingController()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.buttonsContainerView.alpha = 0
            self.buttonsContainerView.transform = .init(translationX: 0, y: 200)
        } completion: { [weak self] _ in
            self?.navigationController?.pushViewController(loggingController, animated: true)
        }

    }
    
    func createButton(tag: Int, title: String, backgroundColor: UIColor, fontColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setHeight(height: 50)
        button.layer.cornerRadius = 50 / 2
        button.backgroundColor = backgroundColor
        button.tag = tag
        return button
    }
}

