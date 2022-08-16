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
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),            // layoutMarginsGuide - scoreLabel will have distance from the right edges
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            
            // more constraints will be here
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

