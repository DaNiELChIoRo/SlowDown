//
//  HomeViewController.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewable {
    
    private var presenter: HomePresentable!
    
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
        
        setupLayout(_view: text)
        self.presenter.fetchCameras()
 
    }
    
    func showListButton(action: @escaping () -> Void) {
        
    }
    
    func draw(pins: String) {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController {
    
    func setupLayout(_view: UIView) {
        view.addSubview(_view)
        view.addConstraints([
            _view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            _view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            _view.heightAnchor.constraint(equalToConstant: 200),
//            _view.widthAnchor.constraint(equalToConstant: 100)
            ])
    }
    
}
