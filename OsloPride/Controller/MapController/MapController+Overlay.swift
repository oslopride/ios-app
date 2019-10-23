//
//  MapController+Overlay.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 21/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import MapKit
import UIKit

extension MapController {
    
    func addOverlay() {
        let park = PridePark(topLeft: CLLocationCoordinate2D(latitude: 59.914529, longitude: 10.736252),
                  topRight: CLLocationCoordinate2D(latitude: 59.9138, longitude: 10.7388),
                  botLeft: CLLocationCoordinate2D(latitude: 59.9138, longitude: 10.7354),
                  botRight: CLLocationCoordinate2D(latitude: 59.9131, longitude: 10.7381))
        
        let prideParkOverlay = ParkMapOverlay(park: park)
        mapView.addOverlay(prideParkOverlay)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolygon {
            if overlay == waterparkLargePloygon || overlay == waterparkSmallPloygon {
                let polygon = MKPolygonRenderer(overlay: overlay)
                polygon.fillColor = UIColor(red:0.68, green:0.89, blue:0.96, alpha:1.00) //UIColor(red:0.65, green:0.76, blue:0.91, alpha:1.0)
                polygon.lineWidth = 1
                polygon.strokeColor = UIColor(red:0.52, green:0.73, blue:0.80, alpha:1.00) //UIColor(red:0.12, green:0.33, blue:0.64, alpha:1.0)
                polygon.alpha = 1
                return polygon
            } else if overlay == parkMainBarPolygon || overlay == parkPrideBarPolygon {
                let polygon = MKPolygonRenderer(overlay: overlay)
                polygon.fillColor =  UIColor(red:0.85, green:0.83, blue:0.80, alpha:1.00)
                polygon.lineWidth = 1
        //polygon.strokeColor = .white
                polygon.alpha = 1
             
                return polygon
            } else if overlay is ForestPolygon {
                let polygon = MKPolygonRenderer(overlay: overlay)
                polygon.fillColor = .mapForestGreen
                polygon.lineWidth = 1
                polygon.strokeColor = UIColor(red:0.33, green:0.72, blue:0.38, alpha:1.00)
                polygon.alpha = 1
                return polygon
            } else if overlay is PrideTentPolygon {
                let polygon = MKPolygonRenderer(overlay: overlay)
                polygon.fillColor = UIColor(red:0.85, green:0.83, blue:0.80, alpha:1.00)
                polygon.lineWidth = 1
                //polygon.strokeColor = .white
                polygon.alpha = 1
                
                return polygon
            }
        }
        
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = .prideRed
            lineView.lineWidth = 4
            return lineView
        } else if overlay is MKPolygon {
            let polygon = MKPolygonRenderer(overlay: overlay)
            polygon.fillColor = .appleMapGreen
            polygon.lineWidth = 0
            //polygon.strokeColor = .prideGreen
            polygon.alpha = 1
            return polygon
        } else if overlay is ParkMapOverlay {
            return ParkMapOverlayView(overlay: overlay, image: UIImage(named: "kart")!)
        }
        
        return MKOverlayRenderer()
    }
    
}

class PridePark {
    var name: String?
    var boundary: [CLLocationCoordinate2D] = []
    
    var midCoordinate = CLLocationCoordinate2D(latitude: 59.913795, longitude: 10.737127)
//    var overlayTopLeftCoordinate: CLLocationCoordinate2D
//    var overlayTopRightCoordinate: CLLocationCoordinate2D
//    var overlayBottomLeftCoordinate: CLLocationCoordinate2D
//    var overlayBottomRightCoordinate: CLLocationCoordinate2D
    var overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: 59.9131, longitude: 10.7381)
    var overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: 59.913775, longitude: 10.738821)
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: 59.913783, longitude: 10.735412)
    var overlayBottomRightCoordinate = CLLocationCoordinate2D(latitude: 59.913121, longitude: 10.738052)
    
    var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeftPoint = MKMapPoint(overlayTopLeftCoordinate)
            let topRightPoint = MKMapPoint(overlayTopRightCoordinate)
            let bottomLeftPoint = MKMapPoint(overlayBottomLeftCoordinate)
            
            return MKMapRect(x: topLeftPoint.x,
                             y: topLeftPoint.y,
                             width: fabs(topLeftPoint.x - topRightPoint.x),
                             height: fabs(topLeftPoint.y - bottomLeftPoint.y))
        }
    }
    
    init(topLeft: CLLocationCoordinate2D, topRight: CLLocationCoordinate2D, botLeft: CLLocationCoordinate2D, botRight: CLLocationCoordinate2D) {
//        self.overlayTopLeftCoordinate = topLeft
//        self.overlayTopRightCoordinate = topRight
//        self.overlayBottomLeftCoordinate = botLeft
//        self.overlayBottomRightCoordinate = botRight
//
        //self.midCoordinate = CLLocationCoordinate2D(latitude: 59.913795, longitude: 10.737127)
    }
    
}

class ParkMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(park: PridePark) {
        self.coordinate = park.midCoordinate
        self.boundingMapRect = park.overlayBoundingMapRect
    }
    
}

class ParkMapOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    init(overlay: MKOverlay, image: UIImage) {
        self.overlayImage = image
        super.init(overlay: overlay)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let cgImage = overlayImage.cgImage else { return }

        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(cgImage, in: rect)

    }
    
}
