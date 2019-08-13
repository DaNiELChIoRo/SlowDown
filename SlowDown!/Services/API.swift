//
//  API.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import UIKit
import CoreLocation

class API {
    
    var network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func fetchAllCameras<R:Decodable>(dataSet: String, rows: Int = 140, location: WGS84, competitionHandler: @escaping (Result<R>) -> Void ) {
        let cameraParams = CameraParamsRequest(dataSet: dataSet, rows: String(rows), geofilter: "\(location.latitude)%2C\(location.longuitude)%2C\(location.distance)")
        network.request(router: CameraRouter.getAllCameras(cameraParams)) { (result: Result<R>) in
            competitionHandler(result)
        }
//        network.request(router: CameraRouter<Camera>.getAllCameras(dataset: dataSet, rows: rows)) { (result: Result<R>) in
//            competitionHandler(result)
//        }
//        network.request(router: CameraRouter.getAllCameras(cameraParams)) { (result: Result<R>) in
//            competitionHandler(result)
//        }
    }
    
}
