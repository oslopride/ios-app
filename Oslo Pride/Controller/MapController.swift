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
    
    let prideParkAnnotation = PrideAnnotation(title: "Pride Park", lat: 59.914518, long: 10.734388)
    let prideHouseArtAnnotaion = PrideAnnotation(title: "Pride House & Art", lat: 59.914809, long: 10.749099)

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
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.showsScale = true
        mapView.showsPointsOfInterest = false
        
        let locationService = Location()
        locationService.askPermission { (success) in
            guard success else { return }
            let location = locationService.getCoordinates()
            let coordinate = CLLocationCoordinate2D(latitude: location.0 ?? 0, longitude: location.1 ?? 0)
            let mapCamera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 10000, pitch: 0, heading: 0)
            //self.mapView.setCamera(mapCamera, animated: true)
        }
        
        let osloDowntown = CLLocationCoordinate2D(latitude: 59.913868, longitude: 10.752245)
        let camera = MKMapCamera(lookingAtCenter: osloDowntown, fromDistance: 10000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
        
        
        mapView.addAnnotations([
            prideHouseArtAnnotaion,
            prideParkAnnotation
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
            lineView.strokeColor = .prideRed
            lineView.lineWidth = 5
            return lineView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PrideAnnotation else { return nil }
        //let view = mapView.dequeueReusableAnnotationView(withIdentifier: "id", for: annotation) as! MKPinAnnotationView
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
        
        
        view.tintColor = .hotPink
        view.canShowCallout = true
        let calloutView = AnnotationCalloutView()
        
        
        
        if annotation == prideParkAnnotation {
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string: "Pride Park\n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.prideGreen
                ]))
            
            attrText.append(NSAttributedString(string: "Onsdag 19. juni til lørdag 22. juni", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
            let img = UIImage(named: "pridepark")
            view.image = img

            calloutView.titleLabel.attributedText = attrText
        } else if annotation == prideHouseArtAnnotaion {
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string: "Pride House\n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.prideBlue
                ]))
            attrText.append(NSAttributedString(string: "Lørdag 15. juni til fredag 21. juni\n\n", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
            
            attrText.append(NSAttributedString(string: "Pride Art\n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.pridePurple
                ]))
            attrText.append(NSAttributedString(string: "Fredag 14. juni til søndag 23. juni", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
            
            let img = UIImage(named: "pride_art")
            view.image = img
            view.contentScaleFactor = 0
            
            calloutView.titleLabel.attributedText = attrText
        }
        
        view.detailCalloutAccessoryView = calloutView
        
        return view
    }
    
}


class AnnotationCalloutView: UIView {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 3),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -3)
            ].forEach { $0.isActive = true }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class PrideAnnotation: NSObject, MKAnnotation {
    
    var lat: Double
    var long: Double
    var titleText: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    //lazy var title: String? = NSLocalizedString(self.titleText, comment: "PRIDE")
    
    var subtitle: String? = ""
    
    init(title: String, lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        self.titleText = title
        //self.subtitle = ""
    }
    
}
