//
//  SafetyControllerGuidelines.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/28/20.
//

import UIKit

private let reuseIdentifier = "SafetyCell"

class SafetyControllerGuidelines: UITableViewController {
    
    private lazy var headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
    private lazy var footerView = SafetyFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureTableView(){
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .blueLightFont
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.register(SafetyCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 100
        tableView.allowsSelection = false
        tableView.tableFooterView = footerView
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SafetyCellViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SafetyCell
        guard let viewModel = SafetyCellViewModel(rawValue: indexPath.row) else { return cell }
        cell.viewModel = viewModel
        return cell
    }
    
    
    
}
