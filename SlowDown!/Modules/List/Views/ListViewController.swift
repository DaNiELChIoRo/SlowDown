//
//  ListViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import SnapKit

class ListViewController: UITableViewController, ListViewable {
    
    internal var presenter: ListPresentable?
    private var cameras = [Camera]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setup(presenter: ListPresentable) {
        self.presenter = presenter
        self.tableView.dataSource = (presenter as! UITableViewDataSource)
        self.tableView.delegate = (presenter as! UITableViewDelegate)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setupLayout()
    }

}

extension ListViewController {
    func setupLayout() {
        view.backgroundColor = .white
        title = "Fotocivicas"
//        navigationItem.largeTitleDisplayMode = .never
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar por calle"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
