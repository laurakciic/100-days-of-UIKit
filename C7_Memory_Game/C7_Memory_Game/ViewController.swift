//
//  ViewController.swift
//  C7_Memory_Game
//
//  Created by Laura on 04.09.2022..
//

import UIKit

class ViewController: UICollectionViewController {                // or CollectionViewController?

    @IBOutlet var flipsLabel: UILabel!
    
    var counter = 0
    var firstCardIndexPath: IndexPath?
    
    var cards = [Card]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var flips = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flips)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCards()
    }

    private func fetchCards() {
        cards   = CardController.fetchCards()
        counter = CardController.fetchCards().count
    }
    
    private func checkMatch(secondCardPath: IndexPath) {
        guard let firstCardPath = firstCardIndexPath else { return }
        
        let firstCell = collectionView.cellForItem(at: firstCardPath) as? CardCell
        let secondCell = collectionView.cellForItem(at: secondCardPath) as? CardCell
        
        let firstCard  = cards[firstCardPath.row]
        let secondCard = cards[secondCardPath.row]
        
        if firstCard.name == secondCard.name {
            
            firstCard.isMatch = true
            secondCard.isMatch = true
            
            firstCell?.clearCards()
            secondCell?.clearCards()
            counter -= 2
            checkGameOver()
        } else {
            
            firstCard.isFlipped  = false
            secondCard.isFlipped = false
            
            firstCell?.flipBack()
            secondCell?.flipBack()
        }
        
        firstCardIndexPath = nil
    }
    
    private func checkGameOver() {
        if counter == 0 {
            let ac = UIAlertController(title: "Victory!", message: "Ready for another round?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Ready!", style: .default) {
                [weak self] _ in
                self?.cards.removeAll()
                self?.flips = 0
                self?.fetchCards()
            })
            present(ac, animated: true)
        }
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        cards.removeAll()
        flips = 0
        fetchCards()
    }
    
    
    // MARK: Delegates
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else { return UICollectionViewCell() }
        
        let card = cards[indexPath.row]
        cell.card = card
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardCell = collectionView.cellForItem(at: indexPath) as! CardCell
        let card     = cards[indexPath.row]
        
        // check flip & match
        if !card.isFlipped && !card.isMatch  {
            cardCell.flip()
            card.isFlipped = true
            
            if firstCardIndexPath != nil {
                checkMatch(secondCardPath: indexPath)
            } else {
                firstCardIndexPath = indexPath
            }
            flips += 1
        }
    }
}

