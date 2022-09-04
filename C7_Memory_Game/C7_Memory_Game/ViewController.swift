//
//  ViewController.swift
//  C7_Memory_Game
//
//  Created by Laura on 04.09.2022..
//

import UIKit

class ViewController: UICollectionViewController {                // or CollectionViewController?

    @IBOutlet var flipsLabel: UILabel!
    
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

    }

    @IBAction func newGameTapped(_ sender: Any) {
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
    }
}

