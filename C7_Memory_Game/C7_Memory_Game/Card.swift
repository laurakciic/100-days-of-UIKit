//
//  Card.swift
//  C7_Memory_Game
//
//  Created by Laura on 04.09.2022..
//

import UIKit

class Card: NSObject {
    
    var name: String?
    var isFlipped: Bool = false
    var isMatch:   Bool = false
    
    init(name: String) {
        self.name = name
    }
}
