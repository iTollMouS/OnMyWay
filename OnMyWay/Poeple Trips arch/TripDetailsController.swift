//
//  TripDetailsController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/4/20.
//

import UIKit

private let reuseIdentifier = "TripDetailsCell"

class TripDetailsController: UIViewController {
    
    private lazy var headerView = TripDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TripDetailsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 160
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureDelegates()
    }
    
    func configureDelegates(){
        headerView.delegate = self
    }
    
    func configureUI(){
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        view.addSubview(tableView)
        tableView.fillSuperviewSafeAreaLayoutGuide()
    }
    

}

extension TripDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TripDetailsViewModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfCells = TripDetailsViewModel(rawValue: section) else { return 0 }
        return numberOfCells.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TripDetailsCell
        guard let viewModel = TripDetailsViewModel(rawValue: indexPath.section) else { return cell }
        cell.viewModel = viewModel
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellHeight = TripDetailsViewModel(rawValue: indexPath.section) else { return 0 }
        return cellHeight.cellHeight
    }
    
    
}

extension TripDetailsController : TripDetailsHeaderViewDelegate {
    func handleStartToChat(_ view: TripDetailsHeaderView) {
        
        // it is working , now you have to implement the functionality
        print("DEBUG: ctart chat in veiw controller ")
    }
    
    
}
