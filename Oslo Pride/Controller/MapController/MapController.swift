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
    
    let segmentController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Oversikt", "Detaljer", "Alle Eventer"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .prideRed
        segmentedControl.backgroundColor = .white
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
            ], for: .normal)
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "id")
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.showsScale = true
        mapView.showsPointsOfInterest = false
        mapView.isPitchEnabled = false

        return mapView
    }()
    
    let spikersuppa = CLLocationCoordinate2D(latitude: 59.914518, longitude: 10.734388)
    let youngstroget = CLLocationCoordinate2D(latitude: 59.914809, longitude: 10.749099)
    
    // MARK:- Distance View Annotations
    let prideParkAnnotation = PrideAnnotation(title: nil, lat: 59.914252, long: 10.735609)
    let prideHouseArtAnnotaion = PrideAnnotation(title: nil, lat: 59.914809, long: 10.749099)
    let prideParadeStartAnnotation = PrideAnnotation(title: nil, lat: 59.911959, long: 10.766269)
    let prideParadeEndAnnotation = PrideAnnotation(title: nil, lat: 59.913132, long: 10.738024)

    // MARK: Toilet annotations
    let prideParkToiletAnnotation = PrideToiletAnnotation(title: "Toalett", lat: 59.913728, long: 10.738393)
    let prideParkEurozoneToiletAnnotation = PrideToiletAnnotation(title: "Toalett", lat: 59.914026, long: 10.737402)
    let prideParkSOProdeToiletAnnotation = PrideToiletAnnotation(title: "Toalett", lat: 59.913982, long: 10.735818)
    let prideParkBamseToiletAnnotation = PrideToiletAnnotation(title: "Toalett", lat: 59.913933, long: 10.735702)
    let parkPrideUngToiletAnnotation = PrideToiletAnnotation(title: "Toalett", lat: 59.913643, long: 10.738309)

    let parkMainBarAnnotation = PrideAnnotation(title: "Hovedbar", lat: 59.913860, long: 10.735983)
    let parkPrideBarAnnotation = PrideAnnotation(title: "Pridebar", lat: 59.913486, long: 10.737819)
    let parkEurozoneAnnotation = PrideAnnotation(title: "Eurozone", lat: 59.913712, long: 10.737478)
    let parkTorgetAnnotation = PrideAnnotation(title: "Torget", lat: 59.913586, long: 10.738022)
    var parkInfoAnnotation = PrideAnnotation(title: "Info", lat: 59.914009, long: 10.737251)
    let parkKlubbenAnnotation = PrideAnnotation(title: "Klubben", lat: 59.913582, long: 10.737115)
    
    // MARK: Scene annotations
    let mainStageAnnotation = PrideAnnotation(title: "Hovedscenen", lat: 59.914009, long: 10.736598)
    let bamseStageAnnotation = PrideAnnotation(title: "Bamsescenen", lat: 59.913822, long: 10.735478)
    
    var paradePolyLine: MKPolyline!
    var parkPolygon: MKPolygon!
    var waterparkLargePloygon: MKPolygon!
    var waterparkSmallPloygon: MKPolygon!
    
    // MARK: Forest ploygons
    var parkPrideBarForestPolygon: MKPolygon!
    var parkPrideUngForestPolygon: MKPolygon!
    var parkStandgateStortingetForestPolygon: MKPolygon!
    var parkStandgateSlottetForestPolygon: MKPolygon!
    var parkMainsceneSlottetForest: MKPolygon!
    var parkEurozonePolygon: MKPolygon!
    
    var parkMainBarPolygon: MKPolygon!
    var parkPrideBarPolygon: MKPolygon!
    var parkKlubbenPolygon: MKPolygon!
    
    var closeViewAnnotations: [MKAnnotation]!
    var distanceViewAnnotations: [MKAnnotation]!
    
    var previousAltitude: CLLocationDistance = 10000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAnnotations()
        setupPolygons()
        setupDistanceView()
        
        let osloDowntown = CLLocationCoordinate2D(latitude: 59.913868, longitude: 10.752245)
        let camera = MKMapCamera(lookingAtCenter: osloDowntown, fromDistance: 10000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
        
        //let locationService = Location()
        Location.shared.askPermission { (success) in
            //guard success else { return }
            print("Got Permission: ", success)
            //            let location = locationService.getCoordinates()
            //            let coordinate = CLLocationCoordinate2D(latitude: location.0 ?? 0, longitude: location.1 ?? 0)
            //            let mapCamera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 10000, pitch: 0, heading: 0)
        }
        
    }
    
    @objc fileprivate func handleSegmentChange() {
        mapView.removeAnnotations([
            prideHouseArtAnnotaion,
            prideParkAnnotation,
            prideParadeStartAnnotation,
            prideParadeEndAnnotation,
            
            prideParkToiletAnnotation
        ])
        switch segmentController.selectedSegmentIndex {
        case 0:
            setupDistanceView()
        case 1:
            setupCloseView()
        default:
            break
        }
    }
    
    
}

