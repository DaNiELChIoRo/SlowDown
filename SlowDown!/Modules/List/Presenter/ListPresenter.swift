//
//  ListPresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import MapKit

class ListPresenter: NSObject, ListPresentable {
    var coordinator: MainCoordinator?
    var view: ListViewable?
    private var cameras = [Camera]()
    
    let notificationCenter = NotificationCenter.default
    static let listCamerasAllNotification = Notification.Name("listAllCamerasNotification")
    
    init(coordinator: MainCoordinator, cameras: [Camera]) {
        self.coordinator = coordinator
        self.cameras = cameras
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

extension ListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cameras[indexPath.row].mainStreet
        return cell
    }
}

extension ListPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let camera = cameras[indexPath.row]
        showDetailView(withCamera: camera)
        print(camera.self)
    }
}
