//
//  LoggingController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//
import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import Firebase
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseCore
import FirebaseFunctions
import FirebaseMessaging
import FirebaseABTesting
import FirebaseInstanceID
import FirebaseRemoteConfig


class LoggingController: UIViewController {
    
    
    private var currentNonce: String?
    
    private lazy var dismissView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.imageView?.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1)
        button.layer.cornerRadius = 50 / 2
        button.setDimensions(height: 50, width: 50)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private lazy var userImageView: UIImage = #imageLiteral(resourceName: "plus_photo")
    
    private lazy var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "leone-venter-mTkXSSScrzw-unsplash")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setHeight(height: 400)
        return imageView
    }()
    
    private lazy var bottomCardView: UIView = {
        let view = UIView()
        view.setDimensions(height: 600, width: view.frame.width)
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    
    private let emailTextField = CustomTextField(textColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1), placeholder: "Email",
                                                 placeholderColor: .white, isSecure: false)
    private lazy var emailContainerView = CustomContainerView(image:  UIImage(systemName: "envelope"),
                                                              textField: emailTextField, iconTintColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1),
                                                              dividerViewColor: .black, setViewHeight: 50)
    private let passwordTextField = CustomTextField(textColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1), placeholder: "Password",
                                                    placeholderColor: .white, isSecure: true)
    private lazy var passwordContainerView = CustomContainerView(image:  UIImage(systemName: "lock"),
                                                                 textField: passwordTextField, iconTintColor: #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1),
                                                                 dividerViewColor: .black, setViewHeight: 50)
    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.setHeight(height: CGFloat(stackView.subviews.count * 50))
        return stackView
    }()
    
    private lazy var resetPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1), for: .normal)
        button.setDimensions(height: 30, width: 150)
        button.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1)
        button.layer.cornerRadius = 30 / 2
        return button
    }()
    
    private lazy var loggingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.setDimensions(height: 50, width: 250)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "Or sign in with"
        label.setDimensions(height: 20, width: 200)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signWithAppleID: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
        button.addTarget(self, action: #selector(handleSignInWithAppleID), for: .touchUpInside)
        button.setDimensions(height: 50, width: 250)
        button.layer.cornerRadius = 50 / 2
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.hideKeyboardWhenTouchOutsideTextField()
    }
    
    override func viewDidLayoutSubviews() {
        bottomCardView.layer.configureGradientBackground(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1))
        bottomCardView.layer.cornerRadius = 40
    }
    
    func configureUI(){
        view.addSubview(imageBackground)
        imageBackground.centerX(inView: view)
        imageBackground.anchor(left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(dismissView)
        dismissView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(bottomCardView)
        bottomCardView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        bottomCardView.addSubview(formStackView)
        formStackView.anchor(top: bottomCardView.topAnchor, left: bottomCardView.leftAnchor,
                             right: bottomCardView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        bottomCardView.addSubview(resetPassword)
        resetPassword.anchor(top: formStackView.bottomAnchor, right: bottomCardView.rightAnchor, paddingTop: 20, paddingRight: 20)
        
        bottomCardView.addSubview(loggingButton)
        loggingButton.centerX(inView: bottomCardView, topAnchor: resetPassword.bottomAnchor, paddingTop: 18)
        
        bottomCardView.addSubview(orLabel)
        orLabel.centerX(inView: loggingButton, topAnchor: loggingButton.bottomAnchor, paddingTop: 20)
        
        bottomCardView.addSubview(signWithAppleID)
        signWithAppleID.centerX(inView: bottomCardView, topAnchor: loggingButton.bottomAnchor, paddingTop: 20)
        
        view.setGradiantBGColor(with: UIColor.black.withAlphaComponent(0.3), bottomColor: .clear, startPoint: 0.0, endPoint: 0.1)
    }
    
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
}



extension LoggingController {
    
    @objc func handleSignInWithAppleID(){
        performSignIn()
    }
    
    func performSignIn(){
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}


extension LoggingController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
        guard let nonce = currentNonce else {
            fatalError("Invalid state: a login callback was received, but no login request was sent!")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable tp fetch identity token ")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        print("DEBUG: user email is \(appleIDCredential.email), and name \(appleIDCredential.fullName) sha246\(idTokenString)")
        print("DEBUG: \(appleIDCredential.fullName?.familyName)")
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        guard let fullname = appleIDCredential.fullName?.familyName else { return }
        Service.uploadImage(withImage: userImageView) { imageUrl in
            AuthService.signInWithAppleID(credential: credential, fullname: fullname, imageUrl: imageUrl, fcmToken: fcmToken) { error in
                if let error = error {
                    self.showAlertMessage("Error", error.localizedDescription)
                    return
                }
                self.showAlertMessage("Success!", "Successfully created account with Apple ID")
            }
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}


extension LoggingController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else { return UIWindow()}
        return window
    }
}
