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
}

