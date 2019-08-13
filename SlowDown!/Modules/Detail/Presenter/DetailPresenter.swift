//
//  DetailPresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

class DetailPresenter: NSObject {
    
    internal var coordinator: MainCoordinator?
    internal var view: DetailViewable?
    
    init(coordinator: MainCoordinator) {
        super.init()
        self.coordinator = coordinator
    }

}

extension DetailPresenter: DetailPresentable {
    func attach(view: DetailViewable) {
        self.view = view
        self.view?.setup(presenter: self as DetailPresentable)
    }
    
    func showAll() {
        
    }    
    
}
