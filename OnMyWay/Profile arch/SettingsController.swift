//
//  ProfileController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit
import Firebase
import Gallery
import ProgressHUD



private let reuseIdentifier = "ProfileCell"

class SettingsController: UIViewController {
    
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
        updateUserInfo()
        
    }
    
    func updateUserInfo(){
        
        if let user = User.currentUser {
            headerView.usernameLabel.text = user.username
            headerView.userStatusLabel.text = user.status
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avaratImage)  in
                    self.headerView.profileImageView.setImage(avaratImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.headerView.profileImageView.setDimensions(height: 100, width: 100)
                    self.headerView.profileImageView.layer.cornerRadius = 100 / 2
                    self.headerView.profileImageView.imageView?.contentMode = .scaleAspectFill
                    self.headerView.profileImageView.backgroundColor = .clear
                    self.headerView.profileImageView.clipsToBounds = true
                    
                }
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
    
    private func uploadAvatarImage(_ image: UIImage){
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, dictionary: fileDirectory) { avatarLink in
            guard let avatarLink = avatarLink else {return}
            if var user =  User.currentUser {
                user.avatarLink = avatarLink
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
        }
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
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
        let label = UILabel()
        label.text = viewModel.sectionTitle
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
 
extension SettingsController: ProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "log out", style: .destructive, handler: { (alertAction) in
            self.dismiss(animated: true) {  FirebaseUserListener.shared.logOutCurrentUser { error in
                if let error = error {
                    ProgressHUD.showError("Error while logging out\(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    let registrationController = RegistrationController()
                    registrationController.modalPresentationStyle = .fullScreen
                    self.present(registrationController, animated: true, completion: nil)
                }
            } }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsController: ProfileCellDelegate {
    func showGuidelines(_ cell: ProfileCell) {
        
    }
    
}

extension SettingsController: ProfileHeaderDelegate {
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

extension SettingsController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let image = images.first else { return }
        self.showBlurView()
        image.resolve { [self] in guard let image = $0 else {return}
            uploadAvatarImage(image)
            headerView.profileImageView.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            headerView.profileImageView.setDimensions(height: 100, width: 100)
            headerView.profileImageView.layer.cornerRadius = 100 / 2
            headerView.profileImageView.imageView?.contentMode = .scaleAspectFill
            headerView.profileImageView.backgroundColor = .clear
            headerView.profileImageView.clipsToBounds = true
            self.removeBlurView()
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
