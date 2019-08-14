//
//  DetailViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class DetailViewController: UIViewController, DetailViewable {

    internal var presenter: DetailPresentable?
    var mapView: MapView?
    var mainStreetLabel: UILabel?
    var secondaryStreetLabel: UILabel?
    var directionLabel: UILabel?
    var mainStreet: String = ""
    var secondaryStreet: String = ""
    var direction: String = ""
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(withLocation location: CLLocationCoordinate2D, andCamera camera: Camera) {
        super.init(nibName: nil, bundle: nil)
        self.location = location
        guard let mainStreet = camera.mainStreet,
            let sentido = camera.sentido,
            let secondaryStreet = camera.secondStreet  else { return }
        self.mainStreet = mainStreet
        self.secondaryStreet = secondaryStreet
        self.direction = sentido
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(presenter: DetailPresentable) {
        self.presenter = presenter
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        title = "Fotocivica Detalle"
        mapView = MapView(withLocation: location!)
        mainStreetLabel = defaulLabel(text: "Ubicación: " + mainStreet, textAlignment: .left, fontSize: 18)
        secondaryStreetLabel = defaulLabel(text: "Vía principal: " + secondaryStreet, textAlignment: .left, fontSize: 18)
        directionLabel = defaulLabel(text: "sentido del la vía: " + direction, textAlignment: .left, fontSize: 18)
        setupLayout(withViews: [mapView!, mainStreetLabel!, secondaryStreetLabel!, directionLabel!])
    }
    
}

let _width = UIScreen.main.bounds.width
extension DetailViewController {
    
    func setupLayout(withViews views: [UIView]) {
        view.addSubviews(views)
        mapView!.layer.cornerRadius = 6
        var counter: Int = 0
        for _view in views {
            _view.sizeToFit()
//            _view.backgroundColor = .red
            _view.snp.makeConstraints({ (make) in
                if counter == 0 {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(_width*0.03)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(_width*0.95)
                    make.height.equalTo(height*0.4)
                } else {
                    make.top.equalTo(views[counter-1].snp.bottom).offset(_width*0.03)}
                    make.left.equalToSuperview().offset(_width*0.03)
                    make.right.equalToSuperview().offset(-_width*0.03)
            })
             counter += 1
        }
    }
    
}
