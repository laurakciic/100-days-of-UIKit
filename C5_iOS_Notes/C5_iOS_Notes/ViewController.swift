//
//  ViewController.swift
//  C5_iOS_Notes
//
//  Created by Laura on 30.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var notes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note
        
        return cell
    }
}

