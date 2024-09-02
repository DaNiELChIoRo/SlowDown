
import Foundation

struct Camera{
    
    var no: Int?
    var recordId: String?
    var latitude: String?
    var longitude: String?
    var mainStreet: String?
    var sentido: String?
    var secondStreet: String?
    internal var geoShape: GeoShape?
    
    init(no: Int? = nil,
         recordId: String? = nil,
         latitude: String?,
         longitude: String?, mainStreet: String?,
         secondStreet: String? = nil,
         sentido: String? = nil, geoShape: GeoShape? = nil) {

        self.no = no
        self.sentido = sentido
        self.recordId = recordId
        self.latitude = latitude
        self.longitude = longitude
        self.mainStreet = mainStreet
        self.secondStreet = secondStreet
        self.geoShape = geoShape
    }
    
}

class _Camera: NSObject {
    var no: Int?
    var recordId: String?
    var latitude: String?
    var longitude: String?
    var mainStreet: String?
    var secondStreet: String?
}
