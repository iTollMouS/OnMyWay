//
//  ProfileController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit

class ProfileController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(withTitle: "Profile", largeTitleColor: #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1), tintColor: .white, navBarColor: #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1),
                               smallTitleColorWhenScrolling: .dark, prefersLargeTitles: true)
        view.backgroundColor = .white
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let demoVC = PeopleReviewsController()
        demoVC.popupItem.title = "People Reviews "
        demoVC.popupItem.subtitle = "Tab here to see who wrote a review about you"
        demoVC.popupItem.progress = 0.34
        tabBarController?.presentPopupBar(withContentViewController: demoVC, animated: true, completion: nil)
    }
    
}
