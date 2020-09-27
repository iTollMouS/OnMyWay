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
    
    
    private lazy var travelContainerView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.image = #imageLiteral(resourceName: "rosebox-BFdSCxmqvYc-unsplash")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var sendPackageContainerView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.image = #imageLiteral(resourceName: "sendPackagePhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [travelContainerView, sendPackageContainerView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.setHeight(height: 300)
        return stackView
    }()
    
    private lazy var bottomSendPackageView: UIView = {
        let view = UIView()
        view.setHeight(height: 200)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        bottomSendPackageView.layer.configureGradientBackground( UIColor.clear.cgColor, UIColor.black.cgColor)
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
        sendPackageContainerView.layoutIfNeeded()
        
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
    
    
}
