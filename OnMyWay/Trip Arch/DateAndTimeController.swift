//
//  DateAndTimeController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit
import FSCalendar


class DateAndTimeController: UIViewController, UIScrollViewDelegate {
    
    
    
    private lazy var contentSizeView = CGSize(width: self.view.frame.width,
                                              height: self.view.frame.height + 200)
    
    
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
    
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.frame.size = contentSizeView
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your date and time of your travel"
        label.textAlignment = .center
        label.textColor = .blueLightIcon
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.setHeight(height: 80)
        return label
    }()
    
    private lazy var tripDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Design your trip"
        label.textAlignment = .left
        label.textColor = .blueLightIcon
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.setHeight(height: 40)
        return label
    }()
    
    private lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.backgroundColor = .white
        calendarView.scrollDirection = .horizontal
        calendarView.setHeight(height: UIScreen.main.bounds.height > 800 ? 400 : 300)
        calendarView.delegate = self
        calendarView.locale = Locale(identifier: "ar")
        calendarView.dataSource = self
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 17)
        calendarView.appearance.headerTitleColor = .blueLightIcon // monthly header color
        calendarView.appearance.weekdayTextColor = .blueLightIcon // weekly header color
        calendarView.appearance.todayColor = .redIcon
        calendarView.appearance.titleSelectionColor = .white
        calendarView.appearance.todaySelectionColor = .redIcon
        calendarView.appearance.titleTodayColor = .blueLightIcon
        calendarView.appearance.titleWeekendColor = .black // color your weekend
        calendarView.appearance.titleDefaultColor = .blueLightIcon // color your week days
        calendarView.appearance.selectionColor = .blueLightIcon
        return calendarView
    }()
    
    private lazy var dateTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "clickhere",
                                                     placeholderColor: .black, isSecure: false)
    
    private lazy var dateTextContainerView = CustomContainerView(image: UIImage(systemName: "calendar.badge.plus"),
                                                                 textField: dateTextField, iconTintColor: .blueLightIcon,
                                                                 dividerViewColor: .black, setViewHeight: 50)
    
    private lazy var timeTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "Click here to configure your time",
                                                     placeholderColor: .black, isSecure: false)
    
    private lazy var timeContainerView = CustomContainerView(image: UIImage(systemName: "clock.fill"),
                                                             textField: timeTextField, iconTintColor: .blueLightIcon,
                                                             dividerViewColor: .black, setViewHeight: 50)
    
    
    private lazy var packageInfoTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textColor = .blueLightIcon
        textView.setHeight(height: 100)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tripDetailsTitleLabel,
                                                       dateTextContainerView,
                                                       timeContainerView,
                                                       packageInfoTextView,
                                                       submitTripe])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingLeft: 14, paddingRight: 14)
        view.backgroundColor = UIColor.blueLightFont.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var submitTripe: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(height: 60)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Submit new one ", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.blueLightIcon.withAlphaComponent(0.8)
        button.layer.cornerRadius = 60 / 2
        button.clipsToBounds = true
        return button
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
    
    private let blurView : UIVisualEffectView = {
        let blurView = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurView)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTouchOutsideTextField()
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dismissView)
        dismissView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 60, paddingLeft: 36)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: dismissView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,
                          paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(calendarView)
        calendarView.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        contentView.addSubview(bottomContainerView)
        bottomContainerView.centerX(inView: calendarView, topAnchor: calendarView.bottomAnchor, paddingTop: 10)
        bottomContainerView.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(){
        if scrollView.frame.origin.y == 0 {
            self.scrollView.frame.origin.y -= UIScreen.main.bounds.height > 830 ? 260 : 300
        }
    }
    
    @objc func keyboardWillHide(){
        if scrollView.frame.origin.y != 0 {
            self.scrollView.frame.origin.y = 0
        }
    }
    
}

extension DateAndTimeController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                dateTextField.text = date.convertDate(formattedString: .formattedType1)
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
                dateTextField.text = date.convertDate(formattedString: .formattedType1)
    }
    
}
// prevent user to select time in the past
extension DateAndTimeController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
