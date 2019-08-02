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
    func draw(pins: String)
}

protocol HomePresentable {
    func fetchCameras()        
    func showAll()
}
