//
//  NewTripController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit

class NewTripController: UIViewController, UIScrollViewDelegate {
    
    
    
    private lazy var contentSizeView = CGSize(width: self.view.frame.width,
                                              height: self.view.frame.height + 300)
    
    
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
    // NOW we add UIViews in contentView instead of views since it is embedded in UIScrollView
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
        button.tintColor = .blueLightIcon
        button.backgroundColor = .white
        button.layer.cornerRadius = 50 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var mainContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.setHeight(height: 150)
        view.setupShadow(opacity: 0.5, radius: 20, offset: CGSize(width: 0.0, height: 8.0), color: .black)
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        return view
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
                                                                    dividerViewColor: .black, setViewHeight: 50)
    
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentLocationContainerView,
                                                       destinationContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
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
        mainContentView.anchor(top: dismissView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                               paddingTop: 20 , paddingLeft: 20, paddingBottom: 20 , paddingRight: 20)
        contentView.addSubview(topContainerView)
        topContainerView.anchor(top: mainContentView.topAnchor, left: mainContentView.leftAnchor, right: mainContentView.rightAnchor)
        topContainerView.addSubview(topStackView)
        topStackView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
    }
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
