//
//  DetailProtocols.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

protocol DetailViewable {
    var presenter: DetailPresentable? { get set }
    func setup(presenter: DetailPresentable)    
}

protocol DetailPresentable {
    var coordinator: MainCoordinator? { get set }
    var view: DetailViewable? { get set }
    func attach(view: DetailViewable)
    func showAll()
}
