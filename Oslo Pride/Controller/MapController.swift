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
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "My Location" { return nil }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "id", for: annotation) as! MKPinAnnotationView
        
        view.canShowCallout = true
        return view
    }
    
}
