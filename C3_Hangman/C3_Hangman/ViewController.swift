//
//  ViewController.swift
//  C3_Hangman
//
//  Created by Laura on 20.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var wordsToGuess = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWords()
    }

    func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {          // load into words
                wordsToGuess = words.components(separatedBy: "\n")
                print(wordsToGuess)
            }
        }
        
        if wordsToGuess.isEmpty {
            let ac = UIAlertController(title: "Error loading words", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

