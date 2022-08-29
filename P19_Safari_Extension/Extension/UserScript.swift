//
//  UserScript.swift
//  Extension
//
//  Created by Laura on 29.08.2022..
//

import Foundation

class UserScript: Codable {
    var name:   String
    var script: String
    
    init(name: String, script: String) {
        self.name   = name
        self.script = script
    }
}
