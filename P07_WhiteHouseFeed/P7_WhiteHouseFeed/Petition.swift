//
//  Petition.swift
//  P7_WhiteHouseFeed
//
//  Created by Laura on 16.08.2022..
//

import Foundation

struct Petition: Codable {      // Codable protocol makes it decodable from JSON
    
    var title: String
    var body: String
    var signatureCount: Int
}
