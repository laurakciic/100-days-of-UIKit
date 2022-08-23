//
//  Person.swift
//  P10_NamesToFaces
//
//  Created by Laura on 18.08.2022..
//

import UIKit

class Person: NSObject, NSCoding {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name  = name
        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    // encoding - writing for disk
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
}
