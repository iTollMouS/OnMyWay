//
//  ProfileController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit
import Firebase
import FirebaseUI
import Gallery
import ProgressHUD


private let reuseIdentifier = "ProfileCell"

class ProfileController: UIViewController {
    
    private lazy var headerView = ProfileHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    private lazy var footerView = ProfileFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
    
    private let gallery = GalleryController ()
    let cellSelectionStyle = UIView()
    
    var user: User?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style:.insetGrouped)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        configureNavBar()
        fetchUser()
    }
    
    func fetchUser(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: userID) { user in
            print("DEBUG: profile is \(user.profileImageUrl)")
            Service.downloadImage(imageUrl: user.profileImageUrl) { imageView in
                self.headerView.profileImageView.setImage(imageView?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.headerView.profileImageView.setDimensions(height: 100, width: 100)
                self.headerView.profileImageView.layer.cornerRadius = 100 / 2
                self.headerView.profileImageView.imageView?.contentMode = .scaleAspectFill
                self.headerView.profileImageView.backgroundColor = .clear
                self.headerView.profileImageView.clipsToBounds = true
                self.tableView.reloadData()
            }
        }
    }
    
    
    func configureUI(){
        view.addSubview(tableView)
        tableView.fillSuperview()
        gallery.delegate = self
        headerView.delegate = self
        footerView.delegate = self
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
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
    
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases[section].numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        guard let viewModel = ProfileViewModel(rawValue: indexPath.section) else { return cell }
        cell.viewModel = viewModel
        cell.delegate = self
        cellSelectionStyle.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cell.selectedBackgroundView = cellSelectionStyle
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = ProfileViewModel(rawValue: section) else { return UIView() }
        
        
        let iconImage = UIImageView(image: UIImage(systemName: viewModel.systemNameIcon))
        iconImage.setDimensions(height: viewModel.iconDimension.0, width: viewModel.iconDimension.1)

        iconImage.tintColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        let label = UILabel()
        label.text = viewModel.sectionTitle
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        
        
        let containerView = UIView()
        containerView.addSubview(iconImage)
        iconImage.centerY(inView: containerView, leftAnchor: containerView.leftAnchor, paddingLeft: 12)
        containerView.addSubview(label)
        label.centerY(inView: iconImage, leftAnchor: iconImage.rightAnchor, paddingLeft: 8)
        return containerView
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension ProfileController: ProfileHeaderDelegate {
    func handleUpdatePhoto(_ header: ProfileHeader) {
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.Grid.FrameView.borderColor = .black
        Config.Grid.FrameView.fillColor = .black
        gallery.modalPresentationStyle = .fullScreen
        
        self.present(gallery, animated: true, completion: nil)
    }
}

extension ProfileController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let image = images.first else { return }
        self.showBlurView()
        self.showLoader(true, message: "Please wait while we upload your photo...")
        image.resolve { [self] in guard let image = $0 else {return}
            headerView.profileImageView.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            headerView.profileImageView.setDimensions(height: 100, width: 100)
            headerView.profileImageView.layer.cornerRadius = 100 / 2
            headerView.profileImageView.imageView?.contentMode = .scaleAspectFill
            headerView.profileImageView.backgroundColor = .clear
            headerView.profileImageView.clipsToBounds = true
            
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.showLoader(false)
                Service.updateProfileImage(withImage: image, userID: userID) { error in
                    if let error = error {
                        self.showAlertMessage("Error", error.localizedDescription)
                        return
                    }
                    self.removeBlurView()
                    self.showLoader(false)
                    self.showBanner(message: "Success!", state: .success, location: .top,
                                    presentingDirection: .vertical, dismissingDirection: .vertical,
                                    sender: self)
                    ProgressHUD.showSucceed()
                    
                }
            }
            
        }
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
