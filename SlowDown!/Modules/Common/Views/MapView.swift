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
    
    var presenter: MapViewPresentable!
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    var cameraLocations = [MKPointAnnotation]()
    var userRegion: MKCoordinateRegion?
    var allRegions : [CLRegion] = [] // Fill all your regions
    var centerButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocationServices()
        setupView(nil)
    }
    
    convenience init(presenter: MapViewPresentable) {
        self.init()
        self.presenter = presenter
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
            allRegions.append(region)
        }
        cleanAllMonitoredRegions()
        guard let location = userLocation.location else { return }
        monitorUserCurrentRegion(inRegion: location.coordinate)
//        evaluateClosestLocations(for: location)
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

extension MapView {
    func monitorUserCurrentRegion(inRegion center: CLLocationCoordinate2D) {
//        print("creating a new user monitored region")
        let _region = CLCircularRegion(center: center, radius: 500, identifier: "userLocationRegion")
        _region.notifyOnEntry = false
        _region.notifyOnExit = true
        locationManager?.startMonitoring(for: _region)
    }
    
    func cleanAllMonitoredRegions() {
//        print("clearin all the monitored Regions!")
        guard let monitoredRegions = locationManager?.monitoredRegions else { print("no monitored regions!"); return }
        for _region in monitoredRegions {
            locationManager?.stopMonitoring(for: _region)
        }
    }
    
    func isUserRegionMonitored() -> Bool {
        guard let monitoredRegions = locationManager?.monitoredRegions else { return false }
        for region in monitoredRegions {
            if region.identifier == "userLocationRegion" {
                return true
            }
        }
        return false
    }
    
    func evaluateClosestLocations(for location: CLLocation) {
        print("evaluateClosestRegions")
        var allDistance : [Double] = []
        //Calulate distance of each region's center to currentLocation
        for region in allRegions {
            let circularRegion = region as! CLCircularRegion
            let distance = location.distance(from: CLLocation(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude))
            allDistance.append(distance)
        }
        // a Array of Tuples
        let distanceOfEachRegionToCurrentLocation = zip(allRegions, allDistance)
        //sort and get 20 closest
        let twentyNearbyRegions = distanceOfEachRegionToCurrentLocation
            .sorted{ tuple1, tuple2 in return tuple1.1 < tuple2.1 }
            .prefix(19)
        
        // Remove all regions you were tracking before
        for region in locationManager!.monitoredRegions {
//            print("Monitored region about to be erase ", region)
            locationManager!.stopMonitoring(for: region)
        }
        
        twentyNearbyRegions.forEach {
            locationManager?.startMonitoring(for: $0.0)
        }
    }
}

extension MapView: CLLocationManagerDelegate {
    //Verificamos la aprovación del monitoreo de la ubicación por parte del usuario
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways {
            presenter?.onPermissionDenied()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region.identifier != "userLocationRegion" else { return }
        let timestamp = Date().timeIntervalSince1970
        let id = String(timestamp)
        UserNotificationService.shared.defaultNotificationRequest(id: id, title: "SlowDown!", body: "¡Cuidado, te estas aproximando a una fotocivica!", sound: .defaultCritical)
        print("Algo")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region.identifier == "userLocationRegion"  else { return }
        print("the user has exit the userLocationRegion!")
        cleanAllMonitoredRegions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation : CLLocation? {
            didSet{
                evaluateClosestRegions()
            }
        }

        guard let location = locations.first?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: location, span: span)
        userRegion = region
//        setRegion(region, animated: false)
        if !isUserRegionMonitored() {
            currentLocation = locations.first
            monitorUserCurrentRegion(inRegion: location)
        }
        
        func evaluateClosestRegions() {
            print("calculating the new camaras for user!!")
            evaluateClosestLocations(for: currentLocation!)
        }
        
    }
    
    func eliminateCenterButton(_ sender: NSObject) {
        for _view in subviews {
            if _view === sender.self {
                print("destoying the centering button")
                _view.removeFromSuperview()
            }
        }
    }
    
    @objc func centerButtonHandler(_ region: MKCoordinateRegion, _ sender: UIButton) {
        guard let region = userRegion else { return }
        setRegion(region, animated: false)
        centerButton = nil
        eliminateCenterButton(sender)
    }
    
    func createCenterButton() {
//        print("creating the centering button")
        centerButton = UIButton()
        centerButton?.setImage(UIImage(named: "location"), for: .normal)
        centerButton?.addTarget(self, action: #selector(centerButtonHandler), for: .touchDown)
        centerButton?.backgroundColor = .lightGray
        centerButton?.layer.cornerRadius = 8
        addSubview(centerButton!)
        centerButton!.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-height*0.1)
            make.trailing.equalToSuperview().offset(-_width*0.03)
            make.height.equalTo(_width*0.1)
            make.width.equalTo(_width*0.1)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al intentar obtener la ubicación del usuario!, error message: \(error.localizedDescription)")
        self.delegate?.mapView?(self, didFailToLocateUserWithError: error)
    }
}
