//
//  HomePresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import CoreLocation

class HomePresenter: NSObject {
    
    internal var coordinator:MainCoordinator?
    private var api: API!
    internal var view: HomeViewable?
    private var locationManager: CLLocationManager!
    private var cameras = [Camera]()
    
    let notificationCenter = NotificationCenter.default
    static let listCamerasAllNotification = Notification.Name("listAllCamerasNotification")
    
    init(api: API, coordinator: MainCoordinator) {
        super.init()
        self.api = api
        self.coordinator = coordinator
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            
        }
    }
    
    func camerasRequest() {
        api.fetchAllCameras(dataSet: "fotocivicas") { (result: Result<[CameraResponse]>) in
            switch result {
            case .success(let data):
                for dat in data {
                    let datos = dat.fields
//                    print(datos.geoShape.type, datos.mainStreet, datos.geoShape.type, datos.sentido)
                    if datos.geoShape.type != "LineShape" {
                        let camera = Camera(no: Int(datos.no), recordId: dat.recordid, latitude: datos.latitude, longitude: datos.longitude, mainStreet: datos.mainStreet, secondStreet: datos.secondStreet, geoShape: datos.geoShape)
                        self.cameras.append(camera)
                    }
                }
                self.view?.draw(pins: self.cameras)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomePresenter: HomePresentable {
    
    func fetchCameras() {
         camerasRequest()
    }
    
    func showDetailView() {
        coordinator?.showDetailsView()
    }
    
    func showAll() {
        let camerasData:[String: Any] = ["cameras": cameras]
        coordinator?.showListView(cameras: self.cameras)
//        notificationCenter.post(name: HomePresenter.listCamerasAllNotification, object: nil, userInfo: camerasData)
    }
    
    func attach(view: HomeViewable) {
        self.view = view
        self.view?.setup(presenter: self as HomePresentable)
        //        self.view?.showListButton {
        //
        //        }       
    }
}

extension HomePresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
        } 
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al intentar obtener la ubicación del usuario!, error message: \(error.localizedDescription)")
    }
}
