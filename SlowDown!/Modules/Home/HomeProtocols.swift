//
//  HomeProtocols.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import MapKit

protocol HomeViewable {
    func setup(presenter: HomePresentable)
    func showListButton( action: @escaping () -> Void )
    func draw(pins: [Camera])
    func promptLocationUsageRequirement()
    func showMapCenterButton()
}

protocol HomePresentable {
    var view: HomeViewable? { get set }
    var coordinator: MainCoordinator? { get set }
    func fetchCameras()        
    func showAll()
    func showDetailView(withLocation location:CLLocationCoordinate2D, withIdentifier identifier: String)
    func mapViewShowCenterButton()
}
