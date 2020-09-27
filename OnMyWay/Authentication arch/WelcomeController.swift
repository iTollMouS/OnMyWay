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
    
    private lazy var googleIcon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "471px-Google__G__Logo.svg"))
    private lazy var appleIcon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "ezgif"))
    private lazy var phoneIcon: UIImageView = UIImageView(image: UIImage(systemName: "phone"))
    private lazy var mailIcon: UIImageView = UIImageView(image: UIImage(systemName: "envelope.fill"))
    
    private lazy var socalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [googleIcon, appleIcon, phoneIcon,mailIcon])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.setDimensions(height: 20, width: 100)
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLoggingTapped)))
        return stackView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = createButton(tag: 0, title: "Register",
                                  backgroundColor: .blueLightBackground,
                                  fontColor: .blueLightIcon)
        button.addTarget(self, action: #selector(handleRegisterTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = createButton(tag: 1, title: "  Login with ",
                                  backgroundColor: .backgroundGreen,
                                  fontColor: .greenIcon)
        button.addTarget(self, action: #selector(handleLoggingTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.addSubview(socalStackView)
        socalStackView.centerY(inView: button, leftAnchor: button.titleLabel?.rightAnchor, paddingLeft: 10)
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
        [phoneIcon, mailIcon].forEach{$0.tintColor = .black}
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
        print("DEBUG: iPhone Pro width \(UIScreen.main.bounds.width)")
        print("DEBUG: iPhone Pro height \(UIScreen.main.bounds.height)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.stackButtons.transform = .identity
            self.stackButtons.alpha = 1
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
        animateView { [weak self] isFinished in
            if isFinished {
                self?.navigationController?.pushViewController(loggingController, animated: true)
                self?.stackButtons.alpha = 0
            }
        }
    }
    
    @objc func handleRegisterTapped(){
        let registerationController  = RegisterationController()
        navigationController?.pushViewController(registerationController, animated: true)
    }
    
    func animateView(completion: ((Bool) -> Void)?){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.stackButtons.alpha = 0
            self.stackButtons.transform = .init(translationX: 0, y: 100)
        }, completion: completion)
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

