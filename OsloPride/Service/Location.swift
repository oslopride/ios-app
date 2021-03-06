import CoreLocation
import Foundation

class Location: NSObject {
    static let shared = Location()
    fileprivate var location: CLLocation?
    
    fileprivate let manager = CLLocationManager()
    
    /// Returns (Latitude, Longitude)
    func getCoordinates() -> (Double?, Double?) {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            location = manager.location
        }
        return (location?.coordinate.latitude, location?.coordinate.longitude)
    }
    
    var permissionHandler: ((Bool) -> ())?
    func askPermission(handler: @escaping (Bool) -> ()) {
        manager.delegate = self
        permissionHandler = handler
        manager.requestAlwaysAuthorization()
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            permissionHandler?(true)
        } else {
            // permissionHandler?(false)
        }
    }
}
