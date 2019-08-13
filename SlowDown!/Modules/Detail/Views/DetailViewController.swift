//
//  DetailViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/13/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController, DetailViewable {

    internal var presenter: DetailPresentable?
    var mainStreetLabel: UILabel?
    var secondaryStreetLabel: UILabel?
    var directionLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(presenter: DetailPresentable) {
        self.presenter = presenter
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        title = "Fotocivica Detalle"
        mainStreetLabel = defaulLabel(text: "calle Principal: ", textAlignment: .left, fontSize: 18)
        
        directionLabel = defaulLabel(text: "sentido: ", textAlignment: .center, fontSize: 18)
        setupLayout(withViews: [mainStreetLabel!, directionLabel!])
    }
    
}

let _height = UIScreen.main.bounds.height
let _width = UIScreen.main.bounds.width
extension DetailViewController {
    
    func setupLayout(withViews views: [UIView]) {
        
        view.addSubviews(views)
        var counter: Int = 0
        for _view in views {
            _view.sizeToFit()
            _view.backgroundColor = .red
            _view.snp.makeConstraints({ (make) in
                if counter == 0 {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
                } else { make.top.equalTo(views[counter-1].snp.bottom).offset(_width*0.03)}
                make.left.equalToSuperview().offset(_width*0.03)
            })
             counter += 1
        }
    }
    
}
