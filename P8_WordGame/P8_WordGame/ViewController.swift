//
//  ViewController.swift
//  P8_WordGame
//
//  Created by Laura on 16.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    override func loadView() {          // main view inside here
        view = UIView()                 // parent class of all UIKit's view types - labels, buttons, progress views...
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false                                    // bc constraints will be made programatically, by hand
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0                                                                    // wraps all it's clues around as many lines as it takes
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false                                                  // so they can't activate the textbox
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)                    // when the user presses submit btn, call submit tapped on the current vc
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)                      // .touchUpInside - when btn is pressed down on
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),               // layoutMarginsGuide - scoreLabel will have distance from the right edges
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),                 // margin from the left
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),   // 60% of the width of the layout margins -100 for leading edge margin
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),             // pull it in from the right edge
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),                     // match the height of the clues label so they stay the same no matter what
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),          // half the width of the screen
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),        // 20 points below the clues label
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),                 // move to the right of the center, away from the submit btn
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),                              // keep them aligned
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 350),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            // more constraints will be here
        ])
        
        let width = 150     // some values to height and width to make code easy to read
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterBtn = UIButton(type: .system)
                letterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterBtn.setTitle("WWW", for: .normal)
                letterBtn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterBtn.frame = frame
                buttonsView.addSubview(letterBtn)
                letterButtons.append(letterBtn)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        
    }
    
    func loadLevel() {
        var clueString     = ""             // will hold the full string shown in the cluesLabel, clue numbers, and clue hex themself
        var solutionString = ""             // will hold text shown inside answersLabel
        var letterBits     = [String]()     // will hold all the possible letter parts in level
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {                              //
                var lines = levelContents.components(separatedBy: "\n")                                 // making individual lines, splits up all 7 clues into individual lines we can read through
                lines.shuffle()                                                                         // mixing them up, each time player plays, it's different order
                
                // looping over the lines using enumerated method
                for (index, line) in lines.enumerated() {                                               // tuple bc enumerated returns us 2 values each time
                    let parts  = line.components(separatedBy: ": ")                                     // takes the line and splits it into 2 parts
                    let answer = parts[0]                                                               // left
                    let clue   = parts[1]                                                               // right
                    
                    clueString += "\(index + 1). \(clue)\n"                                             // npr. 1. ghost and residents
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString  += "\(solutionWord.count) letters\n"                                // 7 letters, 9 letters..
                    solutions.append(solutionWord)                                                      // to know what to look for
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits                                                                  // add those bits to the full collection of all our letter bits
                    
                }
            }
        }
        
        cluesLabel.text   = clueString.trimmingCharacters(in: .whitespacesAndNewlines)                  // trim final line breaks from the clue and solution string and put them into clues and answers label
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {                                                    // should always be the case, but just to be sure
            for i in 0..<letterButtons.count {                                                          // counts through all letter buttons, 0-19
                letterButtons[i].setTitle(letterBits[i], for: .normal)                                  // asign that butttons title to be the matching bit in letter bits array
            }
        }
    }

}

