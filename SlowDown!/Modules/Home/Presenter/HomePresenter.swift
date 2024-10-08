//
//  HomePresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

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
    }
    
    func checkUserPermisions() {
        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
        locationManager?.requestLocation()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        } else {
            onPermissionDenied()
        }
    }
    
    private func camerasRequest() {
        api.fetchAllCameras(dataSet: "fotocivicas") { (result: Result<[CameraResponse]>) in
            switch result {
            case .success(let data):
                for dat in data {
                    let datos = dat.fields
                    if datos.geoShape.type != "LineString" {
//                        print(datos.geoShape.type, datos.mainStreet, datos.geoShape.type, datos.sentido)
                        let camera = Camera(no: Int(datos.no), recordId: dat.recordid, latitude: datos.latitude, longitude: datos.longitude, mainStreet: datos.mainStreet, secondStreet: datos.secondStreet, sentido: datos.sentido, geoShape: datos.geoShape)
                        self.cameras.append(camera)
                    }
                }
                self.view?.draw(pins: self.cameras)
            case .failure(let error):
                print(error)
            }
        }

        // custom cameras
        let customCam = Camera(no: 1,
               recordId: nil,
               //19.5147563,-99.2524012
               latitude: "19.5147563", longitude: "-99.2524012",
               mainStreet: "Cruz de la arboleda",
               secondStreet: nil, sentido: nil, geoShape: nil)

        cameras.append(customCam)
    }
}

extension HomePresenter: HomePresentable {
    
    func fetchCameras() {
         camerasRequest()
    }
    
    func showDetailView(withLocation location:CLLocationCoordinate2D, withIdentifier identifier: String) {
        var camera: Camera
        for _camera in cameras {
            if let id = _camera.recordId {
                if id == identifier {
                    camera = _camera
                    coordinator?.showDetailsView(withLocation: location, withCamera: camera)
                    break
                }
            }            
        }
    }
    
    func showAll() {
        coordinator?.showListView(cameras: self.cameras)
//        notificationCenter.post(name: HomePresenter.listCamerasAllNotification, object: nil, userInfo: camerasData)
    }
    
    func attach(view: HomeViewable) {
        self.view = view
        self.view?.setup(presenter: self as HomePresentable)
    }
    
    func changeCenterButtonToActive() {
        view?.mapViewChangeCenterButtonToActive()
    }
}

extension HomePresenter: MapViewPresentable {
    func onPermissionDenied() {
        view?.promptLocationUsageRequirement()
    }
    
    func mapViewShowCenterButton() {
        view?.showMapCenterButton()
    }
}

extension HomePresenter: CLLocationManagerDelegate {
    //Verificamos la aprovación del monitoreo de la ubicación por parte del usuario
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways {
            onPermissionDenied()
        }
    }
}

extension HomePresenter: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let identifier = view.annotation?.subtitle!,
            let address = view.annotation?.title!,
            let location = view.annotation?.coordinate else { return }
        print("annotation touched with the address: ", address)
        showDetailView(withLocation: location, withIdentifier: identifier)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        guard mapView.isUserLocationVisible, !animated else { return }
        changeCenterButtonToActive()
    }    
}
