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
        let presenter = HomePresenter(api: api)
        presenter.attach(view: homeViewController as HomeViewable)
        navigationController.pushViewController(homeViewController, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true        
    }
    
    
}
