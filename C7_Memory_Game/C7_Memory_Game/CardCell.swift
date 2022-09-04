//
//  CardCell.swift
//  C7_Memory_Game
//
//  Created by Laura on 04.09.2022..
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet var frontCardView: UIImageView!
    @IBOutlet var backCardView: UIView!
    
    var card: Card? {
        didSet {
            makeCard()
        }
    }
    
    private func makeCard() {
        
    }
}
