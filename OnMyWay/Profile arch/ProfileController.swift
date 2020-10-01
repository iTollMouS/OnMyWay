//
//  ProfileController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit
import Firebase
import FirebaseUI

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    
    private lazy var headerView = ProfileHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    private lazy var footerView = ProfileFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
        configureNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let cellSelectionStyle = UIView()
    
    func configureNavBar(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let demoVC = PeopleReviewsController()
        demoVC.popupItem.title = "People Reviews "
        demoVC.popupItem.subtitle = "Tab here to see who wrote a review about you"
        demoVC.popupItem.progress = 0.34
        tabBarController?.popupBar.titleTextAttributes = [ .foregroundColor: UIColor.white ]
        tabBarController?.popupBar.subtitleTextAttributes = [ .foregroundColor: UIColor.gray ]
        tabBarController?.presentPopupBar(withContentViewController: demoVC, animated: true, completion: nil)
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            presentLoggingController()
            self.tabBarController?.selectedIndex = 0
        } catch (let error){
            print("DEBUG: error happen while logging out \(error.localizedDescription)")
        }
    }
    
    func presentLoggingController(){
        DispatchQueue.main.async { [self] in
            let welcomeController = WelcomeController()
            let nav = UINavigationController(rootViewController: welcomeController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    
    func configureTableView(){
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 50
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases[section].numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        guard let viewModel = ProfileViewModel(rawValue: indexPath.section) else { return cell }
        cell.viewModel = viewModel
        cell.delegate = self
        print("DEBUG: \(indexPath.section) \(indexPath.row)")
        cellSelectionStyle.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cell.selectedBackgroundView = cellSelectionStyle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = ProfileViewModel(rawValue: section) else { return UIView() }
        let label = UILabel()
        label.text = viewModel.sectionTitle
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension ProfileController: ProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "log out", style: .destructive, handler: { (alertAction) in
            self.dismiss(animated: true) { [self] in logout()  }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

extension ProfileController: ProfileCellDelegate {
    func showGuidelines(_ cell: ProfileCell) {
        let safetyControllerGuidelines = SafetyControllerGuidelines(style: .insetGrouped)
        safetyControllerGuidelines.modalPresentationStyle = .fullScreen
        present(safetyControllerGuidelines, animated: true, completion: nil)
    }
    
}
