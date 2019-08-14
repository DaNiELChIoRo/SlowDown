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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(barButtonHandler))
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

    @objc func barButtonHandler() {
        presenter.showAll()
    }
    
    @objc func showListButton(action: @escaping () -> Void) {
        
    }
    
    func draw(pins: [Camera]) {
        var annotations:[MKPointAnnotation] = []
        
        pins.forEach { (pin) in
            guard let type = pin.geoShape,
                let lat = Double(pin.longitude!),
                let long = Double(pin.latitude!),
                let subtitle = pin.recordId,
                let title = pin.mainStreet else { return }
            if type.type == "LineString" {
               print("LineString")
            }
            let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                annotation.title = title
                annotation.subtitle = subtitle
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
 
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let identifier = view.annotation?.subtitle!,
            let address = view.annotation?.title!,
            let location = view.annotation?.coordinate else { return }
        print("annotation touched with the address: ", address)
        presenter?.showDetailView(withLocation: location, withIdentifier: identifier)
    }
    
}
