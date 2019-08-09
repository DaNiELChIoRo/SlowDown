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

class MapView: MKMapView  {
    
    var coordinates: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    var cameraLocations = [MKPointAnnotation]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocationServices()
        setupView(nil)
    }
    
    init(annotations: [MKPointAnnotation]) {
        self.init()
        setupLocationServices()
        setupView(annotations)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ annotations: [MKPointAnnotation]?) {
        guard let userCoordinates = locationManager?.location?.coordinate else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: userCoordinates, span: span)
        showsCompass = true
        showsUserLocation = true
        setRegion(region, animated: true)
        showsScale = true
    }
    
    func setupLocationServices() {
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestLocation()
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
        
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        self.coordinates = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al intentar obtener la ubicación del usuario!, error message: \(error.localizedDescription)")
    }
}
