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

class TripsTableController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView  = UITableView()
        tableView.register(RecentTripsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 1000
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        return tableView
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
        configureTapBarController()
    }
    
    
    func configureTapBarController(){
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
        
        view.addSubview(tableView)
        tableView.fillSuperview()
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
    
}

extension TripsTableController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecentTripsCell
        cell.isUserInteractionEnabled = true
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripDetailsController = TripDetailsController()
        navigationController?.pushViewController(tripDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteMyTrip(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
     func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editMyTrip(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func deleteMyTrip(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//            self.myTrips.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        action.image = #imageLiteral(resourceName: "Twitter_Logo_Blue")
        action.backgroundColor = .red
        return action
    }

    
    func editMyTrip(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
//            self.myTrips.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        action.image = #imageLiteral(resourceName: "avatar")
        action.backgroundColor = .blueLightFont
        return action
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
