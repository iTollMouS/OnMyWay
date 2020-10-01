//
//  PeopleReviewsController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit


private let reuseIdentifier = "PeopleReviewsCell"

class PeopleReviewsController: UITableViewController {

    
    private lazy var headerView = PeopleReviewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureTableView()
        
    }
    
    func configureTableView(){
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.register(PeopleReviewsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 180
    }

    
    func configureNavBar(){
        self.title = "Reviews"
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    }
}

extension PeopleReviewsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PeopleReviewsCell
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}


