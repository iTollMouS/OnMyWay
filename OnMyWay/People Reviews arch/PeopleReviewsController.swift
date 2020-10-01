//
//  PeopleReviewsController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit
import SwiftEntryKit
import Cosmos

private let reuseIdentifier = "PeopleReviewsCell"

class PeopleReviewsController: UIViewController {
    
    var data  = [
        "here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc." ,
        
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as " ,
        
        "oots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a \n Lorem Ipsum passage, and going through the cites  \nof the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.3" ,
        
        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem \n quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, \n qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?" , "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains."
        
    ]
    
    private lazy var headerView = PeopleReviewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    
    private lazy var reviewSheetPopOver = UIView()
    var attributes = EKAttributes.bottomNote
    
    
    private lazy var writeReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        button.setTitle("Write a review", for: .normal)
        button.setDimensions(height: 50, width: view.frame.width - 50)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9843137255, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.setupShadow(opacity: 0.2, radius: 10, offset: CGSize(width: 0.0, height: 3), color: .white)
        button.addTarget(self, action: #selector(handleShowReview), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.setHeight(height: 100)
        view.addSubview(writeReviewButton)
        writeReviewButton.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 16)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.register(PeopleReviewsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 1000
        return tableView
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "How was Tariq Almazyad\ndealing with your order"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.setHeight(height: 60)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var drawerView: UIView = {
        let view = UIView()
        view.setDimensions(height: 5, width: 60)
        view.layer.cornerRadius = 2
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var topDividerView: UIView = {
        let view = UIView()
        view.setHeight(height: 1)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var bottomDividerView: UIView = {
        let view = UIView()
        view.setHeight(height: 1)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.filledImage = #imageLiteral(resourceName: "RatingStarFilled").withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = #imageLiteral(resourceName: "RatingStarEmpty").withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 26
        view.settings.totalStars = 5
        view.settings.textMargin = 10
        view.settings.textFont = .boldSystemFont(ofSize: 20)
        view.settings.textColor = .white
        view.settings.starMargin = 3.0
        view.backgroundColor = .clear
        view.setDimensions(height: 30, width: 180)
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Add comment ......"
        label.textAlignment = .left
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textColor = .blueLightFont
        textView.delegate = self
        textView.setHeight(height: 200)
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.clipsToBounds = true
        textView.keyboardAppearance = .dark
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: textView.topAnchor, left: textView.leftAnchor,
                                paddingTop: 8, paddingLeft: 8)
        return textView
    }()
    
    private lazy var submitReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.alpha = 0
        button.transform = .init(scaleX: 0.0, y: 0.01)
        button.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        button.setTitle("Submit Review", for: .normal)
        button.setDimensions(height: 50, width: view.frame.width - 50)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9843137255, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.setupShadow(opacity: 0.2, radius: 10, offset: CGSize(width: 0.0, height: 3), color: .white)
        button.addTarget(self, action: #selector(handleDismissPopView), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        configureReviewSheetPopOver()
        self.hideKeyboardWhenTouchOutsideTextField()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateReviewOnTouch(){
        ratingView.didTouchCosmos = { self.ratingView.text = "\($0)" }
        ratingView.didFinishTouchingCosmos = { self.ratingView.text = "\($0)" }
    }
    
    
    func configureReviewSheetPopOver(){
        
        reviewSheetPopOver.addSubview(drawerView)
        drawerView.centerX(inView: reviewSheetPopOver, topAnchor: reviewSheetPopOver.topAnchor, paddingTop: 10)
        
        reviewSheetPopOver.addSubview(reviewLabel)
        reviewLabel.anchor(top: drawerView.topAnchor, left: reviewSheetPopOver.leftAnchor,
                           right: reviewSheetPopOver.rightAnchor, paddingTop: 12)
        
        reviewSheetPopOver.addSubview(ratingView)
        ratingView.centerX(inView: reviewLabel, topAnchor: reviewLabel.bottomAnchor, paddingTop: 12)
        
        reviewSheetPopOver.addSubview(topDividerView)
        topDividerView.anchor(top: ratingView.bottomAnchor, left: reviewSheetPopOver.leftAnchor,
                              right: reviewSheetPopOver.rightAnchor, paddingTop: 20)
        
        reviewSheetPopOver.addSubview(reviewTextView)
        reviewTextView.anchor(top: topDividerView.bottomAnchor, left: reviewSheetPopOver.leftAnchor, right: reviewSheetPopOver.rightAnchor)
        
        reviewSheetPopOver.addSubview(submitReviewButton)
        submitReviewButton.centerX(inView: reviewTextView, topAnchor: reviewTextView.bottomAnchor, paddingTop: 80)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChanger), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func handleTextInputChanger(){
        placeholderLabel.isHidden = !reviewTextView.text.isEmpty
        if !reviewTextView.text.isEmpty {
            submitReviewButton.setTitle("Submit Review", for: .normal)
            submitReviewButton.transform = .identity
            submitReviewButton.alpha = 1
        } else {
            submitReviewButton.alpha = 0
            submitReviewButton.transform = .init(scaleX: 0.0, y: 0.01)
        }
    }
    
    func configureTableView(){
        view.addSubview(buttonContainerView)
        buttonContainerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: buttonContainerView.topAnchor, right: view.rightAnchor)
    }
    
    func configureNavBar(){
        self.title = "Reviews"
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    }
}

extension PeopleReviewsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PeopleReviewsCell
        cell.selectionStyle = .none
        cell.reviewLabel.text = data[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PeopleReviewsController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 300;
    }
}


extension PeopleReviewsController {
    
    func configureReviewSheet(){
        reviewSheetPopOver.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        reviewSheetPopOver.layer.cornerRadius = 10
        reviewSheetPopOver.setDimensions(height: 800, width: view.frame.width)
        attributes.screenBackground = .visualEffect(style: .dark)
        attributes.positionConstraints.safeArea = .overridden
        attributes.positionConstraints.verticalOffset = -300
        attributes.name = "Top Note"
        attributes.windowLevel = .normal
        attributes.position = .bottom
        attributes.precedence = .override(priority: .max, dropEnqueuedEntries: false)
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.statusBar = .light
        attributes.lifecycleEvents.willAppear = { [self] in
            // Executed before the entry animates inside
            ratingView.rating = 3
            ratingView.text = "\(3.0)"
            print("willAppear")
        }
        
        attributes.lifecycleEvents.didAppear = { [self] in
            // Executed after the entry animates inside
            updateReviewOnTouch()
            print("didAppear")
        }
        
        attributes.lifecycleEvents.willDisappear = {
            // Executed before the entry animates outside
            print("willDisappear")
        }
        
        attributes.lifecycleEvents.didDisappear = {
            // Executed after the entry animates outside
            print("didDisappear")
        }
        attributes.entryBackground = .visualEffect(style: .dark)
        SwiftEntryKit.display(entry: reviewSheetPopOver, using: attributes)
    }
    
    @objc func handleShowReview(){
        configureReviewSheet()
    }
    
    @objc func handleDismissPopView(){
        SwiftEntryKit.dismiss()
    }
    
}

