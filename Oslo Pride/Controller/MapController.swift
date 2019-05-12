//
//  MapController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let spikersuppa = CLLocationCoordinate2D(latitude: 59.914518, longitude: 10.734388)
    let youngstroget = CLLocationCoordinate2D(latitude: 59.914809, longitude: 10.749099)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        [
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "id")
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.showsTraffic = true
        mapView.showsScale = true
        mapView.showsPointsOfInterest = false
        
        let locationService = Location()
        locationService.askPermission { (success) in
            guard success else { return }
            let location = locationService.getCoordinates()
            let coordinate = CLLocationCoordinate2D(latitude: location.0 ?? 0, longitude: location.1 ?? 0)
            let mapCamera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 10000, pitch: 0, heading: 0)
            self.mapView.setCamera(mapCamera, animated: true)
        }
        
        let osloDowntown = CLLocationCoordinate2D(latitude: 59.913868, longitude: 10.752245)
        let camera = MKMapCamera(lookingAtCenter: osloDowntown, fromDistance: 10000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
        
        
        mapView.addAnnotations([
            PrideAnnotation(title: "Pride Park", lat: spikersuppa.latitude, long: spikersuppa.longitude),
            PrideAnnotation(title: "Pride House & Art", lat: youngstroget.latitude, long: youngstroget.longitude)
            ])
        
        let paradeCoordinates = [
            CLLocationCoordinate2D(latitude: 59.913144, longitude: 10.736491),
            CLLocationCoordinate2D(latitude: 59.913451, longitude: 10.736775),
            CLLocationCoordinate2D(latitude: 59.913793, longitude: 10.735402),
            CLLocationCoordinate2D(latitude: 59.917133, longitude: 10.739152),
            CLLocationCoordinate2D(latitude: 59.917483, longitude: 10.739613),
            CLLocationCoordinate2D(latitude: 59.917947, longitude: 10.740106)
        ]
        let paradePolyLine = MKPolyline(coordinates: paradeCoordinates, count: paradeCoordinates.count)
        
        mapView.addOverlay(paradePolyLine)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = .hotPink
            lineView.lineWidth = 5
            
            
            return lineView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "My Location" { return nil }
        //let view = mapView.dequeueReusableAnnotationView(withIdentifier: "id", for: annotation) as! MKPinAnnotationView
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
        view.image = UIImage(named: "map")
        view.tintColor = .hotPink
        view.canShowCallout = true
        let calloutView = UILabel()
        calloutView.numberOfLines = 0
        calloutView.text = "ehaii \n \n wiii   👸"
        
        
        
        view.detailCalloutAccessoryView = calloutView
        
        return view
    }
    
}


class PrideAnnotation: NSObject, MKAnnotation {
    
    var lat: Double
    var long: Double
    var titleText: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    lazy var title: String? = NSLocalizedString(self.titleText, comment: "PRIDE")
    
    var subtitle: String? = ""
    
    init(title: String, lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        self.titleText = title
        //self.subtitle = ""
    }
    
}
