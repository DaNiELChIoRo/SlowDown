//
//  ListProtocols.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

protocol ListPresentable {
    var coordinator: MainCoordinator? { get set}
    var view: ListViewable? { get set }
    func attach(view: ListViewable)
}

protocol ListViewable {
    var presenter: ListPresentable? { set get }
    func setup(presenter: ListPresentable)
}
