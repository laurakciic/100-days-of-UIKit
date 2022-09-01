//
//  ViewController.swift
//  P2_GuessTheFlag
//
//  Created by Laura on 09.08.2022..
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var btn1: UIButton!
    @IBOutlet private var btn2: UIButton!
    @IBOutlet private var btn3: UIButton!
    
    private var countries      = [String]()
    private var score          = 0
    private var correctAnswer  = 0
    private var questionsAsked = 0
    private var highScore      = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarItems()
        configureButtons()
        loadCountriesArray()
        askQuestion()
    }
    
    private func addBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "score", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showScore))
    }
    
    private func configureButtons() {
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn2.layer.borderColor = UIColor.lightGray.cgColor
        btn3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func loadCountriesArray() {
        countries += ["estonia", "france", "germany", "ireland","italy", "monaco", "nigeria", "poland","russia", "spain", "uk", "us"]
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        btn1.setImage(UIImage(named: countries[0]), for: .normal)
        btn2.setImage(UIImage(named: countries[1]), for: .normal)
        btn3.setImage(UIImage(named: countries[2]), for: .normal)
        updateNavigationBarTitle()
    }
    
    private func updateNavigationBarTitle() {
        let country = countries[correctAnswer].uppercased()
        title = "\(country) 🏅\(score)"
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            self.checkAnswer(answer: sender.tag)
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func checkAnswer(answer: Int) {
        var title:   String
        var message: String?
        
        if answer == correctAnswer {
            title   = "Correct!"
            message = nil
            score  += 1
        } else {
            title   = "Wrong!"
            message = "That's the flag of \(countries[answer].uppercased())"
            score  -= 1
        }
        questionsAsked += 1
        updateNavigationBarTitle()

        showAlert(title: title, message: message, buttonTitle: "Continue") {
            if self.questionsAsked < 10 {
                self.askQuestion()
            } else {
                self.showFinalScore()
            }
        }
    }
    
    private func showFinalScore() {
        showAlert(title: "Game Over", message: "Your final score is \(score)", buttonTitle: "Play Again") {
            self.score          = 0
            self.questionsAsked = 0
            self.askQuestion()
        }
    }
    
    @objc func showScore() {
        showAlert(title: "Score", message: "Your score is \(score)", buttonTitle: "Continue") {  }
    }
    
    private func showAlert(title: String, message: String?, buttonTitle: String, action: @escaping () -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {
            _ in action()
        }))
        present(ac, animated: true)
    }
    
}

