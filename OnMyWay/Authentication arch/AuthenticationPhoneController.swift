//
//  AuthenticationPhoneController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//

import UIKit
import Lottie
import Firebase
import FirebaseAuth

class AuthenticationPhoneController: UIViewController {
    
    private lazy var animationView : AnimationView = {
        let animationView = AnimationView()
        animationView.setDimensions(height: 60, width: 60)
        animationView.clipsToBounds = true
        animationView.animation = Animation.named("textMessage_SMS")
        animationView.layer.cornerRadius = 60 / 2
        animationView.backgroundColor = .clear
        return animationView
    }()
    
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Enter your phone number",
                                                       attributes: [.foregroundColor : UIColor.black, .font: UIFont.boldSystemFont(ofSize: 26)])
        attributedText.append(NSMutableAttributedString(string: "\nWe will send you a code to verify your phone number",
                                                        attributes: [.foregroundColor : UIColor.black, .font: UIFont.systemFont(ofSize: 16)]))
        label.attributedText = attributedText
        label.setDimensions(height: 160, width: 300)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = .black
        let attributedPlaceholder = NSAttributedString(string: "05XXXXXXXX",
                                                       attributes: [.foregroundColor : UIColor.black.withAlphaComponent(0.4)])
        textField.attributedPlaceholder = attributedPlaceholder
        textField.layer.cornerRadius = 40 / 2
        textField.setHeight(height: 40)
        textField.delegate = self
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()
    
    private lazy var verificationCodeTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        let attributedPlaceholder = NSAttributedString(string: "XXXX",
                                                       attributes: [.foregroundColor : UIColor.black.withAlphaComponent(0.4)])
        textField.attributedPlaceholder = attributedPlaceholder
        textField.textColor = .black
        textField.layer.cornerRadius = 40 / 2
        textField.setHeight(height: 40)
        textField.delegate = self
        textField.alpha = 0
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoLabel,
                                                       phoneNumberTextField,
                                                       verificationCodeTextField,
                                                       requestOPTButton,
                                                       verifyOPTButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var requestOPTButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setHeight(height: 60)
        button.layer.cornerRadius = 60 / 2
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.isEnabled = false
        button.transform = .init(scaleX: 0.01, y: 0.01)
        return button
    }()
    
    private lazy var verifyOPTButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setHeight(height: 60)
        button.layer.cornerRadius = 60 / 2
        button.addTarget(self, action: #selector(verify), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.isEnabled = false
        button.transform = .init(scaleX: 0.01, y: 0.01)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTouchOutsideTextField()
        configureUI()
        
    }

    override func viewDidLayoutSubviews() {
        view.layer.configureGradientBackground(#colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9058823529, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.662745098, blue: 0.5490196078, alpha: 1), layerIndex: 0)
    }
    

    func configureUI(){
        view.addSubview(animationView)
        animationView.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 10)
        animationView.setDimensions(height: 180, width: view.frame.width)
        view.addSubview(stackView)
        stackView.centerX(inView: view, topAnchor: animationView.bottomAnchor, paddingTop: 0)
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30 , height: 300)
        
        phoneNumberTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange(_ sender: UITextField){
        guard let textCount = sender.text?.count else { return }
        if textCount == 10 {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.requestOPTButton.setTitle("Send Text Message", for: .normal)
                self.requestOPTButton.isEnabled = true
                self.requestOPTButton.transform = .identity
            }
        } else {

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.requestOPTButton.setTitle("", for: .normal)
                self.requestOPTButton.isEnabled = false
                self.requestOPTButton.transform = .init(scaleX: 0.01, y: 0.01)
            }
        }
    }
    
    
    
    @objc func handleRegister(){
        self.showBlurView()
        self.showLoader(true, message: "Please wait while we send you a text message...")
        guard let phone = phoneNumberTextField.text else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber("+966\(phone)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showAlertMessage(nil,error.localizedDescription)
                return
            }
            self.removeBlurView()
            self.showLoader(false)
            self.showBanner(message: "We have sent you a text message\nPlease verify once you receive it", state: .success, location: .top,
                            presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
            guard let verificationID = verificationID else {return}
            userDefault.setValue(verificationID, forKey: "verificationID")
            userDefault.synchronize()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.verifyOPTButton.setTitle("Verify code", for: .normal)
                self.verifyOPTButton.isEnabled = true
                self.verifyOPTButton.transform = .identity
                self.verificationCodeTextField.alpha = 1
                self.animationView.play()
                self.animationView.loopMode = .loop
            }
            
        }
    }
    
    @objc func verify(){
        self.showBlurView()
        self.showLoader(true, message: "Please wait while we \nverify your phone number...")
        guard let verificationCode = verificationCodeTextField.text else { return }
        guard let verificationID = userDefault.string(forKey: "verificationID") else { return }
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                self.showAlertMessage(nil,error.localizedDescription)
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.removeBlurView()
                self.showLoader(false)
            }
            
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.showBanner(message: "we successfully verified your phone number!", state: .success, location: .top,
                                presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
            }
                
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension AuthenticationPhoneController: UITextFieldDelegate {
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phoneNumberTextField:
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789").inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= 10))
        case verificationCodeTextField:
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789").inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= 6))
        default:
            return false
        }
    }

}
