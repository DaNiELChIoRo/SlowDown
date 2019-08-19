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
    
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
    let defaultCenter = CLLocationCoordinate2D(latitude: 19.42452, longitude: -99.23423)
    
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    var cameraLocations = [MKPointAnnotation]()
    var userRegion: MKCoordinateRegion? = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
    
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
            userRegion = region
            setCameraLocation(withLocation: location)            
        } else {
            region = MKCoordinateRegion(center: userCoordinates, span: span)
        }
        showsUserLocation = true
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
            region.notifyOnExit = false
            locationManager?.startMonitoring(for: region)
//            guard let id = location.subtitle else { return }
//            setCameraNotification(withRegion: region, withId: id)
        }
    }
    
    func setCameraNotification(withRegion region: CLCircularRegion, withId id: String) {
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
//        UserNotificationService.shared.removeNotification(identifier: "userNotification.fotocivica."+location.title!)
        UserNotificationService.shared.defaultNotificationRequest(id: id, title: "SlowDown!", body: "¡Cuidado, te estas aproximando a una fotocivica!", sound: .default, trigger: trigger)
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
        if status == .authorizedAlways {
            print("this is going to work!!")
        } else if status == .authorizedWhenInUse {
            print("this is not going to work")
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //        TO-DO: Something that tell us which fotocivica is the one we are entering
        let timestamp = Date().timeIntervalSince1970
        let id = String(timestamp)
        UserNotificationService.shared.defaultNotificationRequest(id: id, title: "SlowDown!", body: "¡Cuidado, te estas aproximando a una fotocivica!", sound: .defaultCritical)
        print("Algo")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: location, span: span)
        if region.center.latitude != userRegion!.center.latitude && region.center.longitude != userRegion!.center.longitude {
            userRegion = region
            createCenterButton()
        }
    }
    
    @objc func centerButtonHandler(_ region: MKCoordinateRegion, _ sender: UIButton) {
        guard let region = userRegion else { return }
        setRegion(region, animated: false)
        for _view in subviews {
            if _view === sender.self {
                _view.removeFromSuperview()
            }
        }
    }
    
    func createCenterButton() {
        print("creating the centering button")
        let centerButton = UIButton()
        centerButton.addTarget(self, action: #selector(centerButtonHandler), for: .touchDown)
        centerButton.backgroundColor = .lightGray
        addSubview(centerButton)
        centerButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-height*0.1)
            make.trailing.equalToSuperview().offset(-_width*0.03)
            make.height.equalTo(_width*0.05)
            make.width.equalTo(_width*0.05)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al intentar obtener la ubicación del usuario!, error message: \(error.localizedDescription)")
    }
}