//
//  NewTripController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit

class NewTripController: UIViewController, UIScrollViewDelegate {
    
    
    
    
    private lazy var contentSizeView = CGSize(width: self.view.frame.width,
                                              height: self.view.frame.height + 80)
    
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.scrollIndicatorInsets = .zero
        scrollView.contentSize = contentSizeView
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    
    private let blurView : UIVisualEffectView = {
        let blurView = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurView)
        return view
    }()
    
    
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.frame.size = contentSizeView
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var dismissView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.setDimensions(height: 50, width: 50)
        button.tintColor = .white
        button.layer.cornerRadius = 50 / 2
        button.backgroundColor = UIColor.blueLightIcon.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.setupShadow(opacity: 0.5, radius: 3, offset: CGSize(width: 0.0, height: 8.0), color: .black)
        return button
    }()
    
    
    private lazy var mainContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.setupShadow(opacity: 0.2, radius: 20, offset: CGSize(width: 0.0, height: 8.0), color: .black)
        return view
    }()
    
    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.setHeight(height: 150)
        view.setupShadow(opacity: 0.2, radius: 20, offset: CGSize(width: 0.0, height: 8.0), color: .black)
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Setup your trip info"
        label.textColor = UIColor.blueLightIcon.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.setHeight(height: 40)
        return label
    }()
    
    
    private let currentLocationTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "Your current location",
                                                           placeholderColor: .blueLightFont, isSecure: false)
    private lazy var currentLocationContainerView = CustomContainerView(image:  UIImage(systemName: "target"),
                                                                        textField: currentLocationTextField, iconTintColor: .blueLightIcon,
                                                                        dividerViewColor: .black, setViewHeight: 50)
    
    private let destinationTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "destination",
                                                       placeholderColor: .blueLightFont, isSecure: false)
    private lazy var destinationContainerView = CustomContainerView(image:  UIImage(systemName: "location.fill"),
                                                                    textField: destinationTextField, iconTintColor: .blueLightIcon,
                                                                    dividerViewColor: .white, setViewHeight: 50)
    
    private let meetingForPickupTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "Where you want to meet",
                                                       placeholderColor: .blueLightFont, isSecure: false)
    private lazy var meetingForPickupDestinationContainerView = CustomContainerView(image:  #imageLiteral(resourceName: "46041"),
                                                                    textField: meetingForPickupTextField, iconTintColor: .blueLightIcon,
                                                                    dividerViewColor: .black, setViewHeight: 50)
    private let packageDescriptionTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "what inside the package ?",
                                                       placeholderColor: .blueLightFont, isSecure: false)
    private lazy var packageDescriptionContainerView = CustomContainerView(image:  UIImage(systemName: "shippingbox.fill"),
                                                                    textField: packageDescriptionTextField, iconTintColor: .blueLightIcon,
                                                                    dividerViewColor: .black, setViewHeight: 50)
    
    private let whatCanTakeTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "what can you take?",
                                                       placeholderColor: .blueLightFont, isSecure: false)
    private lazy var whatCanTakeContainerView = CustomContainerView(image:  #imageLiteral(resourceName: "car"),
                                                                    textField: whatCanTakeTextField, iconTintColor: .blueLightIcon,
                                                                    dividerViewColor: .black, setViewHeight: 50)
    
    private let timeToPickPackageTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "when to meet?",
                                                       placeholderColor: .blueLightFont, isSecure: false)
    private lazy var timeToPickPackageContainerView = CustomContainerView(image:  UIImage(systemName: "clock.fill"),
                                                                    textField: timeToPickPackageTextField, iconTintColor: .blueLightIcon,
                                                                    dividerViewColor: .black, setViewHeight: 50)
    

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentLocationContainerView,
                                                       destinationContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [meetingForPickupDestinationContainerView,
                                                       packageDescriptionContainerView,
                                                       whatCanTakeContainerView,
                                                       timeToPickPackageContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.setHeight(height: CGFloat(stackView.subviews.count * 70))
        return stackView
    }()
    
    private lazy var setupDateAndTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.setTitle("Setup date and time travel\t", for: .normal)
        button.setHeight(height: 50)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.blueLightIcon.withAlphaComponent(0.8)
        button.layer.cornerRadius = 50 / 2
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDateAndTimeTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        self.hideKeyboardWhenTouchOutsideTextField()
    }
    
    func configureUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dismissView)
        dismissView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 60, paddingLeft: 36)
        contentView.addSubview(mainContentView)
        mainContentView.anchor(top: dismissView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,
                               paddingTop: 20 , paddingLeft: 20, paddingBottom: 20 , paddingRight: 20, height: 550)
        contentView.addSubview(titleLabel)
        titleLabel.centerY(inView: dismissView, leftAnchor: dismissView.rightAnchor, paddingLeft: 20)
        titleLabel.centerX(inView: contentView)
        contentView.addSubview(topContainerView)
        topContainerView.anchor(top: mainContentView.topAnchor, left: mainContentView.leftAnchor, right: mainContentView.rightAnchor)
        topContainerView.addSubview(topStackView)
        topStackView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        mainContentView.addSubview(middleStackView)
        middleStackView.anchor(top: topStackView.bottomAnchor, left: mainContentView.leftAnchor, right: mainContentView.rightAnchor,
                               paddingTop: 0, paddingLeft: 20, paddingRight: 20)
        mainContentView.addSubview(setupDateAndTimeButton)
        setupDateAndTimeButton.anchor(left: mainContentView.leftAnchor, bottom: mainContentView.bottomAnchor ,right: mainContentView.rightAnchor,
                                      paddingLeft: 20, paddingBottom: 20 ,paddingRight: 20)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
    }
    
    @objc func handleDateAndTimeTapped(){
        let dateAndTimeController = DateAndTimeController()
        dateAndTimeController.modalPresentationStyle = .fullScreen
        present(dateAndTimeController, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(){
        if scrollView.frame.origin.y == 0 {
            self.scrollView.frame.origin.y -= UIScreen.main.bounds.height > 830 ? 20 : 100
        }
    }
    
    @objc func keyboardWillHide(){
        if scrollView.frame.origin.y != 0 {
            self.scrollView.frame.origin.y = 0
        }
    }
    
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
