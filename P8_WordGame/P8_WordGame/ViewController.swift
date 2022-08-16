//
//  ViewController.swift
//  P8_WordGame
//
//  Created by Laura on 16.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    override func loadView() {          // main view inside here
        view = UIView()                 // parent class of all UIKit's view types - labels, buttons, progress views...
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false    // bc constraints will be made programatically, by hand
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0                                    // wraps all it's clues around as many lines as it takes
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false                 // so they can't activate the textbox
        view.addSubview(currentAnswer)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),               // layoutMarginsGuide - scoreLabel will have distance from the right edges
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),                 // margin from the left
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),   // 60% of the width of the layout margins -100 for leading edge margin
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),             // pull it in from the right edge
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),                     // match the height of the clues label so they stay the same no matter what
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),          // half the width of the screen
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20)         // 20 points below the clues label
            
            // more constraints will be here
        ])
        
        cluesLabel.backgroundColor = .systemMint
        answerLabel.backgroundColor = .systemIndigo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