// MARK:- Map Delegate
extension MapController {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let threshold: CLLocationDistance = 2500 // in meter
        
        // Map did zoom to less than 2km
        if previousAltitude > threshold && mapView.camera.altitude < threshold {
            setupCloseView()
        }
            
            // Map did zoom out of 2km
        else if previousAltitude < threshold && mapView.camera.altitude > threshold {
            setupDistanceView()
        }
        
        previousAltitude = mapView.camera.altitude
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
            calloutView.mapURL = URL(string:"http://maps.apple.com/?address=Karl+Johans+gate+24")
            calloutView.titleLabel.attributedText = attrText
            view.detailCalloutAccessoryView = calloutView
            
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
            calloutView.mapURL = URL(string:"http://maps.apple.com/?address=youngstorget")
            calloutView.titleLabel.attributedText = attrText
            view.detailCalloutAccessoryView = calloutView

        } else if annotation == prideParadeStartAnnotation {
            let img = UIImage(named: "trip")?.withRenderingMode(.alwaysTemplate)
            view.image = img
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string: "Parade Start\n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.prideRed
                ]))
            attrText.append(NSAttributedString(string: "Lørdag 22. juni", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
            calloutView.titleLabel.attributedText = attrText
            calloutView.mapURL = URL(string:"http://maps.apple.com/?address=Gronlandsleiret+Platous+Gate+25")
            view.detailCalloutAccessoryView = calloutView

        } else if annotation == prideParadeEndAnnotation {
            let img = UIImage(named: "trip")?.withRenderingMode(.alwaysTemplate)
            view.image = img
            
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string: "Parade Slutt\n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.prideRed
                ]))
            attrText.append(NSAttributedString(string: "Lørdag 22. juni", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
            
            calloutView.titleLabel.attributedText = attrText
            calloutView.mapURL = URL(string:"http://maps.apple.com/?address=Karl+Johans+gate+24")
            view.detailCalloutAccessoryView = calloutView

        } else if annotation is PrideToiletAnnotation {
            let img = UIImage(named: "toilet")?.withRenderingMode(.alwaysOriginal)
            view.image = img
        } else if annotation == mainStageAnnotation || annotation == bamseStageAnnotation {
            let img = UIImage(named: "scene")?.withRenderingMode(.alwaysOriginal)
            view.image = img
            
            let lbl = UILabel(frame: CGRect(x: -view.frame.width*2, y: 10, width: 100, height: 30))
            lbl.textAlignment = .center
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = UIColor(red:0.91, green:0.20, blue:0.54, alpha:1.0)
            lbl.text = annotation.title ?? ""
            view.addSubview(lbl)
        } else if annotation == parkMainBarAnnotation || annotation == parkPrideBarAnnotation {
            let img = UIImage(named: "beer")?.withRenderingMode(.alwaysOriginal)
            view.image = img
            
            let lbl = UILabel(frame: CGRect(x: -view.frame.width*2, y: 10, width: 100, height: 30))
            lbl.textAlignment = .center
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = UIColor(red:0.24, green:0.16, blue:0.47, alpha:1.0)
            lbl.text = annotation.title ?? ""//"Hoved scene"
            view.addSubview(lbl)
            view.detailCalloutAccessoryView = BeerCalloutView()

        } else if annotation == parkTorgetAnnotation {
            let img = UIImage(named: "ute_servering")?.withRenderingMode(.alwaysOriginal)
            view.image = img
            
            let lbl = UILabel(frame: CGRect(x: -view.frame.width*2, y: 10, width: 100, height: 30))
            lbl.textAlignment = .center
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = UIColor(red:0.95, green:0.55, blue:0.36, alpha:1.0)
            lbl.text = annotation.title ?? ""
            view.addSubview(lbl)
            view.detailCalloutAccessoryView = BeerCalloutView()
            
        } else if annotation == parkInfoAnnotation {
            let img = UIImage(named: "info-1")?.withRenderingMode(.alwaysOriginal)
            view.image = img
        } else if annotation == parkEurozoneAnnotation {
            let img = UIImage(named: "music")?.withRenderingMode(.alwaysOriginal)
            view.image = img
            
            let lbl = UILabel(frame: CGRect(x: -view.frame.width*2, y: 10, width: 100, height: 30))
            lbl.textAlignment = .center
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = UIColor(red:0.91, green:0.20, blue:0.54, alpha:1.0)
            lbl.text = annotation.title ?? ""//"Hoved scene"
            view.addSubview(lbl)
        } else if annotation == parkKlubbenAnnotation {
            let img = UIImage(named: "beer")?.withRenderingMode(.alwaysOriginal)
            view.image = img
            
            let lbl = UILabel(frame: CGRect(x: -view.frame.width*2, y: 10, width: 100, height: 30))
            lbl.textAlignment = .center
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = .prideDeepPurple //UIColor(red:0.91, green:0.20, blue:0.54, alpha:1.0)
            lbl.text = annotation.title ?? ""
            view.addSubview(lbl)

            view.detailCalloutAccessoryView = BeerCalloutView()
            
        }
        
        //view.detailCalloutAccessoryView = calloutView
        
        return view
    }
}

