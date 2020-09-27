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
import CLTypingLabel


class LoggingController: UIViewController {
    
    
    private var currentNonce: String?
    
    private lazy var welcomeLabel: UILabel = {
        let label = CLTypingLabel()
        label.text = "Login in"
        label.textColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        label.setDimensions(height: 40, width: view.frame.width)
        label.font = UIFont.init(name: "Copperplate-Light", size: 42)
        return label
    }()
    
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
        button.setDimensions(height: 50, width: 300)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handleLoggingTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "Or sign in with"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.setHeight(height: 20)
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.3529411765, alpha: 1)
        return label
    }()
    
    private lazy var signWithAppleID: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
        button.addTarget(self, action: #selector(handleSignInWithAppleID), for: .touchUpInside)
        button.setDimensions(height: 50, width: 300)
        button.layer.cornerRadius = 50 / 2
        button.clipsToBounds = true
        return button
    }()
    
    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal) , for: .normal)
        button.imageView?.clipsToBounds = true
        button.setTitle("Sign With Google Account", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.3529411765, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setDimensions(height: 50, width: 300)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var phoneNumberLogging: UIButton = {
        let button = UIButton (type: .system)
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.tintColor =  #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.setTitle("  Sign in with your phone number", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setDimensions(height: 50, width: 300)
        button.layer.cornerRadius = 50 / 2
        button.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleLoggingWithPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    private lazy var authenticateServiceStackButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loggingButton, orLabel ,signWithAppleID,
                                                       googleLoginButton, phoneNumberLogging])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.setDimensions(height: CGFloat(stackView.subviews.count - 1 * Int(UIScreen.main.bounds.height > 800 ? 50 : 20)), width: 300)
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.hideKeyboardWhenTouchOutsideTextField()
        configureGoogleSignIn()
    }
    
    override func viewDidLayoutSubviews() {
        bottomCardView.layer.configureGradientBackground(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1))
        bottomCardView.layer.cornerRadius = 40
    }
    
    @objc func handleLoggingWithPhoneNumber(){
        let authenticationPhoneController = AuthenticationPhoneController()
        present(authenticationPhoneController, animated: true, completion: nil)
    }
    
    func configureUI(){
        view.addSubview(imageBackground)
        imageBackground.centerX(inView: view)
        imageBackground.anchor(left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(dismissView)
        dismissView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: dismissView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: UIScreen.main.bounds.height > 800 ? 20 : 5, paddingLeft: 20)
        
        
        view.addSubview(bottomCardView)
        bottomCardView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                              paddingBottom: UIScreen.main.bounds.height > 800 ? 0 : -80)
        
        bottomCardView.addSubview(formStackView)
        formStackView.anchor(top: bottomCardView.topAnchor, left: bottomCardView.leftAnchor,
                             right: bottomCardView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        bottomCardView.addSubview(resetPassword)
        resetPassword.anchor(top: formStackView.bottomAnchor, right: bottomCardView.rightAnchor, paddingTop: 20, paddingRight: 20)
        
        bottomCardView.addSubview(authenticateServiceStackButtons)
        authenticateServiceStackButtons.centerX(inView: bottomCardView, topAnchor: resetPassword.bottomAnchor, paddingTop: 20)
        
        view.setGradiantBGColor(with: UIColor.black.withAlphaComponent(0.3), bottomColor: .clear, startPoint: 0.0, endPoint: 0.1)
    }
    
    // MARK: - Google Sign In Section
    func configureGoogleSignIn(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @objc func handleGoogleSignIn() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func handleLoggingTaped(){
        guard let email = emailTextField.text else { return  }
        guard let password = passwordTextField.text else { return  }
        AuthService.logUserIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showAlertMessage("Error", error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
}

extension LoggingController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else { return }
        self.showBlurView()
        self.showLoader(true, message: "Please wait while we create account for you...")
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.removeBlurView()
            self.showLoader(false)
            self.showBanner(message: "Successfully created account with Google account", state: .success,
                            location: .top, presentingDirection: .vertical, dismissingDirection: .vertical,
                            sender: self)
        }
        AuthService.signInWithGoogle(didSignInfo: user) { (error) in
            if let error = error {
                self.showAlertMessage( nil ,error.localizedDescription)
                return
            }
            self.removeBlurView()
            self.showLoader(false)
        }
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
        
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        guard let fullname = appleIDCredential.fullName?.familyName else { return }
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Service.uploadImage(withImage: userImageView) { imageUrl in
            self.showBlurView()
            self.showLoader(true, message: "Please wait while we create account for you...")
            AuthService.signInWithAppleID(credential: credential, fullname: fullname, imageUrl: imageUrl, fcmToken: fcmToken) { error in
                if let error = error {
                    self.removeBlurView()
                    self.showLoader(false)
                    self.showAlertMessage("Error", error.localizedDescription)
                    return
                }
                self.removeBlurView()
                self.showLoader(false)
                self.showAlertMessage("Success!", "Successfully created account with Apple ID")
            }
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.showAlertMessage("Error with Apple ID", error.localizedDescription)
    }
    
}

extension LoggingController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else { return UIWindow()}
        return window
    }
}
