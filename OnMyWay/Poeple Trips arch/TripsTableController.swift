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

private let reuseIdentifier = "RecentTripsCell"

class TripsTableController: UITableViewController {
    
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
        
        let newTripController = NewTripController()
        
        newTripController.delegate = self
        newTripController.popupItem.title = "Design your trip"
        newTripController.popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        newTripController.popupItem.subtitle = "show people what packages you can take"
        newTripController.popupItem.progress = 0.34
        tabBarController?.popupBar.titleTextAttributes = [ .foregroundColor: UIColor.white ]
        tabBarController?.popupBar.subtitleTextAttributes = [ .foregroundColor: UIColor.gray ]
        tabBarController?.presentPopupBar(withContentViewController: newTripController, animated: true, completion: nil)
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

extension TripsTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecentTripsCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripDetailsController = TripDetailsController()
        navigationController?.pushViewController(tripDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
    
}


extension TripsTableController: NewTripControllerDelegate{
    func dismissNewTripView(_ view: NewTripController) {
        tabBarController?.closePopup(animated: true, completion: { [self] in
            let safetyControllerGuidelines = SafetyControllerGuidelines(style: .insetGrouped)
            safetyControllerGuidelines.modalPresentationStyle = .fullScreen
            present(safetyControllerGuidelines, animated: true, completion: nil)
        })
    }
}