// MARK:- Setup
extension MapController {
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        [
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        
//        view.addSubview(segmentController)
//        [
//            segmentController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
//            segmentController.heightAnchor.constraint(equalToConstant: 44)
//            ].forEach { $0.isActive = true }
        
    }
    
    fileprivate func setupPolygons() {
        let coordinates = MapCoordinates()
        paradePolyLine = MKPolyline(coordinates: coordinates.paradeCoordinates, count: coordinates.paradeCoordinates.count)
        parkPolygon = MKPolygon(coordinates: coordinates.parkCoordinates, count: coordinates.parkCoordinates.count)
        waterparkLargePloygon = MKPolygon(coordinates: coordinates.spikersuppaWaterFountainLargeCoordinates, count: coordinates.spikersuppaWaterFountainLargeCoordinates.count)
        waterparkSmallPloygon = MKPolygon(coordinates: coordinates.spikersuppaWaterFountainSmallCoordinates, count: coordinates.spikersuppaWaterFountainSmallCoordinates.count)
        parkMainBarPolygon = MKPolygon(coordinates: coordinates.parkMainBarCoordinates, count: coordinates.parkMainBarCoordinates.count)
        parkPrideBarPolygon = MKPolygon(coordinates: coordinates.parkPrideBarCoordinates, count: coordinates.parkPrideBarCoordinates.count)
        
        parkPrideBarForestPolygon = ForestPolygon(coordinates: coordinates.spikersuppaPrideBarForestCoordinates, count: coordinates.spikersuppaPrideBarForestCoordinates.count)
        parkPrideUngForestPolygon = ForestPolygon(coordinates: coordinates.parkPrideUngForest, count: coordinates.parkPrideUngForest.count)
        parkStandgateStortingetForestPolygon = ForestPolygon(coordinates: coordinates.parkStandgateStortingetForest, count: coordinates.parkStandgateStortingetForest.count)
        parkStandgateSlottetForestPolygon = ForestPolygon(coordinates: coordinates.parkStandgateSlottetForest, count: coordinates.parkStandgateSlottetForest.count)
        parkMainsceneSlottetForest = ForestPolygon(coordinates: coordinates.parkMainsceneSlottetForest, count: coordinates.parkMainsceneSlottetForest.count)
        parkEurozonePolygon = PrideTentPolygon(coordinates: coordinates.parkEurozone, count: coordinates.parkEurozone.count)
        parkKlubbenPolygon = PrideTentPolygon(coordinates: coordinates.klubben, count: coordinates.klubben.count)
        
        mapView.addOverlays([
            parkPolygon,
            
            parkMainBarPolygon,
            parkPrideBarPolygon,
            
            parkPrideBarForestPolygon,
            parkPrideUngForestPolygon,
            parkStandgateStortingetForestPolygon,
            parkStandgateSlottetForestPolygon,
            parkMainsceneSlottetForest,
            
            paradePolyLine,
            
            waterparkLargePloygon,
            waterparkSmallPloygon,
            
            parkEurozonePolygon,
            parkKlubbenPolygon,
            
            
            ])
    }
    
    fileprivate func setupAnnotations() {
        closeViewAnnotations = [
            prideParkBamseToiletAnnotation,
            parkPrideUngToiletAnnotation,
            parkEurozoneAnnotation,
            
            parkMainBarAnnotation,
            mainStageAnnotation,
            bamseStageAnnotation,
            parkTorgetAnnotation,
            parkPrideBarAnnotation,
            parkInfoAnnotation,
            parkKlubbenAnnotation,

        ]
        
        distanceViewAnnotations = [
            prideHouseArtAnnotaion,
            prideParkAnnotation,
            prideParadeStartAnnotation,
            prideParadeEndAnnotation,
        ]
    }
    
    fileprivate func setupCloseView() {
        mapView.removeAnnotations(distanceViewAnnotations)
        mapView.addAnnotations(closeViewAnnotations)
    }
    
    fileprivate func setupDistanceView() {
        mapView.removeAnnotations(closeViewAnnotations)
        mapView.addAnnotations(distanceViewAnnotations)
    }
    
}

