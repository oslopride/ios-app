//
//  MapCoordinates.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 26/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import MapKit

class MapCoordinates {
    
    let paradeCoordinates = [
        CLLocationCoordinate2D(latitude: 59.911959, longitude: 10.766269),
        CLLocationCoordinate2D(latitude: 59.912717, longitude: 10.762831),
        CLLocationCoordinate2D(latitude: 59.913728, longitude: 10.756480),
        CLLocationCoordinate2D(latitude: 59.913269, longitude: 10.753398),
        CLLocationCoordinate2D(latitude: 59.912731, longitude: 10.751032),
        
        // Jernbanetorget
        CLLocationCoordinate2D(latitude: 59.912290, longitude: 10.750702),
        CLLocationCoordinate2D(latitude: 59.912319, longitude: 10.749284),
        CLLocationCoordinate2D(latitude: 59.912493, longitude: 10.748354),
        
        // Kirkeristen
        CLLocationCoordinate2D(latitude: 59.912824, longitude: 10.747845),
        CLLocationCoordinate2D(latitude: 59.912977, longitude: 10.746627),
        
        // Grensen
        CLLocationCoordinate2D(latitude: 59.912781, longitude: 10.746136),
        CLLocationCoordinate2D(latitude: 59.914920, longitude: 10.740041),
        CLLocationCoordinate2D(latitude: 59.915684, longitude: 10.737576),
        
        // Karl Johan
        CLLocationCoordinate2D(latitude: 59.914562, longitude: 10.736250),
        CLLocationCoordinate2D(latitude: 59.913780, longitude: 10.738823),
        CLLocationCoordinate2D(latitude: 59.913132, longitude: 10.738024)
    ]
    
