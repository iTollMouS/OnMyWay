//
//  RegisterationController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//

import UIKit
import CLTypingLabel

class RegisterationController: UIViewController {
    
    private lazy var dismissView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.imageView?.setDimensions(height: 20, width: 25)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1)
        button.layer.cornerRadius = 50 / 2
        button.setDimensions(height: 50, width: 50)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "markus-spiske-RWTUrJf7I5w-unsplash")
        imageView.setDimensions(height: 200, width: view.frame.width)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60 / 2
        return imageView
    }()
    
    private lazy var bottomCardView: UIView = {
        let view = UIView()
        view.setDimensions(height: 500, width: view.frame.width)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var selectImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.setDimensions(height: 100, width: 100)
        button.layer.cornerRadius = 100 / 2
        button.clipsToBounds = true
        button.tintColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.addTarget(self, action: #selector(handlePhotoSelected), for: .touchUpInside)
        return button
    }()
    private lazy var newAccountLabel: UILabel = {
        let label = CLTypingLabel()
        label.text = "New\nAccount"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newAccountLabel, selectImage])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.setHeight(height: 100)
        return stackView
    }()
    
    private var profileImage: UIImage?
    
    
    private let emailTextField = CustomTextField(textColor: #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.3529411765, alpha: 1), placeholder: "Email",
                                                 placeholderColor: .white, isSecure: false)
    private lazy var emailContainerView = CustomContainerView(image:  UIImage(systemName: "envelope"),
                                                              textField: emailTextField, iconTintColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1),
                                                              dividerViewColor: .black, setViewHeight: 50)
    
    private let fullnameTextField = CustomTextField(textColor: #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.3529411765, alpha: 1), placeholder: "Full name",
                                                    placeholderColor: .white, isSecure: false)
    private lazy var fullnameContainerView = CustomContainerView(image:  UIImage(systemName: "person.crop.circle"),
                                                                 textField: fullnameTextField, iconTintColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1),
                                                                 dividerViewColor: .black, setViewHeight: 50)
    
    private let passwordTextField = CustomTextField(textColor: #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.3529411765, alpha: 1), placeholder: "********",
                                                    placeholderColor: .white, isSecure: false)
    private lazy var passwordContainerView = CustomContainerView(image:  UIImage(systemName: "lock"),
                                                                 textField: passwordTextField, iconTintColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1),
                                                                 dividerViewColor: .black, setViewHeight: 50)
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setHeight(height: 60)
        button.layer.cornerRadius = 60 / 2
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegisterTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,
                                                       fullnameContainerView,
                                                       passwordContainerView,
                                                       registerButton])
        stackView.axis = .vertical
        stackView.setHeight(height: CGFloat(stackView.subviews.count - 1 * 70))
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.hideKeyboardWhenTouchOutsideTextField()
    }
    
    override func viewDidLayoutSubviews() {
        bottomCardView.layer.configureGradientBackground(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1))
    }
    
    func configureUI(){
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        view.addSubview(dismissView)
        dismissView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 16)
        view.addSubview(bottomCardView)
        bottomCardView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        bottomCardView.addSubview(topStackView)
        topStackView.centerX(inView: bottomCardView, topAnchor: bottomCardView.topAnchor, paddingTop: 6)
        topStackView.anchor(left: bottomCardView.leftAnchor, right: bottomCardView.rightAnchor, paddingLeft: 20, paddingRight: 20)
        bottomCardView.addSubview(formStackView)
        formStackView.centerX(inView: bottomCardView, topAnchor: topStackView.bottomAnchor)
        formStackView.anchor(left: bottomCardView.leftAnchor, right: bottomCardView.rightAnchor, paddingLeft: 20, paddingRight: 20)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func checkPhotoValidation(){
        if profileImage == nil {
            let alert = UIAlertController(title: "", message: "الرجاء اصافة صورة شخصية", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "تم", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func handleRegisterTapped(){
        guard let email = emailTextField.text else { return  }
        guard let password = passwordTextField.text else { return  }
        guard let fullname = fullnameTextField.text else { return  }
        guard let imageView = profileImage else { return }
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImageView: imageView)
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                self.showAlertMessage("Error", error.localizedDescription)
                return
            }
            print("DEBUG: success!!!")
        }
        
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 220
        }
    }
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePhotoSelected(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension RegisterationController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        profileImage = image
        selectImage.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectImage.layer.cornerRadius = 50
        selectImage.layer.borderColor = UIColor.white.cgColor
        selectImage.layer.borderWidth = 1.0
        selectImage.imageView?.contentMode = .scaleAspectFill
        picker.dismiss(animated: true, completion: nil)
    }
}

