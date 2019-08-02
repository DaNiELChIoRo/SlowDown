//
//  HomePresenter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit

class HomePresenter {
    
    private var api: API
    private var view: HomeViewable?
    
    init(api: API) {
        self.api = api
    }
    
    
    
    func dommyRequest() {
        api.fetchAllCameras(dataSet: "fotocivicas") { (result: Result<[CameraResponse]>) in
            switch result {
            case .success(let data):
                print(data)
                var cameras = [Camera]()
                for dat in data {
                    let datos = dat.fields
                    let camera = Camera(no: Int(datos.no), recordId: dat.recordid , latitude: datos.latitude, longitude: datos.longitude, mainStreet: datos.mainStreet, secondStreet: datos.secondStreet)
                    print("camera", camera)
                    cameras.append(camera)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // TODO - tell the coordinator to send us to the view
    private func showListButtonHandler() {
        
    }
    
}

extension HomePresenter: HomePresentable {
    
    func fetchCameras() {
         dommyRequest()
    }
    
    func showAll() {
        
    }
    
    func attach(view: HomeViewable) {
        self.view = view
        self.view?.setup(presenter: self as HomePresentable)
        //        self.view?.showListButton {
        //
        //        }       
    }
}
