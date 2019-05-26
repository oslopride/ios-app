//
//  Annotation.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 26/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import MapKit

class AnnotationCalloutView: UIView {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
        
    }()
    
    let mapsButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.translatesAutoresizingMaskIntoConstraints = false
        butt.addTarget(self, action: #selector(presentMaps), for: .touchUpInside)
        butt.setImage(UIImage(named: "directions"), for: .normal)
        butt.tintColor = .prideBlue
        
        return butt
    }()
    
    var mapURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 3),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -3)
            ].forEach { $0.isActive = true }
        
        addSubview(mapsButton)
        [
            mapsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mapsButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            mapsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 3),
            mapsButton.heightAnchor.constraint(equalToConstant: 44),
            ].forEach { $0.isActive = true }
        
        
    }
    
    @objc fileprivate func presentMaps() {
        if let mapsURL = mapURL {
            UIApplication.shared.open(mapsURL)
        } else {
            print("url is not valid")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class PrideAnnotation: NSObject, MKAnnotation {
    
    var lat: Double
    var long: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var title: String?
    
    var subtitle: String? = ""
    
    init(title: String?, lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        
        if let title = title {
            self.title = NSLocalizedString(title, comment: "PRIDE")
        }
        //self.subtitle = ""
    }
    
}

class PrideToiletAnnotation: PrideAnnotation {}

class PrideTentPolygon: MKPolygon {}
