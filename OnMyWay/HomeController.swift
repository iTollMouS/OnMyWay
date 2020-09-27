//
//  HomeController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit
import Firebase
import FirebaseUI

class HomeController: UIViewController {
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to \nOnMyWay "
        label.numberOfLines = 0
        label.font = UIFont.init(name: "AvenirNext-Heavy", size: 32)
        label.textColor = .black
        label.setHeight(height: 100)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var travelContainerView = createImageView(withImage: #imageLiteral(resourceName: "rosebox-BFdSCxmqvYc-unsplash"))
    private lazy var sendPackageContainerView = createImageView(withImage: #imageLiteral(resourceName: "sendPackagePhoto"))
    
    private lazy var travelButton: UIButton = {
        let button = createButton(withTitle: "Travel")
        button.addTarget(self, action: #selector(handleTravelTapped), for: .touchUpInside)
        return button
    }()
    private lazy var sendButton = createButton(withTitle: "Send Package")
    
    private lazy var bottomSendPackageView: UIView = {
        let view = UIView()
        view.setHeight(height: 200)
        return view
    }()
    
    private lazy var bottomTravelView: UIView = {
        let view = UIView()
        view.addSubview(travelButton)
        travelButton.centerInSuperview()
        travelButton.setDimensions(height: 50, width: 150)
        travelButton.layer.cornerRadius = 50 / 2
        view.setHeight(height: 100)
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [travelContainerView, sendPackageContainerView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.setHeight(height: 300)
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureUI(){
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1)
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        titleLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 18)
        view.addSubview(stackView)
        stackView.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 16)
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        sendPackageContainerView.addSubview(bottomSendPackageView)
        bottomSendPackageView.anchor(left: sendPackageContainerView.leftAnchor, bottom: sendPackageContainerView.bottomAnchor, right: sendPackageContainerView.rightAnchor)
        travelContainerView.addSubview(bottomTravelView)
        bottomTravelView.anchor(left: travelContainerView.leftAnchor, bottom: travelContainerView.bottomAnchor, right: travelContainerView.rightAnchor)
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            presentLoggingController()
        } catch (let error){
            print("DEBUG: error happen while logging out \(error.localizedDescription)")
        }
    }
    
    
    func checkIfUserLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            self.presentLoggingController()
        } else {
            //            fetchUser()
        }
    }
    
    func presentLoggingController(){
        DispatchQueue.main.async {
            let welcomeController = WelcomeController()
            let nav = UINavigationController(rootViewController: welcomeController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    @objc func handleTravelTapped(){
        let newTripController = NewTripController()
        navigationController?.pushViewController(newTripController, animated: true)
    }
    
    func createImageView(withImage image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(title)\t", for: .normal)
        button.backgroundColor = .clear
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 26)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .white
        return button
    }
    
}
