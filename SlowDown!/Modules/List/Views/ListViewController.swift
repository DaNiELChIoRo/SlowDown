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
    private var listTable: ListTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(cameras: [Camera]) {
        super.init(nibName: nil, bundle: nil)
        self.cameras = cameras
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(presenter: ListPresentable) {
        view.backgroundColor = .white
        title = "Lista de todas las fotocivicas"
        setupView()
    }
    
    func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cameras.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cameras[indexPath.row].mainStreet
        return cell
    }

}

extension ListViewController {
    func setupLayout() {
        
    }
}
