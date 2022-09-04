//
//  CardController.swift
//  C7_Memory_Game
//
//  Created by Laura on 04.09.2022..
//

import Foundation

class CardController {
    
    private static func fetchCards() -> [Card] {
        
        var cards = [Card]()
        var usedNumbers = [Int]()
        
        while usedNumbers.count < 4 {
            
            let randomInt = Int.random(in: 1...4)
            
            if !usedNumbers.contains(randomInt) {
                let card1 = Card(name: "c\(randomInt)")
                cards.append(card1)
                let card2 = Card(name: "c\(randomInt)")
                cards.append(card2)
                
                usedNumbers.append(randomInt)
            }
        }
        return cards.shuffled()
    }
}
