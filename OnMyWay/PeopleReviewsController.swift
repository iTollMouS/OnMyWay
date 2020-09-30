//
//  PeopleReviewsController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit

class PeopleReviewsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    func configureNavBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Reviews"
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    }

}
