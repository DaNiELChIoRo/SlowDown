
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
    
    init(no: Int?, recordId: String?, latitude: String?, longitude: String?, mainStreet: String?, secondStreet: String?, sentido: String?, geoShape: GeoShape?) {
        guard let no = no,
            let recordId = recordId,
            let latitude = latitude,
            let sentido = sentido,
            let longitude = longitude,
            let mainStreet = mainStreet,
            let secondStreet = secondStreet else { return }
        
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
