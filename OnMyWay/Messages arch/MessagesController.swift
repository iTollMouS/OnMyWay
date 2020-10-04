//
//  NotificationsController.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/29/20.
//

import UIKit

private let reuseIdentifier = "MessagesCell"

class MessagesController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        configureSearchController()
        configureRefreshControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.dismissPopupBar(animated: true, completion: nil)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    func configureRefreshControl(){
        refreshController.tintColor = .white
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:
                                                                [.foregroundColor: UIColor.white])
        tableView.refreshControl = refreshController
        
    }
    func configureSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func configureTableView(){
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.register(MessagesCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        tableView.rowHeight = 100
        
        
    }
    
    func configureNavBar(){
        self.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(handleDismissal))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshController.isRefreshing {
            // download user
            self.refreshController.endRefreshing()
        }
    }
    
}

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessagesCell
        return cell
    }
}

extension MessagesController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG: \(searchController.searchBar.text)")
    }
    
}
