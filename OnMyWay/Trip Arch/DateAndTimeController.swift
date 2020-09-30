//
//  DateAndTimeController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/27/20.
//

import UIKit
import FSCalendar


protocol DateAndTimeControllerDelegate: class {
    func dismissDateAndTimeController(_ view: DateAndTimeController)
}


class DateAndTimeController: UIViewController, UIScrollViewDelegate {
    
    
    
    private lazy var contentSizeView = CGSize(width: self.view.frame.width,
                                              height: self.view.frame.height + 200)
    
    
    weak var delegate: DateAndTimeControllerDelegate?
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
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
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose date and time of your travel"
        label.textAlignment = .center
        label.textColor = .blueLightIcon
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.setHeight(height: 80)
        label.clipsToBounds = true
        label.layer.masksToBounds = false
        label.setupShadow(opacity: 0.2, radius: 3, offset: CGSize(width: 0.0, height: 8.0), color: .black)
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
        calendarView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        calendarView.scrollDirection = .horizontal
        calendarView.setHeight(height: UIScreen.main.bounds.height > 800 ? 400 : 300)
        calendarView.delegate = self
        calendarView.locale = Locale(identifier: "ar")
        calendarView.dataSource = self
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 17)
        
        calendarView.appearance.headerTitleColor = .white // monthly header color
        calendarView.appearance.weekdayTextColor = .gray // weekly header color
        
        calendarView.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.1)
        // today configure selection
        calendarView.appearance.todayColor = .blueLightIcon
        calendarView.appearance.titleTodayColor = .white
        calendarView.appearance.todaySelectionColor = .blueLightIcon
        
        // selection
        calendarView.appearance.titleSelectionColor = .white
        calendarView.appearance.selectionColor = .blueLightIcon
        
        calendarView.appearance.titleWeekendColor = UIColor.white.withAlphaComponent(0.5) // color your weekend
        calendarView.appearance.titleDefaultColor = .white // color your week days
        
        calendarView.clipsToBounds = true
        calendarView.layer.masksToBounds = false
        calendarView.layer.cornerRadius = 20
        calendarView.setupShadow(opacity: 0.2, radius: 3, offset: CGSize(width: 0.0, height: 8.0), color: .black)
        return calendarView
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = CustomTextField(textColor: .blueLightIcon, placeholder: "Please choose your date from calendar above",
                                        placeholderColor: .blueLightIcon, isSecure: false)
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    private lazy var dateTextContainerView = CustomContainerView(image: UIImage(systemName: "calendar.badge.plus"),
                                                                 textField: dateTextField, iconTintColor: .blueLightIcon,
                                                                 dividerViewColor: .blueLightIcon, setViewHeight: 50)
    
    private lazy var timeTextField = CustomTextField(textColor: .blueLightIcon, placeholder: "Click here to configure your time",
                                                     placeholderColor: .blueLightIcon, isSecure: false)
    
    private lazy var timeContainerView = CustomContainerView(image: UIImage(systemName: "clock.fill"),
                                                             textField: timeTextField, iconTintColor: .blueLightIcon,
                                                             dividerViewColor: .blueLightIcon, setViewHeight: 50)
    
    
    private lazy var packageInfoTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textColor = .blueLightIcon
        textView.setHeight(height: 100)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 12)
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
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Submit new one ", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.blueLightIcon.withAlphaComponent(0.8)
        button.layer.cornerRadius = 60 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSubmitNewTrip), for: .touchUpInside)
        return button
    }()
    
    private lazy var dismissView: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
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
    
    private lazy var timestampPickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.addTarget(self, action: #selector(handleTimeSelected(_ :)), for: .valueChanged)
        return pickerView
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barTitle = UIBarButtonItem(title: "اختر وقت السفر", style: .plain, target: nil, action: nil)
        let dismissButton = UIBarButtonItem(title: "تم", style: .plain, target: self,
                                            action: #selector(handlePickViewDismissal))
        barTitle.isEnabled = false
        barTitle.tintColor = .white
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.setItems([barTitle,flexButton, dismissButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Papers , bags , etc"
        label.textAlignment = .left
        label.textColor = .blueLightIcon
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTouchOutsideTextField()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    @objc func handlePickViewDismissal(){
        timeTextField.endEditing(true)
    }
    
    @objc func handleTimeSelected(_ sender: UIDatePicker){
        timeTextField.text = sender.date.convertDate(formattedString: .timeOnly)
    }
    
    func configureUI(){
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
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

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChanger), name: UITextView.textDidChangeNotification, object: nil)
        
        
        timeTextField.delegate = self
        timeTextField.inputView = timestampPickerView
        timeTextField.inputAccessoryView = toolbar
        dateTextField.isUserInteractionEnabled = false
        packageInfoTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: packageInfoTextView.topAnchor, left: packageInfoTextView.leftAnchor,
                                paddingTop: 8, paddingLeft: 8)
        
    }
    
    @objc func handleSubmitNewTrip(){
        delegate?.dismissDateAndTimeController(self)
    }
    
    @objc func handleTextInputChanger(){
        placeholderLabel.isHidden = !packageInfoTextView.text.isEmpty
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
        dateTextField.text = date.convertDate(formattedString: .formattedType2)
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateTextField.text = date.convertDate(formattedString: .formattedType2)
    }
    
}
// prevent user to select time in the past
extension DateAndTimeController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension DateAndTimeController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return  }
        if text.isEmpty {
            timeTextField.text = timestampPickerView.date.convertDate(formattedString: .timeOnly)
        }
    }
}
