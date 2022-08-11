//
//  ViewController.swift
//  P5_AnagramWordGame
//
//  Created by Laura on 10.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var allWords  = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {                        // load into startWords
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }


    func startGame() {
        title = allWords.randomElement()                // title of VC
        usedWords.removeAll(keepingCapacity: true)      // removes all values from usedWords array, bc it will be used to store user's answers, also making sure when new round comes up, old guesses are removed
        tableView.reloadData()                          // reload all rows and sections - great for changing lvl's in game
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]     // table View will show all the words user found so far, so as they find words, they'll be added to usedWords and appear on tableView straight away
        
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {    // closure instead of handler with trailing syntax
            [weak self, weak ac] _ in                                           // both alert controller and view controller are referenced inside closure so they need to be weakly referenced -> ac? i self?
            guard let answer = ac?.textFields?[0].text else { return }          // body of closure
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
            
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {                                  // not used before
                if isReal(word: lowerAnswer)    {
                    usedWords.insert(answer, at: 0)                             // insert in usedWords array at 0 - top position of table view
                    
                    let indexPath = IndexPath(row: 0, section: 0)               // ask table view to insert a row at that position - top
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return true
    }
    
    func isReal(word: String) -> Bool {
        return true
    }

}

