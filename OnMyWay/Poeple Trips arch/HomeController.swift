//
//  HomeController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit
import Firebase
import FirebaseUI
import LNPopupController

private let reuseIdentifier = "recentTrips"

class HomeController: UITableViewController {
    
    
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
    
    private lazy var sendPackageContainerView: UIView = {
        let view = createImageView(withImage: #imageLiteral(resourceName: "sendPackagePhoto"))
        view.layer.configureGradientBackground(UIColor.clear.cgColor, UIColor.black.cgColor, layerIndex: 2)
        return view
    }()
    
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
    
    private lazy var recentTripsLabel: UILabel = {
        let label = UILabel()
        label.text = "Travelers"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setHeight(height: 50)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        configureUI()
        configureNavBar()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let demoVC = NewTripController()
        
        demoVC.delegate = self
        demoVC.popupItem.title = "Design your trip"
        demoVC.popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        demoVC.popupItem.subtitle = "show people what packages you can take"
        demoVC.popupItem.progress = 0.34
        tabBarController?.popupBar.titleTextAttributes = [ .foregroundColor: UIColor.white ]
        tabBarController?.popupBar.subtitleTextAttributes = [ .foregroundColor: UIColor.gray ]
        tabBarController?.presentPopupBar(withContentViewController: demoVC, animated: true, completion: nil)
    }
    
    
    
    func configureNavBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Travelers"
        
    }
    
    func configureUI(){
    
        tableView.register(RecentTripsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 1000
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        
    }
        
    func checkIfUserLoggedIn(){
        Auth.auth().currentUser?.uid == nil ? presentLoggingController() : print("")
    }
    
    func presentLoggingController(){
        DispatchQueue.main.async { [self] in
            let welcomeController = WelcomeController()
            let nav = UINavigationController(rootViewController: welcomeController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
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

extension HomeController {
    
}


extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecentTripsCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
    
}


extension HomeController: NewTripControllerDelegate{
    func dismissNewTripView(_ view: NewTripController) {
        tabBarController?.closePopup(animated: true, completion: { [self] in
            let safetyControllerGuidelines = SafetyControllerGuidelines(style: .insetGrouped)
            safetyControllerGuidelines.modalPresentationStyle = .fullScreen
            present(safetyControllerGuidelines, animated: true, completion: nil)
        })
    }
}
