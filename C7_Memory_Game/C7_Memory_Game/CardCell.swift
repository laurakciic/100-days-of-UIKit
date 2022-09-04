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
        guard let card = card else { return }
        
        if card.isMatch {
            backCardView.alpha  = 0
            frontCardView.alpha = 0
            return
        } else {
            backCardView.alpha  = 1
            frontCardView.alpha = 1
        }
        frontCardView.image = UIImage(named: card.name)
        frontCardView.contentMode = .scaleAspectFit
        
        if card.isFlipped {
            UIView.transition(from: backCardView, to: frontCardView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews])
        } else {
            UIView.transition(from: frontCardView, to: backCardView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func flip() {
        UIView.transition(from: backCardView, to: frontCardView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontCardView, to: self.backCardView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func clearCards() {
        backCardView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontCardView.alpha = 0
        }, completion: nil)
    }
}
