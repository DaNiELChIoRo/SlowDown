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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setup(presenter: ListPresentable) {
        self.presenter = presenter
        self.tableView.dataSource = (presenter as! UITableViewDataSource)
        self.tableView.delegate = (presenter as! UITableViewDelegate)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        presenter.setupLayout()
    }

}

extension ListViewController {
    func setupLayout(searchController: UISearchController) {
        view.backgroundColor = .white
        title = "Fotocivicas"
//        navigationItem.largeTitleDisplayMode = .never        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar por calle"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
