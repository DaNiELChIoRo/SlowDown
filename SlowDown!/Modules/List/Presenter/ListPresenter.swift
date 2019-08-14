//
//  ListPresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation
import MapKit

class ListPresenter: ListPresentable {
    var coordinator: MainCoordinator?
    var view: ListViewable?
    
    let notificationCenter = NotificationCenter.default
    static let listCamerasAllNotification = Notification.Name("listAllCamerasNotification")
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
//        notificationCenter.addObserver(self, selector: #selector(didRecieveCameras), name: ListPresenter.listCamerasAllNotification, object: nil)
    }
    
    func attach(view: ListViewable) {
        self.view = view
        self.view!.setup(presenter: self as ListPresentable)
    }
    
    func showDetailView(withCamera camera: Camera) {
        guard let longitude = Double(camera.latitude!),
            let latitude = Double(camera.longitude!) else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        coordinator?.showDetailsView(withLocation: location, withCamera: camera)
    }
    
    @objc func didRecieveCameras(_ notification: NSNotification) {
        if let cameras = notification.userInfo?["cameras"] as? [Camera] {
            print(cameras)
        }
    }
    
}
