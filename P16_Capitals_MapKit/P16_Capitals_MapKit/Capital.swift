//
//  Capital.swift
//  P16_Capitals_MapKit
//
//  Created by Laura on 28.08.2022..
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {

    var title:      String?
    var info:       String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title      = title
        self.coordinate = coordinate
        self.info       = info
    }
}
