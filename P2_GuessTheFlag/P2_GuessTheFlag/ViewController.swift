//
//  ViewController.swift
//  P2_GuessTheFlag
//
//  Created by Laura on 09.08.2022..
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    
    var countries     = [String]()
    var score         = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "poland",
                      "russia", "spain", "uk", "us"]
        
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn2.layer.borderColor = UIColor.lightGray.cgColor
        btn3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        btn1.setImage(UIImage(named: countries[0]), for: .normal)
        btn2.setImage(UIImage(named: countries[1]), for: .normal)
        btn3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    

}

