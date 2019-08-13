//
//  HomePresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import CoreLocation

class WGS84 {
    var latitude: Double
    var longuitude: Double
    var distance: Double
    
    init(latitude: Double, longuitude: Double, distance: Double) {
        self.latitude = latitude
        self.longuitude = longuitude
        self.distance = distance
    }
}

class HomePresenter: NSObject {
    
    private var api: API!
    private var view: HomeViewable?
    private var locationManager: CLLocationManager!
    private var coordinates: WGS84?
    
    init(api: API) {
        super.init()
        self.api = api
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            self.coordinates = WGS84(latitude: locationManager.location!.coordinate.latitude, longuitude: locationManager.location!.coordinate.longitude, distance: 1000)
        }
    }
    
    func dommyRequest() {
        let customCoordinates = WGS84(latitude: 19.3604491, longuitude: -99.162556, distance: 1000)
//        guard let coordinates = coordinates else { return }
        api.fetchAllCameras(dataSet: "fotocivicas", location: customCoordinates) { (result: Result<[CameraResponse]>) in
            switch result {
            case .success(let data):
                var cameras = [Camera]()
                for dat in data {
                    let datos = dat.fields
                    datos.geoShape.type
                    let camera = Camera(no: Int(datos.no), recordId: dat.recordid , latitude: datos.latitude, longitude: datos.longitude, mainStreet: datos.mainStreet, secondStreet: datos.secondStreet)
                    cameras.append(camera)
                    print(camera.mainStreet, camera.latitude, camera.longitude)
                }
                self.view?.draw(pins: cameras)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // TODO - tell the coordinator to send us to the view
    private func showListButtonHandler() {
        
    }
    
}

extension HomePresenter: HomePresentable {
    
    func fetchCameras() {
         dommyRequest()
    }
    
    func showAll() {
        
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
