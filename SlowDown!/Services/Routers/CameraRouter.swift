//
//  CameraRouter.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

enum CameraRouter<T: Codable>: Routable {
    
    typealias R = T
    
    case getAllCameras(T)
    
    var endPoint: String {
        switch self {
        case .getAllCameras( _):
                return "/api/records/1.0/search/"
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        switch  self {
        case .getAllCameras:
            return .get
        }
    }
    var body: T? {
        switch self {
        case .getAllCameras(let data):
            return data
        }
    }
}
