//
//  ViewController.swift
//  C3_Hangman
//
//  Created by Laura on 20.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var wordList    = [String]()
//    var usedLetters = [String]()
    var wordToGuess = "empty"
    
    var wordToGuessLabel:  UILabel!
    
    var levelLabel:   UILabel!
    var lossLabel:    UILabel!
    
    var charButtons = [UIButton]()
    
    var level = 1 {
        willSet {
            levelLabel.text = "Level: \(newValue)"
        }
    }
    
    var loss = 0 {
        willSet {
            lossLabel.text = "Loses: \(newValue)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: 1"
        levelLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(levelLabel)
        
        lossLabel = UILabel()
        lossLabel.translatesAutoresizingMaskIntoConstraints = false
        lossLabel.text = "Loses: 0"
        lossLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(lossLabel)
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        wordToGuessLabel.textAlignment = .center
        view.addSubview(wordToGuessLabel)
        
        let charButtonsGroup = UIView()
        charButtonsGroup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charButtonsGroup)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            levelLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            lossLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 10),
            lossLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            wordToGuessLabel.topAnchor.constraint(equalTo: lossLabel.bottomAnchor, constant: 40),
            wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            charButtonsGroup.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 30),
            charButtonsGroup.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 127),
            charButtonsGroup.widthAnchor.constraint(equalToConstant: 650),
            charButtonsGroup.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        let height = 30
        let width = 30
        
        for row in 0..<2 {
            for column in 0..<13 {
                let letterBtn = UIButton(type: .system)
                letterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                //letterBtn.setTitle("A", for: .normal)
                letterBtn.setTitleColor(.systemTeal, for: .normal)
                letterBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterBtn.frame = frame
                
                letterBtn.layer.borderWidth = 1
                letterBtn.layer.borderColor = UIColor.lightGray.cgColor
                
                charButtonsGroup.addSubview(letterBtn)
                charButtons.append(letterBtn)
                
            }
        }
        
        for (index, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
            charButtons[index].setTitle(String(char).uppercased(), for: .normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hangmanGame()
    }
    
    func hangmanGame() {
        loadWords()
                        
        wordToGuessLabel.text = String.init(repeating: "?", count: wordToGuess.count)
        
        
//        usedLetters.removeAll(keepingCapacity: true)
    }
    
    func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {          // load into words
                wordList = words.components(separatedBy: "\n")
                wordToGuessLabel.text = words.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if wordList.isEmpty {
            let ac = UIAlertController(title: "Error loading words", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        wordToGuess = wordList[level]
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let char = sender.titleLabel?.text else { return }
        
        if wordToGuess.contains(char.lowercased()) {
            var parts = wordToGuessLabel.text?.map { $0.uppercased() }                                  // replaces ? with guessed letter/s
            
            for (index, item) in wordToGuess.enumerated() {
                if String(item) == char.lowercased() {
                    parts![index] = char.uppercased()                                                   // guessed letter
                }
            }
            wordToGuessLabel.text = parts?.joined()                                                     // joines guessed letter/s with previous ones to help form the whole word

        } else {
            loss += 1
        }
        checkGameStatus()
    }
    
    func checkGameStatus() {
        if loss == 7 {
            let ac = UIAlertController(title: "Game Lost", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default) {
                [weak self] _ in
                self?.loss = 0
                self?.hangmanGame()
            })

            present(ac, animated: true)
            
        } else if wordToGuessLabel.text?.lowercased() == wordToGuess {
            let ac = UIAlertController(title: "You guessed the word!", message: "Congrats, ready for the next one?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ready!", style: .default) {
                [weak self] _ in
                self?.loss = 0
                self?.level += 1
                self?.hangmanGame()
            })
            present(ac, animated: true)
        }
    }
    
    

}

