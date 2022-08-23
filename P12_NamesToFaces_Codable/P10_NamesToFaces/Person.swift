//
//  Person.swift
//  P10_NamesToFaces
//
//  Created by Laura on 18.08.2022..
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name  = name
        self.image = image
    }
    
}
