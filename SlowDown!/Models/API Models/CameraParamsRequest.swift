//
//  CameraParamsRequest.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

struct CameraParamsRequest: Codable {
    var dataSet: String
    var rows: String
    var latitude: Double
    var longuitude: Double
    
    enum CodingKeys: String, CodingKey {
        case dataSet = "dataset"
        case rows
        case latitude
        case longuitude
    }
    
    func encode(to enconder: Encoder) throws {
        var container = enconder.container(keyedBy: CodingKeys.self)
        try container.encode(dataSet, forKey: .dataSet)
        try container.encode(rows, forKey: .rows)
    }
}
