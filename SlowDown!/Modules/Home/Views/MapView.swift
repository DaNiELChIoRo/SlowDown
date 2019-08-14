//
//  MapView.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/8/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class MapView: MKMapView  {
    
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    var cameraLocations = [MKPointAnnotation]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocationServices()
        setupView(nil)
    }
    
    override func layoutSubviews() {
        if let compass = self.subviews.filter({ $0.isKind(of: NSClassFromString("MKCompassView")!) }).first {
            compass.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(_width*0.03)
                make.trailing.equalToSuperview().offset(-_width*0.03)
            }
        }
    }
    
    init(withLocation location: CLLocationCoordinate2D?) {
        self.init()
        setupLocationServices()
        setupView(location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ location: CLLocationCoordinate2D?) {
        guard let userCoordinates = locationManager?.location?.coordinate else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        var region:MKCoordinateRegion
        if let location = location {
            region = MKCoordinateRegion(center: location, span: span)
            setCameraLocation(withLocation: location)
            showsUserLocation = false
        } else {
            region = MKCoordinateRegion(center: userCoordinates, span: span)
            showsUserLocation = true
        }
        showsCompass = true
        setRegion(region, animated: true)
        showsScale = true
    }
    
    func setCameraLocation(withLocation location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        addAnnotation(annotation)
        setCompassLayout()
    }
    
    func setupLocationServices() {
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestLocation()
//        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    func setCameraLocations(_ locations: [MKPointAnnotation]) {
        cameraLocations = locations
        addAnnotations(locations)
        for location in locations {
            let region = CLCircularRegion(center: location.coordinate, radius: 100, identifier: "fotocivica@\(location.title!)")
            region.notifyOnEntry = true
            region.notifyOnExit = true
//            locationManager?.startMonitoring(for: region)
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            UserNotificationService.shared.defaultNotificationRequest(id: location.title!, title: "SlowDown!", body: "¡Cuidado, te estas aproximando a una fotocivica!", sound: .default, trigger: trigger)
        }        
    }
    
    func setCompassLayout() {
        let compass = MKCompassButton(mapView: self)
        compass.compassVisibility = .visible
        showsCompass = false
        addSubview(compass)
        compass.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(_width*0.03)
            make.trailing.equalToSuperview().offset(-_width*0.03)
        }
    }
}

extension MapView: CLLocationManagerDelegate {
    //Verificamos la aprovación del monitoreo de la ubicación por parte del usuario
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if currentLocation == nil || cameraLocations.isEmpty { return }
        print("Algo")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: location, span: span)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al intentar obtener la ubicación del usuario!, error message: \(error.localizedDescription)")
    }
}
