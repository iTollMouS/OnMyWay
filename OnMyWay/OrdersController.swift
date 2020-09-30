//
//  OrdersController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit

private let reuseIdentifier = "OrdersCell"

class OrdersController: UIViewController {
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["New Orders", "Done"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    private lazy var paddingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl])
        stackView.layoutMargins = .init(top: 12, left: 12, bottom: 6, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [paddingStack, tableView])
        stackView.axis = .vertical
        return stackView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUI(){
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        view.addSubview(stackView)
        stackView.fillSuperviewSafeAreaLayoutGuide()
    }
    
    
    func configureNavBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Orders"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.dismissPopupBar(animated: true, completion: nil)
    }

}

extension OrdersController: UITableViewDelegate, UITableViewDataSource  {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
