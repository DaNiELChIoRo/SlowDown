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
    private var filteredCameras = [Camera]()
    
    let notificationCenter = NotificationCenter.default
    static let listCamerasAllNotification = Notification.Name("listAllCamerasNotification")
    let searchController = UISearchController(searchResultsController: nil)
    
    init(coordinator: MainCoordinator, cameras: [Camera]) {
        self.coordinator = coordinator
        self.cameras = cameras
        self.filteredCameras = cameras
//        notificationCenter.addObserver(self, selector: #selector(didRecieveCameras), name: ListPresenter.listCamerasAllNotification, object: nil)
    }
    
    func attach(view: ListViewable) {
        self.view = view
        self.view!.setup(presenter: self as ListPresentable)
    }
    
    func setupLayout() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.view?.setupLayout(searchController: searchController)
    }
    
    func showDetailView(withCamera camera: Camera) {
        guard let longitude = Double(camera.latitude!),
            let latitude = Double(camera.longitude!) else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        coordinator?.showDetailsView(withLocation: location, withCamera: camera)
    }

    private func emulateLocation(for camera: Camera) {
        guard let longitude = Double(camera.latitude!),
            let latitude = Double(camera.longitude!) else { return }
//        coor
        
    }

    @objc func didRecieveCameras(_ notification: NSNotification) {
        if let cameras = notification.userInfo?["cameras"] as? [Camera] {
            print(cameras)
        }
    }
    
    func resetFilteredCameras() {
        filteredCameras = cameras
        view?.reloadList()
    }
}

extension ListPresenter: UISearchBarDelegate {
    //This is in order to catch when clear button is tapped!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            resetFilteredCameras()
        }
    }
    
    //This is fired when cancel button is tapped!
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetFilteredCameras()
    }
}

extension ListPresenter: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print(searchText)
            if searchText != "" {
                filterContentForSearchText(searchText)
            }
        }
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text! == ""
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCameras = cameras.filter({ (camera) -> Bool in
            guard let cameraStreeet = camera.mainStreet else { return false }
            return cameraStreeet.lowercased().contains(searchText.lowercased())
        })
        view?.reloadList()
    }
}

extension ListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering() ? filteredCameras.count : cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = isFiltering() ? filteredCameras[indexPath.row].mainStreet : cameras[indexPath.row].mainStreet
        return cell
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ListPresenter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        debugPrint("highlighted")
        tableView.deselectRow(at: indexPath, animated: true)
        let camera = cameras[indexPath.row]
        // TODO: Emulate
        emulateLocation(for: camera)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let camera = cameras[indexPath.row]
        showDetailView(withCamera: camera)
        print(camera.self)
    }
}