    let parkCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913771, longitude: 10.738799), // Top Right
        CLLocationCoordinate2D(latitude: 59.913155, longitude: 10.738037), // Bottom right
        CLLocationCoordinate2D(latitude: 59.913791, longitude: 10.735421),
        CLLocationCoordinate2D(latitude: 59.913850, longitude: 10.735207), // Bottom left
        CLLocationCoordinate2D(latitude: 59.914361, longitude: 10.735804), // Mid Left
        CLLocationCoordinate2D(latitude: 59.914299, longitude: 10.736034), // Mid Right
        CLLocationCoordinate2D(latitude: 59.914529, longitude: 10.736252), // Top left
        CLLocationCoordinate2D(latitude: 59.913771, longitude: 10.738799),
        
        ]
    
    let atmCoordinates = [
        // Nordea Olav Vs gate 7
        CLLocationCoordinate2D(latitude: 59.912715, longitude: 10.732401),
        // Nordea Stortovet 7
        CLLocationCoordinate2D(latitude: 59.912903, longitude: 10.744246),
        CLLocationCoordinate2D(latitude: 59.913266, longitude: 10.744509),
        // Munchs Gate 1
        CLLocationCoordinate2D(latitude: 59.916993, longitude: 10.741921),
        //
    ]
    
    let spikersuppaWaterFountainSmallCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913734, longitude: 10.737817),
        CLLocationCoordinate2D(latitude: 59.913849, longitude: 10.737446),
        CLLocationCoordinate2D(latitude: 59.913708, longitude: 10.737301),
        CLLocationCoordinate2D(latitude: 59.913601, longitude: 10.737665),
        CLLocationCoordinate2D(latitude: 59.913734, longitude: 10.737817)
    ]
    
    let spikersuppaWaterFountainLargeCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913723, longitude: 10.737256),
        CLLocationCoordinate2D(latitude: 59.913921, longitude: 10.736561),
        CLLocationCoordinate2D(latitude: 59.914059, longitude: 10.736721),
        CLLocationCoordinate2D(latitude: 59.913860, longitude: 10.737407),
        CLLocationCoordinate2D(latitude: 59.913724, longitude: 10.737256),
    ]
    
    // MARK:- Forests
    let spikersuppaPrideBarForestCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913506, longitude: 10.738153),
        CLLocationCoordinate2D(latitude: 59.913372, longitude: 10.738004),
        CLLocationCoordinate2D(latitude: 59.913517, longitude: 10.737496),
        
        CLLocationCoordinate2D(latitude: 59.913570, longitude: 10.737556),
        CLLocationCoordinate2D(latitude: 59.913624, longitude: 10.737375),
        CLLocationCoordinate2D(latitude: 59.913443, longitude: 10.737164),
        
        CLLocationCoordinate2D(latitude: 59.913200, longitude: 10.737986),
        CLLocationCoordinate2D(latitude: 59.913467, longitude: 10.738290),
    ]
    
    // Start: Mid park, closest to the parliment
    let parkPrideUngForest = [
        CLLocationCoordinate2D(latitude: 59.913540, longitude: 10.738354),
        CLLocationCoordinate2D(latitude: 59.913761, longitude: 10.738605),
        CLLocationCoordinate2D(latitude: 59.913818, longitude: 10.738401),
        CLLocationCoordinate2D(latitude: 59.913727, longitude: 10.738297),
        CLLocationCoordinate2D(latitude: 59.913815, longitude: 10.737996),
        CLLocationCoordinate2D(latitude: 59.913731, longitude: 10.737910),
        CLLocationCoordinate2D(latitude: 59.913715, longitude: 10.737963),
        CLLocationCoordinate2D(latitude: 59.913750, longitude: 10.738007),
        CLLocationCoordinate2D(latitude: 59.913658, longitude: 10.738328),
        CLLocationCoordinate2D(latitude: 59.913574, longitude: 10.738234)
    ]
    
    let parkStandgateStortingetForest = [
        CLLocationCoordinate2D(latitude: 59.913776, longitude: 10.737865),
        CLLocationCoordinate2D(latitude: 59.913883, longitude: 10.737499),
        CLLocationCoordinate2D(latitude: 59.913952, longitude: 10.737578),
        CLLocationCoordinate2D(latitude: 59.913845, longitude: 10.737945)
    ]
    
    let parkStandgateSlottetForest = [
        CLLocationCoordinate2D(latitude: 59.913986, longitude: 10.737195),
        CLLocationCoordinate2D(latitude: 59.914108, longitude: 10.736775),
        CLLocationCoordinate2D(latitude: 59.914165, longitude: 10.736837),
        CLLocationCoordinate2D(latitude: 59.914040, longitude: 10.737262)
    ]
    
    let parkMainsceneSlottetForest = [
        CLLocationCoordinate2D(latitude: 59.914059, longitude: 10.736038),
        CLLocationCoordinate2D(latitude: 59.914219, longitude: 10.736230),
        CLLocationCoordinate2D(latitude: 59.914268, longitude: 10.736067),
        CLLocationCoordinate2D(latitude: 59.914104, longitude: 10.735879)
    ]
    
    
    // MARK:- Bars
    let parkMainBarCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913883, longitude: 10.735662),
        CLLocationCoordinate2D(latitude: 59.913742, longitude: 10.736230),
        CLLocationCoordinate2D(latitude: 59.913834, longitude: 10.736319),
        CLLocationCoordinate2D(latitude: 59.913975, longitude: 10.735741),
        CLLocationCoordinate2D(latitude: 59.913883, longitude: 10.735662),
    ]
    
    let parkPrideBarCoordinates = [
        CLLocationCoordinate2D(latitude: 59.913521, longitude: 10.737523),
        CLLocationCoordinate2D(latitude: 59.913380, longitude: 10.738023),
        CLLocationCoordinate2D(latitude: 59.913452, longitude: 10.738101),
        CLLocationCoordinate2D(latitude: 59.913589, longitude: 10.737601),
        CLLocationCoordinate2D(latitude: 59.913521, longitude: 10.737523),
    ]
    
    let parkEurozone = [
        CLLocationCoordinate2D(latitude: 59.913696, longitude: 10.737340),
        CLLocationCoordinate2D(latitude: 59.913761, longitude: 10.737416),
        CLLocationCoordinate2D(latitude: 59.913712, longitude: 10.737585),
        CLLocationCoordinate2D(latitude: 59.913647, longitude: 10.737511)
    ]
    
    let klubben = [
        CLLocationCoordinate2D(latitude: 59.913532, longitude: 10.736917),
        CLLocationCoordinate2D(latitude: 59.913708, longitude: 10.737130),
        CLLocationCoordinate2D(latitude: 59.913651, longitude: 10.737316),
        CLLocationCoordinate2D(latitude: 59.913475, longitude: 10.737108)
    ]
    
    
}


class ForestPolygon: MKPolygon {}
