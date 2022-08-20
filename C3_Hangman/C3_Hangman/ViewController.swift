//
//  ViewController.swift
//  C3_Hangman
//
//  Created by Laura on 20.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var wordsToGuess = [String]()
    var guessesLabel: UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.textAlignment = .center
        guessesLabel.text = "Guesses left: dunno"
        view.addSubview(guessesLabel)
        
        NSLayoutConstraint.activate([
            guessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            guessesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
    }
    
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

