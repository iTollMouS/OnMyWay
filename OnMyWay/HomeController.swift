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
        label.font = UIFont.init(name: "AvenirNext-Heavy", size: 24)
        label.textColor = .black
        label.setHeight(height: 100)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 16)
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
