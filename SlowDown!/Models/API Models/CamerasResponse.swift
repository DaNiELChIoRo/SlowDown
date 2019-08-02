//
//  Camera.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

struct GeoShape: Codable {
    var type: String
    var coordinates: [Double]?
    var coordinatesLine: [[Double]]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        if type == "LineString" {
            coordinatesLine = try values.decode([[Double]].self, forKey: .coordinates)
        } else {
            coordinates = try values.decode([Double].self, forKey: .coordinates)
        }
        
    }
}


struct Fields: Codable {
    var no: String
    var geoShape: GeoShape
    var geoPoint2D: [Double]
    var sentido: String
    var longitude: String?
    var latitude: String?
    var mainStreet: String
    var secondStreet: String
    var ubi: String
    
    enum CodingKeys: String, CodingKey {
        case no
        case geoShape = "geo_shape"
        case geoPoint2D = "geo_point_2d"
        case sentido
        case longitude = "y"
        case latitude = "x"
        case mainStreet = "ubicacion"
        case secondStreet = "via_princi"
        case ubi
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        no = try values.decode(String.self, forKey: .no)
        geoShape = try values.decode(GeoShape.self, forKey: .geoShape)
        geoPoint2D = try values.decode([Double].self, forKey: .geoPoint2D)
        sentido = try values.decode(String.self, forKey: .sentido)
        if geoShape.type != "LineString" {
            longitude = try values.decode(String.self, forKey: .longitude)
            latitude = try values.decode(String.self, forKey: .latitude)
        }
        mainStreet = try values.decode(String.self, forKey: .mainStreet)
        secondStreet = try values.decode(String.self, forKey: .secondStreet)
        ubi = try values.decode(String.self, forKey: .ubi)
    }
}

struct CameraResponse: Codable {
    var datasetid: String
    var recordid: String
    var fields: Fields
    var recordTimeStamp: String
    
    enum CodingKeys: String, CodingKey {
        case datasetid
        case recordid
        case fields
        case recordTimeStamp = "record_timestamp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        datasetid = try values.decode(String.self, forKey: .datasetid)
        recordid = try values.decode(String.self, forKey: .recordid)
        fields = try values.decode(Fields.self, forKey: .fields)
        recordTimeStamp = try values.decode(String.self, forKey: .recordTimeStamp)
    }
}
