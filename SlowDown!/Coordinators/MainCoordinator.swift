//
//  MainCoordinator.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let api = API(network: Network(config: config, session: session))
        let presenter = HomePresenter(api: api, coordinator: self)
        presenter.attach(view: homeViewController as HomeViewable)
        navigationController.pushViewController(homeViewController, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
    }        
    
    func showDetailsView() {
        let detailsView = DetailViewController()
        let presenter = DetailPresenter(coordinator: self)
        presenter.attach(view: detailsView as DetailViewable)
        navigationController.pushViewController(detailsView, animated: true)
    }
    
    func showListView(cameras: [Camera]) {
        let listView = ListViewController(cameras: cameras)
        let presenter = ListPresenter(coordinator: self)
        presenter.attach(view: listView as ListViewable)
        navigationController.pushViewController(listView, animated: true)
    }
    
}