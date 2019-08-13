//
//  HomeViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class HomeViewController: UIViewController, HomeViewable {
    
    private var presenter: HomePresentable!
    private var mapView: MapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //TODO - visual config
    func setup(presenter: HomePresentable) {

        title = "SlowDown!"
        self.presenter = presenter
        view.backgroundColor =  .white
        
        let text = UILabel()
        text.backgroundColor = .blue
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.sizeToFit()
        text.text = "Texto de Prueba"

        self.mapView = MapView()
        self.mapView?.delegate = self
        setupLayout()
        
        self.presenter.fetchCameras()
    }
    
    func showListButton(action: @escaping () -> Void) {
        
    }
    
    func draw(pins: [Camera]) {
        let camera = pins[0]
        camer
        var annotations:[MKPointAnnotation] = []
        pins.forEach { (pin) in
            guard let lat = Double(pin.longitude!),
                let long = Double(pin.latitude!),
                let title = pin.mainStreet else { return }
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            annotation.title = title
            annotations.append(annotation)
        }        
        self.mapView?.setCameraLocations(annotations)
    }

}

let height = UIScreen.main.bounds.height

extension HomeViewController {
    
    func setupLayout() {
        
        view.addSubviews([mapView!])
        mapView!.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPinTapHandler))
            annotationView?.addGestureRecognizer(tapGesture)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc func onPinTapHandler() {
        print("on tap pin gesture handler")
    }
    
}
