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
    var tapCounter    = 0
    var highScore     = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "score", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "poland",
                      "russia", "spain", "uk", "us"]
        
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn2.layer.borderColor = UIColor.lightGray.cgColor
        btn3.layer.borderColor = UIColor.lightGray.cgColor
        
        loadHighScore()
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        btn1.setImage(UIImage(named: countries[0]), for: .normal)
        btn2.setImage(UIImage(named: countries[1]), for: .normal)
        btn3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "  score: \(score)"
        
        if tapCounter == 10 {
            
            let finalScoreAlert = UIAlertController(title: title, message: "This was round 10, your final score is \(score)", preferredStyle: .alert)
            
            finalScoreAlert.addAction(UIAlertAction(title: "New round", style: .default, handler: askQuestion))
            
            present(finalScoreAlert, animated: true)
            
            score = 0
            tapCounter = 0
            
        }
    }
    
    private func updateNavigationBarTitle() {
        let country = countries[correctAnswer].uppercased()
        title = "\(country) 🏅\(score)"
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        var title: String
        let correctFlag = countries[sender.tag].capitalized
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title  = "Wrong"
            
            let wrongFlagAlert = UIAlertController(title: title, message: "That's the flag of \(correctFlag)", preferredStyle: .alert)
            
            wrongFlagAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: askQuestion))
            present(wrongFlagAlert, animated: true)
            
            score -= 1
        }
        
        let scoreAlert = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)     // .alert brings message box across the screen -> situation change, alternative is action sheet which slides in up from the bottom -> choosing options
        
        scoreAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))   // uses UIAlertAction that addes button to the alert that says continue, styles: default, cancel, destructive, handler looks for a closure (code that can be exc when btn is tapped, we want to continue the game so we pass askQuestion
        
        present(scoreAlert, animated: true)     // 2 params: a view controller to present and whether to animate presentation, optional 3rd param to call a closure when pres animation finishes
    
        tapCounter += 1
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            if self.tapCounter < 10 {
                self.askQuestion()
            } else {
                self.showFinalScore()
            }
        }))
    }
    
    @objc func showScore() {
        
        let showScoreAlert = UIAlertController(title: nil, message: "Your score is \(score)", preferredStyle: .actionSheet)
        showScoreAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(showScoreAlert, animated: true)
        
    }
    
    private func loadHighScore() {
        if let highScore = UserDefaults.standard.value(forKey: "highScore") as? Int {
            self.highScore = highScore
        }
    }
    
    private func showFinalScore() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
            title = "Game Over with new HighScore of \(highScore)!"
        } else {
            title = "Game Over"
        }
        
        let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: { _ in
            self.score = 0
            self.askQuestion()
        }))
        present(ac, animated: true)
    }
    
    
}

