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
        view.backgroundColor = .red
    }

    // MARK: Layout Configuration
    private func setupDropDown() {

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

        self.mapView = MapView(presenter: presenter as! MapViewPresentable)
        self.mapView?.delegate = (presenter as! MKMapViewDelegate)
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
        self.mapView?.setupMapViewForCameraLocations(annotations)
    }
    
    func promptLocationUsageRequirement() {
        let alertController = UIAlertController (title: "Advertencia", message: "Actualmente no cuenta con los servicios de monitoreo activados, los cuales son necesarios para el correcto funcionamiento de la aplicación. Sí desea hacer uso de esta, por favor vaya a las configuraciones y cambie los privilegios a 'Siempre'", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showMapCenterButton() {
        mapView?.changeCenterButtonTintColor()
    }
    
    func mapViewChangeCenterButtonToActive() {
        mapView?.changeCenterButtonTintColor()
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
